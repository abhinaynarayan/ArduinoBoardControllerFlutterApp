// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'led_control_page.dart';
//
// class MainPageScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: BluetoothApp(),
//     );
//   }
// }
//
// class BluetoothApp extends StatefulWidget {
//   @override
//   _BluetoothAppState createState() => _BluetoothAppState();
// }
//
// class _BluetoothAppState extends State<BluetoothApp> {
//   FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
//   List<BluetoothDevice> _devicesList = [];
//   BluetoothDevice? _connectedDevice;
//   BluetoothConnection? connection;
//
//   @override
//   void initState() {
//     super.initState();
//     checkPermissionsAndInitBluetooth();
//     _getDevices();
//     // requestBluetoothPermissions();
//     // requestPermissions();
//   }
//
//   Future<void> checkPermissionsAndInitBluetooth() async {
//     // Request multiple permissions at once
//     final permissions = [
//       Permission.bluetooth,
//       Permission.bluetoothConnect,
//       Permission.bluetoothScan,
//       Permission.location,
//     ];
//     final statuses = await permissions.request();
//
//     // Check if any permissions are not granted
//     if (statuses.values.any((status) => !status.isGranted)) {
//       // Show an alert or take appropriate action
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text("Some permissions were not granted"),
//       ));
//       return;
//     }
//
//     // Initialize Bluetooth if permissions are granted
//     _getDevices();
//   }
//
//   // String status = 'false';
//
//   Future<void> checkPermission(
//       Permission permission, BuildContext context) async {
//     try {
//       final status = await permission.request();
//       if (status.isGranted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Permission is Granted")));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Permission is not Granted")));
//       }
//     } catch (e) {
//       print("bluetooth status error: $e");
//     }
//   }
//
//   Future<void> _getDevices() async {
//     List<BluetoothDevice> devices = [];
//
//     try {
//       devices = await _bluetooth.getBondedDevices();
//     } catch (e) {
//       print("Error getting bonded devices: $e");
//     }
//
//     setState(() {
//       _devicesList = devices;
//     });
//   }
//
//   Future<void> _connectToDevice(BluetoothDevice device) async {
//     try {
//       connection = await BluetoothConnection.toAddress(device.address);
//       print("Connected to ${device.name}");
//       setState(() {
//         _connectedDevice = device;
//       });
//
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => LEDControlPage(connection: connection!),
//       //   ),
//       // );
//     } catch (e) {
//       print("Connection failed: $e");
//     }
//   }
//
//   void navigateToLedPage() {
//     if (connection != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => LEDControlPage(connection: connection!),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No device connected!")),
//       );
//     }
//   }
//
//
//   void disconnectBluetoothDevice() {
//     try {
//       connection = null;
//       connection?.finish();
//       connection?.dispose();
//       connection?.close();
//     } catch (e) {
//       print("Disconnection error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bluetooth Scanner'),
//       ),
//       body: Column(
//         children: <Widget>[
//           ElevatedButton(
//             onPressed: () => _getDevices(),
//             child: Text("Scan Devices"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               checkPermission(Permission.bluetooth, context);
//             },
//             // onPressed: () => Null,
//             child: Text("Permission"),
//           ),
//           ElevatedButton(
//               onPressed: () => disconnectBluetoothDevice(),
//               child: Text("Disconnect")),
//           ElevatedButton(
//               onPressed: () => navigateToLedPage(),
//               child: Text("Led Page")
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _devicesList.length,
//               itemBuilder: (context, index) {
//                 BluetoothDevice device = _devicesList[index];
//                 return ListTile(
//                   title: Text(_devicesList[index].name ?? 'Unknown Device'),
//                   subtitle: Text(device.address),
//                   onTap: () {
//                     _connectToDevice(device);
//                   },
//                 );
//               },
//             ),
//           ),
//           _connectedDevice != null
//               ? Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child:
//                       Text('Connected to: ${_connectedDevice?.name ?? 'None'}'),
//                 )
//               : Container(),
//         ],
//       ),
//     );
//   }
// }
//



import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'led_control_page.dart';
import 'devices_page.dart';
import 'dart:typed_data'; // For Uint8List
import 'dart:convert'; // For utf8



class MainPageScreen extends StatelessWidget {
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
  bool _isLedOn = false;
  bool device1State = false;
  bool device2State = false;
  bool device3State = false;

  @override
  void initState() {
    super.initState();
    checkPermissionsAndInitBluetooth();
  }

