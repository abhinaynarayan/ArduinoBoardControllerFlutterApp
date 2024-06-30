// devices_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DevicesPage extends StatefulWidget {
  final Function(BluetoothDevice) onDeviceSelected;

  DevicesPage({required this.onDeviceSelected});

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDevice> _devicesList = [];

  @override
  void initState() {
    super.initState();
    _getDevices();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Devices'),
      ),
      body: ListView.builder(
        itemCount: _devicesList.length,
        itemBuilder: (context, index) {
          BluetoothDevice device = _devicesList[index];
          return ListTile(
            title: Text(device.name ?? 'Unknown Device'),
            subtitle: Text(device.address),
            onTap: () {
              widget.onDeviceSelected(device);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
