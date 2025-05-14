import 'dart:async';
import 'dart:typed_data';
import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothAPI {
  final CentralManager _centralManager = CentralManager.instance;
  Peripheral? _device;
  Characteristic? _characteristic;
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

    _centralManager.stateChanged.listen((state) {
      if (state == BluetoothLowEnergyState.poweredOn) {
        _centralManager.startDiscovery();
      }
    });

    _centralManager.discovered.listen((event) async {
      if (event.peripheral.name == deviceName) {
        _device = event.peripheral;
        await _device!.connect();
        print('Connected to ESP32: ${_device!.identifier}');
        await discoverServices();
        _centralManager.stopDiscovery();
      }
    });
  }

  // Discover Bluetooth services and find characteristics
  Future<void> discoverServices() async {
    if (_device == null) return;

    List<Service> services = await _device!.discoverServices();
    for (Service service in services) {
      for (Characteristic characteristic in service.characteristics) {
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
  bool get isConnected => _device?.state == BluetoothPeripheralState.connected;
}