  Future<void> checkPermissionsAndInitBluetooth() async {
    final permissions = [
      Permission.bluetooth,
      Permission.bluetoothConnect,
      Permission.bluetoothScan,
      Permission.location,
    ];
    final statuses = await permissions.request();

    if (statuses.values.any((status) => !status.isGranted)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Some permissions were not granted")),
      );
      return;
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    try {
      connection = await BluetoothConnection.toAddress(device.address);
      print("Connected to ${device.name}");
      setState(() {
        _connectedDevice = device;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LEDControlPage(connection: connection!),
        ),
      );
    } catch (e) {
      print("Connection failed: $e");
    }
  }

  void _navigateToDevicesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DevicesPage(
          onDeviceSelected: (device) {
            _connectToDevice(device);
          },
        ),
      ),
    );
  }

  void disconnectBluetoothDevice() {
    try {
      connection?.finish();
      connection = null;
    } catch (e) {
      print("Disconnection error: $e");
    }
  }

  void _toggleDevice(int deviceNumber, bool state) {
    if (connection != null && connection!.isConnected) {
      setState(() {
        _isLedOn = !_isLedOn;
      });

      String command;
    switch (deviceNumber) {
      case 1:
        command = state ? '1' : '0';
        break;
      case 2:
        command = state ? '3' : '2';
        break;
      case 3:
        command = state ? '5' : '4';
        break;
      default:
        return;
    }
    print(command);
    print(deviceNumber);
      connection!.output.add(Uint8List.fromList(utf8.encode(command + "\r\n")));
      connection!.output.allSent.then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("LED ${_isLedOn ? 'ON' : 'OFF'}")),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No device connected!")),
      );
    }
  }


    void navigateToLedPage() {
    if (connection != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LEDControlPage(connection: connection!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No device connected!")),
      );
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
            onPressed: _navigateToDevicesPage,
            child: Text("Show Devices"),
          ),
          ElevatedButton(
              onPressed: () => disconnectBluetoothDevice(),
              child: Text("Disconnect")),
          ElevatedButton(
              onPressed: () => navigateToLedPage(),
              child: Text("Led Page")),
          // SwitchListTile(
          //   title: Text("LED Bulb"),
          //   value: _isLedOn,
          //   onChanged: (value) {
          //     // _toggleLed();
          //   },
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Device 1'),
                  Switch(
                    value: device1State,
                    onChanged: (value) {
                      setState(() {
                        device1State = value;
                        _toggleDevice(1, value);
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Device 2'),
                  Switch(
                    value: device2State,
                    onChanged: (value) {
                      setState(() {
                        device2State = value;
                        _toggleDevice(2, value);
                      });
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Device 3'),
                  Switch(
                    value: device3State,
                    onChanged: (value) {
                      setState(() {
                        device3State = value;
                        _toggleDevice(3, value);
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          _connectedDevice != null
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Connected to: ${_connectedDevice?.name ?? 'None'}'),
          )
              : Container(),
        ],
      ),
    );
  }
}





//
// import 'package:flutter/material.dart';
// import 'bluetooth_handler.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final BluetoothHandler _bluetoothHandler = BluetoothHandler();
//   bool device1State = false;
//   bool device2State = false;
//   bool device3State = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _bluetoothHandler.connectToDevice();
//   }
//
//   @override
//   void dispose() {
//     _bluetoothHandler.disconnectDevice();
//     super.dispose();
//   }
//
//   void _toggleDevice(int deviceNumber, bool state) {
//     String command;
//     switch (deviceNumber) {
//       case 1:
//         command = state ? '1' : '0';
//         break;
//       case 2:
//         command = state ? '3' : '2';
//         break;
//       case 3:
//         command = state ? '5' : '4';
//         break;
//       default:
//         return;
//     }
//     _bluetoothHandler.sendData(command);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home Automation'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text('Device 1'),
//                 Switch(
//                   value: device1State,
//                   onChanged: (value) {
//                     setState(() {
//                       device1State = value;
//                       _toggleDevice(1, value);
//                     });
//                   },
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text('Device 2'),
//                 Switch(
//                   value: device2State,
//                   onChanged: (value) {
//                     setState(() {
//                       device2State = value;
//                       _toggleDevice(2, value);
//                     });
//                   },
//                 ),
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Text('Device 3'),
//                 Switch(
//                   value: device3State,
//                   onChanged: (value) {
//                     setState(() {
//                       device3State = value;
//                       _toggleDevice(3, value);
//                     });
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
