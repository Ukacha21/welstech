import 'package:flutter/material.dart';
// import 'services/api_service.dart';
// import 'services/bluetooth_api.dart';
// import 'services/bluetooth_service.dart';
import 'services/flutter_plus_api.dart';
import 'services/multicast_api.dart';
import 'services/esp_ap_client.dart';
import 'dart:async';
// import 'dart:async';
// import 'package:multicast_dns/multicast_dns.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

final flutterReactiveBle = FlutterReactiveBle();

final Uuid serviceUuid = Uuid.parse("0000180F-0000-1000-8000-00805f9b34fb");
final Uuid characteristicUuid = Uuid.parse("00002A19-0000-1000-8000-00805f9b34fb");

String calibrate_text = "Sync Bracelet";
String _bpm_subtext = "Bracelet not synced"; //Syncing Failed

// import 'package:flutter/material.dart';

void showWarningDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("⚠️ Warning"),
        content: Text(message),
        actions: [
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
        ],
      );
    },
  );
}


class Control_Screen extends StatefulWidget {
  const Control_Screen({super.key});

  @override
  Control_ScreenState createState() => Control_ScreenState();
}



class Control_ScreenState extends State<Control_Screen> {
  String control_Screen_Main_Label = "Heart Rate Control";
  String _bpm_text = "---"; // Initially set the BPM value
  // int _bpm_text = 72; // Initially set the BPM value
  bool sync_connected = false;//implement check connection first, before seting to false

  // String? fetched_BPM;
  dynamic fetched_BPM;

  // double? temperature;
  // double? humidity;

  // void getData() async {
  //   try {
  //     var data = await ApiService.fetchSensorData();
  //     setState(() {
  //       temperature = data['temp'];
  //       humidity = data['hum'];
  //     });
  //   } catch (e) {
  //     print('Error: $e');
  //   }
  // }

  // dynamic fetchData() async {
  //   try {
  //     var data = await ApiService.fetchSensorData();
  //     // if (data.length > 8)
  //     return data['bpm'];
  //     // return data.length;//get bpm later
  //     // return data;
  //   } catch (e) {
  //     // print('Error: $e');
  //   }
  // }
  Timer? _timer;

  final BluetoothAPI bluetooth = BluetoothAPI();
  String receivedText = "WFD";

  @override
  void initState() {
    super.initState();
    bluetooth.onDataReceived = (String data) {
      setState(() {
        receivedText = data;
      });
    };
  }

  @override
  void dispose() {
    bluetooth.disconnect();
    super.dispose();
  }

  // Fetch the data and calibrate
  Future<String> fetchBTData2() async {
    try {
      String data = await bluetooth.calibrate();
      setState(() {
        receivedText = data;
        try{
      
        sync_connected = bluetooth.isConnected == true ? true : false; //to change the collor 

        }
        catch (e){}
        
      });
    } catch (e) {
      setState(() {
        receivedText = "Error: $e";
      });
    }
    if (sync_connected!=true || bluetooth.isConnected != true){
      bluetooth.connectToESP32(); // Automatically tries to connect
    }
    return receivedText;
  }

  // ElevatedButton(
  //   onPressed: () async {
  //     await bluetoothApi.connectToESP32(deviceName: "ESP32_BT");
  //   },
  //   child: const Text('Connect to ESP32'),
  // ),
  // ElevatedButton(
  //   onPressed: fetchData,  // Fetch and calibrate data
  //   child: const Text('Calibrate'),

  dynamic fetchBTData() async {

    
    bluetooth.onDataReceived = (data) {
      setState(() {
        receivedText += data;
        try{
      
        sync_connected = bluetooth.isConnected == true ? true : false; //to change the collor 

        }
        catch (e){}

      });
    };
    if (sync_connected!=true || bluetooth.isConnected != true){
      bluetooth.connectToESP32(); // Automatically tries to connect
    }
    return receivedText;
  }

  // Function to simulate reading and calibrating pulse
  //function to read sync and calibrate

  DiscoveredDevice? espDevice;
  StreamSubscription<ConnectionStateUpdate>? connectionSubscription;

  Future<void> bleConnect() async {
    setState(() {
      sync_connected = false;
    });

    // Declare scanSub before it's used
    late StreamSubscription<DiscoveredDevice> scanSub;

    scanSub = flutterReactiveBle.scanForDevices(
      withServices: [], //or omit it
      // withServices: [serviceUuid],
      scanMode: ScanMode.lowLatency,
    ).listen((device) {
      if (device.name == "ESP32_BT-BLE") {
        espDevice = device;
        scanSub.cancel(); // cancel the scan once device is found
      }
    });

    await Future.delayed(Duration(seconds: 10));
    await scanSub.cancel();

    if (espDevice == null) {
      print("❌ Device not found");
      setState(() {
        sync_connected = false;
        _bpm_subtext = "Device not found!";
      });
      return;
    }

    final completer = Completer<void>();

    connectionSubscription = flutterReactiveBle.connectToDevice(
      id: espDevice!.id,
      connectionTimeout: Duration(seconds: 10),
    ).listen((event) {
      if (event.connectionState == DeviceConnectionState.connected) {
        print("Connected");
        setState(() {
          sync_connected = true;
        });
        completer.complete();
      } else if (event.connectionState == DeviceConnectionState.disconnected) {
        print("🔌 Disconnected");
        setState(() {
          sync_connected = false;
        });
        completer.complete();
      }
    });

    await completer.future;
}

  //this sync fetches data via bluetooth
  Future<String> syncWithEsp32() async {
    // If not connected, return "no data"
    if (!sync_connected) {
      print("⚠️ Not connected to BLE");
      return "no data";
    }

    final completer = Completer<String>();
    final char = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: characteristicUuid,
      deviceId: espDevice!.id,
    );

