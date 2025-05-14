// lib/bluetooth_api.dart

import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothAPI {
  BluetoothConnection? _connection;
  String receivedData = "";
  Function(String)? onDataReceived;

  Future<void> requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
  }

  Future<void> connectToESP32({String deviceName = "ESP32_BT"}) async {
    await requestPermissions();

    List<BluetoothDevice> devices =
        await FlutterBluetoothSerial.instance.getBondedDevices();

    final targetDevice = devices.firstWhere(
      (d) => d.name == deviceName,
      orElse: () => throw Exception("ESP32 device not paired or not found"),
    );

    _connection = await BluetoothConnection.toAddress(targetDevice.address);
    print('Connected to ESP32: ${targetDevice.address}');

    _connection!.input!.listen((Uint8List data) {
      final newData = String.fromCharCodes(data);
      receivedData += newData;
      print('Received: $newData');

      if (onDataReceived != null) {
        onDataReceived!(newData);
      }
    }).onDone(() {
      print('Disconnected');
    });
  }

  void disconnect() {
    _connection?.dispose();
    _connection = null;
  }

  bool get isConnected => _connection?.isConnected ?? false;
}
