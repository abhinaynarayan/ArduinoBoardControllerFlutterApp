// import 'package:flutter_blue/flutter_blue.dart';
//
// class BluetoothHandler {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   BluetoothDevice? connectedDevice;
//
//   Future<void> connectToDevice() async {
//     flutterBlue.startScan(timeout: Duration(seconds: 5));
//     await for (var result in flutterBlue.scanResults) {
//       for (ScanResult r in result) {
//         if (r.device.name == "HC-05") {
//           await flutterBlue.stopScan();
//           await r.device.connect();
//           connectedDevice = r.device;
//           print('Connected to ${r.device.name}');
//           break;
//         }
//       }
//     }
//   }
//
//   Future<void> sendData(String data) async {
//     if (connectedDevice != null) {
//       List<BluetoothService> services = await connectedDevice!.discoverServices();
//       for (BluetoothService service in services) {
//         for (BluetoothCharacteristic characteristic in service.characteristics) {
//           if (characteristic.properties.write) {
//             await characteristic.write(data.codeUnits);
//             print('Sent data: $data');
//           }
//         }
//       }
//     }
//   }
//
//   Future<void> disconnectDevice() async {
//     if (connectedDevice != null) {
//       await connectedDevice!.disconnect();
//       print('Disconnected');
//     }
//   }
// }
