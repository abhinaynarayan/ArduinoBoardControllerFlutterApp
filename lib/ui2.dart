// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'devices_page.dart';
// import 'dart:typed_data';
// import 'dart:convert';
// import 'ui1.dart';
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
//   int _selectedIndex = 0;
//
//   final List<Widget> _pages = [
//     MainPageScreen(),
//     DevicesPage(
//       onDeviceSelected: (device) {},
//     ),
//   ];
//
//   FlutterBluetoothSerial _bluetooth = FlutterBluetoothSerial.instance;
//   List<BluetoothDevice> _devicesList = [];
//   BluetoothDevice? _connectedDevice;
//   BluetoothConnection? connection;
//   bool _isLedOn = false;
//   bool device1State = false;
//   bool device2State = false;
//   bool device3State = false;
//
//   @override
//   void initState() {
//     super.initState();
//     checkPermissionsAndInitBluetooth();
//     _getDevices();
//   }
//
//   Future<void> checkPermissionsAndInitBluetooth() async {
//     final permissions = [
//       Permission.bluetooth,
//       Permission.bluetoothConnect,
//       Permission.bluetoothScan,
//       Permission.location,
//     ];
//     final statuses = await permissions.request();
//
//     if (statuses.values.any((status) => !status.isGranted)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Some permissions were not granted")),
//       );
//       return;
//     }
//
//     _getDevices();
//   }
//
//   Future<void> _getDevices() async {
//     try {
//       _devicesList = await _bluetooth.getBondedDevices();
//     } catch (e) {
//       print("Error getting bonded devices: $e");
//     }
//
//     setState(() {});
//   }
//
//   Future<void> _connectToDevice(BluetoothDevice device) async {
//     try {
//       connection = await BluetoothConnection.toAddress(device.address);
//       print("Connected to ${device.name}");
//       setState(() {
//         _connectedDevice = device;
//       });
//     } catch (e) {
//       print("Connection failed: $e");
//     }
//   }
//
//   void disconnectBluetoothDevice() {
//     try {
//       connection?.finish();
//       connection = null;
//     } catch (e) {
//       print("Disconnection error: $e");
//     }
//   }
//
//   void _toggleDevice(int deviceNumber, bool state) {
//     if (connection != null && connection!.isConnected) {
//       String command;
//       switch (deviceNumber) {
//         case 1:
//           command = state ? '0' : '1';
//           break;
//         case 2:
//           command = state ? '2' : '3';
//           break;
//         case 3:
//           command = state ? '4' : '5';
//           break;
//         default:
//           return;
//       }
//
//       connection!.output.add(Uint8List.fromList(utf8.encode(command + "\r\n")));
//       connection!.output.allSent.then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Device ${deviceNumber} ${state ? 'ON' : 'OFF'}")),
//         );
//       });
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("No device connected!")),
//       );
//     }
//   }
//
//   void navigateToLedPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => uiapp(),
//       ),
//     );
//   }
//
//   void _navigateToDevicesPage() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DevicesPage(
//           onDeviceSelected: (device) {
//             _connectToDevice(device);
//           },
//         ),
//       ),
//     );
//   }
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => _pages[index]),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '85°',
//                           style: TextStyle(fontSize: 16, color: Colors.blueAccent),
//                         ),
//                         Text(
//                           'Home Automation',
//                           style: TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Text(
//                           'Hi Abhinay, 👋',
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       ],
//                     ),
//                     CircleAvatar(
//                       radius: 24,
//                       backgroundImage: AssetImage('assets/splashimg.jpg'),
//                     ),
//                   ],
//                 ),
//               ),
//               TabBarSection(),
//               DevicesGrid(toggleDeviceCallback: _toggleDevice), // Passing callback function
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_circle_outline),
//             label: 'Add',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.notifications),
//             label: 'Alerts',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         backgroundColor: Colors.white,
//       ),
//     );
//   }
// }
//
// class DevicesGrid extends StatelessWidget {
//   final Function(int, bool) toggleDeviceCallback;
//
//   DevicesGrid({required this.toggleDeviceCallback});
//
//   final List<Map<String, dynamic>> devices = [
//     {'name': 'Air Conditioner', 'icon': Icons.ac_unit, 'deviceNumber': 1},
//     {'name': 'Smart TV', 'icon': Icons.tv, 'deviceNumber': 2},
//     {'name': 'Lights', 'icon': Icons.lightbulb_outline, 'deviceNumber': 3},
//     {'name': 'Refrigerator', 'icon': Icons.kitchen, 'deviceNumber': 4},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: GridView.builder(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 1,
//           crossAxisSpacing: 16.0,
//           mainAxisSpacing: 16.0,
//           childAspectRatio: 1.5,
//         ),
//         itemCount: devices.length,
//         itemBuilder: (context, index) {
//           return DeviceCard(
//             name: devices[index]['name'],
//             icon: devices[index]['icon'],
//             deviceNumber: devices[index]['deviceNumber'],
//             toggleDeviceCallback: toggleDeviceCallback,
//           );
//         },
//       ),
//     );
//   }
// }
//
//
//
// class DeviceCard extends StatefulWidget {
//   final String name;
//   final IconData icon;
//   final int deviceNumber;
//   final Function(int, bool) toggleDeviceCallback;
//
//   DeviceCard({
//     required this.name,
//     required this.icon,
//     required this.deviceNumber,
//     required this.toggleDeviceCallback,
//   });
//
//   @override
//   _DeviceCardState createState() => _DeviceCardState();
// }
//
// class _DeviceCardState extends State<DeviceCard> {
//   bool isSwitched = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.0),
//       height: 100.0,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             spreadRadius: 3,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column( // Changed to Column to be a valid parent for Expanded
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(widget.icon, size: 35, color: Colors.black),
//           SizedBox(height: 18.0),
//           Text(
//             widget.name,
//             style: TextStyle(
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 26.0),
//           Expanded( // Ensure Expanded is used within a Flex widget
//             child: Switch(
//               value: isSwitched,
//               onChanged: (value) {
//                 setState(() {
//                   isSwitched = value;
//                 });
//                 widget.toggleDeviceCallback(widget.deviceNumber, value);
//               },
//               activeColor: Colors.black,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
// class TabBarSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Container(
//         color: Colors.white,
//         child: TabBar(
//           indicatorColor: Colors.black,
//           labelColor: Colors.black,
//           unselectedLabelColor: Colors.grey,
//           isScrollable: true,
//           tabs: [
//             Tab(text: 'Living Room'),
//             Tab(text: 'Bedroom'),
//             Tab(text: 'Kitchen'),
//             Tab(text: 'Dining Room'),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MainPageScreen());
// }



