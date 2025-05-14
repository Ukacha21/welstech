import 'package:flutter/material.dart';

final String calibrate_text = "Read/Calibrate Pulse";

class Control_Screen extends StatefulWidget {
  const Control_Screen({super.key});

  @override
  Control_ScreenState createState() => Control_ScreenState();
}

class Control_ScreenState extends State<Control_Screen> {
  String CCTV_BarLabel = "Heart Rate Control";
  String _bpm_text = "81"; // Initially set the BPM value

  // Function to simulate reading and calibrating pulse
  void Read_n_Calibrate() {
    setState(() {
      print("Reading Pulse");
      _bpm_text = "---"; // Simulate updating the BPM value to "---"
    });
  }

  // The widget tree that displays the screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('$CCTV_BarLabel')),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the BPM value
          Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.blue, width: 5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$_bpm_text',
                    style: TextStyle(
                      fontSize: 54,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 221, 226, 230),
                    ),
                  ),
                  Text(
                    'BPM',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 220, 222, 224),
                    ),
                  ),
                  SizedBox(height: 4),
                  Icon(
                    Icons.favorite,
                    size: 16,
                    color: Colors.red,
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
                onTap: Read_n_Calibrate, // Call the function to read and update BPM
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 40),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, color: Colors.blue, size: 32),
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
