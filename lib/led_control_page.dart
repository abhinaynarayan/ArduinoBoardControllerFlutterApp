import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:convert';
import 'dart:typed_data';

class LEDControlPage extends StatefulWidget {
  final BluetoothConnection connection;

  LEDControlPage({required this.connection});

  @override
  _LEDControlPageState createState() => _LEDControlPageState();
}

class _LEDControlPageState extends State<LEDControlPage> {
  TextEditingController _messageController = TextEditingController();
  String _receivedData = '';

  @override
  void initState() {
    super.initState();
    widget.connection.input?.listen(_onDataReceived).onDone(() {
      print('Disconnected by remote request');
    });
  }

  void _onDataReceived(Uint8List data) {
    String dataString = String.fromCharCodes(data);
    setState(() {
      _receivedData += dataString;
    });
  }

  void _sendMessage(String message) async {
    if (message.isNotEmpty) {
      widget.connection.output.add(Uint8List.fromList(utf8.encode(message + "\r\n")));
      await widget.connection.output.allSent;
      print("message");
      print(message);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LED Control'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              widget.connection.close();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Send Command',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendMessage(_messageController.text);
                _messageController.clear();
              },
              child: Text('Send'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendMessage("1");
              },
              child: Text('Turn ON LED'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendMessage("0");
              },
              child: Text('Turn OFF LED'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Received Data: $_receivedData',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
