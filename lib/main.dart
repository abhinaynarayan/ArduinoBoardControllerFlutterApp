import 'dart:ffi';

import 'package:ardcontroller/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BluetoothApp(),
    );
  }
}

class BluetoothApp extends StatefulWidget {
  @override
  _BluetoothAppState createState() => _BluetoothAppState();
}

class _BluetoothAppState extends State<BluetoothApp> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _connectedDevice;
  BluetoothConnection? connection;

  @override
  void initState() {
    super.initState();
    checkPermissionsAndInitBluetooth();
    _getDevices();
    // requestBluetoothPermissions();
    // requestPermissions();
  }


  Future<void> checkPermissionsAndInitBluetooth() async {
    // Request multiple permissions at once
    final permissions = [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ];
    final statuses = await permissions.request();

    // Check if any permissions are not granted
    if (statuses.values.any((status) => !status.isGranted)) {
      // Show an alert or take appropriate action
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Some permissions were not granted"),
      ));
      return;
    }

    // Initialize Bluetooth if permissions are granted
    _getDevices();
  }
  
  // String status = 'false';

  Future<void> checkPermission(Permission permission, BuildContext context) async{
    try{
      final status = await permission.request();
      if(status.isGranted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Permission is Granted")));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Permission is not Granted")));

      }
    } catch (e) {
      print("bluetooth status error: $e");
    }
  }

  Future<void> _getDevices() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await _bluetooth.getBondedDevices();
    } catch (e) {
      print("Error getting bonded devices: $e");
    }

    setState(() {
      _devicesList = devices;
    });
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      print("Connected to ${device.name}");
      setState(() {
        _connectedDevice = device;
      });

    } catch (e) {
      print("Connection failed: $e");
    }
  }

  void disconnectBluetoothDevice() {
    try {
      connection = null;
      connection?.finish();
      connection?.dispose();
      connection?.close();
    } catch (e) {
      print("Disconnection error: $e");
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Scanner'),
      ),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () => _getDevices(),
            child: Text("Scan Devices"),
          ),
          ElevatedButton(
            onPressed: (){
              checkPermission(Permission.bluetooth, context);
            },
            // onPressed: () => Null,
            child: Text("Permission"),
          ),
          ElevatedButton(
              onPressed: () => disconnectBluetoothDevice(),
              child: Text("Disconnect")),
          Expanded(
            child: ListView.builder(
              itemCount: _devicesList.length,
              itemBuilder: (context, index) {
                BluetoothDevice device = _devicesList[index];
                return ListTile(
                  title: Text(_devicesList[index].name ?? 'Unknown Device'),
                  subtitle: Text(device.address),
                  onTap: () {
                    _connectToDevice(device);
                  },
                );
              },
            ),
          ),
          _connectedDevice != null
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      Text('Connected to: ${_connectedDevice?.name ?? 'None'}'),
                )
              : Container(),
        ],
      ),
    );
  }


}
