import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'devices_page.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'led_control_page.dart';
import 'devices_page.dart';
import 'dart:typed_data'; // For Uint8List
import 'dart:convert'; // For utf8
import 'ui1.dart';


class uiapp extends StatefulWidget {
  @override
  _UiAppState createState() => _UiAppState();
}

class _UiAppState extends State<uiapp> {
  int _selectedIndex = 0;

  // List of destinations corresponding to BottomNavigationBar items
  final List<Widget> _pages = [
    MainPageScreen(),
    // DevicesPage(),
    // AlertsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate to the corresponding page
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
        child: Column(
          children: [
            // Top section with name and greeting
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
                        'Home Automnation',
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
                    backgroundImage: AssetImage('assets/profile.png'), // Replace with your image
                  ),
                ],
              ),
            ),
            // Tabs
            TabBarSection(),
            // Devices grid wrapped in an Expanded widget
            Expanded(child: DevicesGrid()),
          ],
        ),
      ),
      // Bottom navigation
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
  final List<Map<String, dynamic>> devices = [
    {'name': 'Air Conditioner', 'icon': Icons.ac_unit},
    {'name': 'Smart TV', 'icon': Icons.tv},
    {'name': 'Lights', 'icon': Icons.lightbulb_outline},
    {'name': 'Refrigerator', 'icon': Icons.kitchen},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.8, // Adjust the aspect ratio if needed
        ),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return DeviceCard(
            deviceName: devices[index]['name']!,
            iconData: devices[index]['icon']!,
          );
        },
      ),
    );
  }
}

class DeviceCard extends StatelessWidget {
  final String deviceName;
  final IconData iconData;

  const DeviceCard({
    required this.deviceName,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(iconData, size: 48.0, color: Colors.black),
            SizedBox(height: 16.0),
            Text(
              deviceName,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0),
            Switch(
              value: true,
              onChanged: (value) {},
              activeColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
