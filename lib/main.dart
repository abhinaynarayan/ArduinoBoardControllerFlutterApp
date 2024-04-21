import 'package:ardcontroller/MainPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: MainPage());
//   }
// }

// class MainpageViewColon extends StatelessWidget {
//   const MainpageViewColon({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Center(child: Text("Hello World"));
//   }
// }

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
    _getDevices();
    requestBluetoothPermissions();
  }

  Future<void> requestBluetoothPermissions() async {
    var status = await Permission.bluetooth.request();
    if (status.isGranted) {
      // Permission is granted.
    } else if (status.isDenied) {
      // Permission is denied.
    } else if (status.isPermanentlyDenied) {
      // Permission is permanently denied, navigate the user to app settings.
      openAppSettings();
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

      // Handle the connection, send and receive data here

      // Don't forget to close the connection when done
      // connection.finish();
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
      print("Disconnectio error: $e");
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
            onPressed: () => requestBluetoothPermissions(),
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