    // Listen for data from the characteristic
    flutterReactiveBle.subscribeToCharacteristic(char).listen((value) async {
      final text = String.fromCharCodes(value);
      print("📨 Received: $text");

      // Complete the future with the received data
      completer.complete(text);

      // After receiving the data, disconnect and reset connection status
      await connectionSubscription?.cancel();
      setState(() {
        sync_connected = false;
      });
    });

    // Timeout in case no data is received within 5 seconds
    return completer.future.timeout(Duration(seconds: 5), onTimeout: () {
      print("⏰ Timeout — no data received");
      // Reset connection status if timed out
      setState(() {
        sync_connected = false;
      });
      return "no data";
    });
  }

  //get wifi data
  Future<String> getWifiDataFromEsp() async {
    final espSync = EspSync();
    final response = await espSync.fetchHelloWorld();
    print("📨 Response: $response");
    return response;
  }

  Future<String> getHTTPData() async {
    final espClient = EspAccessPointClient();
    String message = await espClient.fetchHelloFromESP();
    print("Message from ESP: $message");
    return message;
    }

  Future<void> readNCalibrate() async {
    if (sync_connected) {
      // Already connected
      setState(() {
        calibrate_text = "In Sync";
        _bpm_subtext = "Fetching Data";
      });

      _timer?.cancel();
      _timer = Timer(Duration(seconds: 4), () async {
        print("Reading Pulse");

        try {
          String tempres = await syncWithEsp32();
          setState(() {
            _bpm_subtext = sync_connected ? "BPM" : "Connection Lost";
            calibrate_text = sync_connected ? "In Sync" : "Sync Bracelet";

            if (tempres.isNotEmpty && tempres.length >= 15) {
              _bpm_text = sync_connected ? "2Big" : "---";
            } else {
              _bpm_text = sync_connected ? "${tempres.substring(0, 4)} " : "---";
            }
          });
        } catch (e) {
          print("Error fetching BT data: $e");
        }

        print("sync state: $sync_connected");
      });
    } else {
        // 🔧 Fix: Await the connection before proceeding
        // setState(() {
        //   calibrate_text = "Syncing";
        //   print("syncing");
        //   _bpm_subtext = sync_connected ? "BPM" : "Syncing";
        //   _bpm_text = "---";
        // });
        

        // setState(() {
        //   // calibrate_text = "Syncing";
        //   _bpm_subtext = sync_connected ? "BPM" : "Syncing failed";
        //   // _bpm_text = "---";
        // });

        // _timer?.cancel();
        // _timer = Timer(Duration(seconds: 4), () {
        //   // print("Syncing bracelet");

        //   setState(() {
        //     calibrate_text = sync_connected ? "In Sync" : "Sync Bracelet";
        //   });
        // });

        //temporary wifi state----------------
        // First, await the asynchronous method to get the data from the ESP
        print("tryin........");
        // String data = await getWifiDataFromEsp();
        String retrieved_data = await getHTTPData();

        // Now use setState to update the UI with the retrieved data
        setState(() {

          _bpm_text = retrieved_data.length <= 18 ? retrieved_data : "Error";
        });

        
        // showWarningDialog(context, "Something went wrong!");
        showWarningDialog(context, "$retrieved_data");
      



    }
    print("sync state: $sync_connected");
}

  

  // @override
  // void initState() {
  //   super.initState();
  //   bluetooth.onDataReceived = (data) {
  //     setState(() {
  //       receivedText += data;
  //       try{
      
  //       sync_connected = BluetoothAPI().isConnected == true ? true : false; //to change the collor 

  //       }
  //       catch (e){}

  //     });
  //   };
  //   bluetooth.connectToESP32(); // Automatically tries to connect
  // }

  // @override
  // void dispose() {
  //   bluetooth.disconnect();
  //   super.dispose();
  //   setState(() {
  //     try{
      
  //       sync_connected = BluetoothAPI().isConnected == true ? true : false; //to change the collor 

  //     }
  //     catch (e){}

  //   });

    
  // }


  // The widget tree that displays the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('$control_Screen_Main_Label')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50.0,
          ),
          // Display the BPM value
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,//bpm circle
                border: Border.all(color: sync_connected == true ?  Colors.blue : Colors.red, width: 6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_bpm_text',
                    style: TextStyle(
                      fontSize: 74,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 221, 226, 230),
                    ),
                  ),
                  Text(
                    '$_bpm_subtext',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 220, 222, 224),
                    ),
                  ),
                  SizedBox(height: 4),
                  Icon(
                    Icons.favorite,
                    size: 26,
                    color: sync_connected == true ?  Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
          ),
          // Spacer to push the button to the bottom
          Spacer(),
          // Calibrate Button
          Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: readNCalibrate, // Call the function to read and update BPM
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                  decoration: BoxDecoration(
                    border: Border.all(color: sync_connected == true ?  Colors.blue : Colors.red, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, color: sync_connected == true ?  Colors.blue : Colors.red, size: 32),
                      SizedBox(width: 8),
                      Text(
                        calibrate_text,
                        style: TextStyle(
                          color: Color.fromARGB(255, 230, 217, 216),
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class Stats_Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('History & Stats', style: TextStyle(fontSize: 24)),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final _pageController = PageController();

  final List<Widget> _screens = [
    Control_Screen(),
    Stats_Screen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.toll_outlined), label: 'Control'),
          BottomNavigationBarItem(icon: Icon(Icons.webhook_rounded), label: 'Stats'),
        ],
      ),
    );
  }
}

class MainRunnerApp extends StatelessWidget {
  const MainRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      title: 'Welstech',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

void main() {
  runApp(const MainRunnerApp());
}
