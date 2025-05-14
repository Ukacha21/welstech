import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothAPI {
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  String receivedData = "";
  Function(String)? onDataReceived;

  // Request necessary permissions for Bluetooth
  Future<void> requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();
  }

  // Scan and connect to the device by its name
  Future<void> connectToESP32({String deviceName = "ESP32_BT"}) async {
    await requestPermissions();

    _flutterBlue.startScan(timeout: Duration(seconds: 4));

    _flutterBlue.scanResults.listen((results) async {
      for (ScanResult result in results) {
        if (result.device.name == deviceName) {
          _device = result.device;
          await _device!.connect();
          print('Connected to ESP32: ${_device!.id}');
          await discoverServices();
          _flutterBlue.stopScan();
          break;
        }
      }
    });
  }

  // Discover Bluetooth services and find characteristics
  Future<void> discoverServices() async {
    if (_device == null) return;

    List<BluetoothService> services = await _device!.discoverServices();
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.read || characteristic.properties.notify) {
          _characteristic = characteristic;
          await characteristic.setNotifyValue(true);
          characteristic.value.listen((data) {
            final newData = String.fromCharCodes(data);
            receivedData += newData;
            print('Received: $newData');
            if (onDataReceived != null) {
              onDataReceived!(newData);
            }
          });
          break;
        }
      }
    }
  }

  // Calibrate function to fetch data from Bluetooth and return it
  Future<String> calibrate() async {
    if (_device == null) {
      throw Exception("Device not connected");
    }

    // Simulate waiting for data if necessary
    await Future.delayed(Duration(seconds: 1)); // Adjust this delay as needed

    return receivedData;
  }

  // Disconnect from the device
  void disconnect() {
    _device?.disconnect();
    _device = null;
    _characteristic = null;
  }

  // Check if the device is connected
  bool get isConnected => _device?.state == BluetoothDeviceState.connected;
}