import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'devices_page.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'ui1.dart';

void main() {
  runApp(MainPageScreen());
}

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
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MainPageScreen(),
    DevicesPage(
      onDeviceSelected: (device) {},
    ),
  ];

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
    _getDevices();
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

    _getDevices();
  }

  Future<void> _getDevices() async {
    try {
      _devicesList = await _bluetooth.getBondedDevices();
    } catch (e) {
      print("Error getting bonded devices: $e");
    }

    setState(() {});
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
      connection?.finish();
      connection = null;
    } catch (e) {
      print("Disconnection error: $e");
    }
  }

  void _toggleDevice(int deviceNumber, bool state) {
    if (connection != null && connection!.isConnected) {
      String command;
      switch (deviceNumber) {
        case 1:
          command = state ? '0' : '1';
          break;
        case 2:
          command = state ? '2' : '3';
          break;
        case 3:
          command = state ? '4' : '5';
          break;
        default:
          return;
      }

      connection!.output.add(Uint8List.fromList(utf8.encode(command + "\r\n")));
      connection!.output.allSent.then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Device ${deviceNumber} ${state ? 'ON' : 'OFF'}")),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No device connected!")),
      );
    }
  }

  void navigateToLedPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => uiapp(),
      ),
    );
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _pages[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '85°',
                          style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                        ),
                        Text(
                          'Home Automation',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Hi Abhinay, 👋',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage('assets/splashimg.jpg'),
                    ),
                  ],
                ),
              ),
              TabBarSection(),
              DevicesGrid(toggleDeviceCallback: _toggleDevice), // This will remain scrollable
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Alerts',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class TabBarSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Container(
        color: Colors.white,
        child: TabBar(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabs: [
            Tab(text: 'Living Room'),
            Tab(text: 'Bedroom'),
            Tab(text: 'Kitchen'),
            Tab(text: 'Dining Room'),
          ],
        ),
      ),
    );
  }
}

class DevicesGrid extends StatelessWidget {
  final Function(int, bool) toggleDeviceCallback;

  DevicesGrid({required this.toggleDeviceCallback});

  final List<Map<String, dynamic>> devices = [
    {'name': 'Air Conditioner', 'icon': Icons.ac_unit, 'deviceNumber': 1},
    {'name': 'Smart TV', 'icon': Icons.tv, 'deviceNumber': 2},
    {'name': 'Lights', 'icon': Icons.lightbulb_outline, 'deviceNumber': 3},
    {'name': 'Refrigerator', 'icon': Icons.kitchen, 'deviceNumber': 4},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.5,
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Add your navigation code here
            },
            child: DeviceCard(
              name: devices[index]['name'],
              icon: devices[index]['icon'],
              deviceNumber: devices[index]['deviceNumber'],
              toggleDeviceCallback: toggleDeviceCallback,
            ),
          );
        },
      ),
    );
  }
}

class DeviceCard extends StatefulWidget {
  final String name;
  final IconData icon;
  final int deviceNumber;
  final Function(int, bool) toggleDeviceCallback;

  DeviceCard({
    required this.name,
    required this.icon,
    required this.deviceNumber,
    required this.toggleDeviceCallback,
  });

  @override
  _DeviceCardState createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      height: 100.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(widget.icon, size: 35, color: Colors.black),
          SizedBox(height: 18.0),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 26.0),
          Switch(
            value: isSwitched,
            onChanged: (value) {
              setState(() {
                isSwitched = value;
              });
              widget.toggleDeviceCallback(widget.deviceNumber, value);
            },
            activeColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
