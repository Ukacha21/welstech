import 'package:flutter/material.dart';
// import 'package:flutter/web_ui.dart' as ui;
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';


//example of setstate
// int _counter = 0;

// String _bpm_text = "73---";
// dynamic _bpm_text = 73;
// int _bpm_text = 73;
final String calibrate_text = "Read/Calibrate Pulse";




class Control_Screen extends StatefulWidget {
  const Control_Screen({super.key}); //maybe unnecessary
  @override
  Control_ScreenState createState() => Control_ScreenState();
}

class Control_ScreenState extends State<Control_Screen> {
  // @override

  String CCTV_BarLabel = "heart rate control  ";

  // int _bpm_text = 76;
  String _bpm_text = "81";


  final List<Widget> _items = [];

  // @override
  void Read_n_Calibrate() {
    // void initState() {
      // super.Read_n_Calibrate();
      //get the cloud bpm value from here
      setState(() { //and then set the state here
        print("Reading Pulse");
        _bpm_text = "---";
      });
    // }

  }

  // Call add functions betteeen here 
  // @override
  //you need initstate to add widgets to the dymanic list
  void initState() {
    super.initState();
    

    _items.add(const SizedBox(
        height: 80.0
        ));


    _items.add(
        Center(
          child: Container(
            width: 300,
              height: 300,
              
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // color: Colors.white, 
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
                      color: const Color.fromARGB(255, 221, 226, 230),
                    ),
                  ),
                Text(
                    'BPM',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 220, 222, 224),
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
        ));
        //end of main bpm circle

    _items.add(const SizedBox(
        height: 210.0
        ));

    // _items.add(// Spacer pushes the button to the bottom
    //         Spacer());
    // _items.add(ElevatedButton(
    //         onPressed: Read_n_Calibrate,  // Call the function to read and update BPM
    //         child: Text('Read & Calibrate'),
    //       ),
    //       );
          
    _items.add(
      Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: Read_n_Calibrate,
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




          // ElevatedButton(
          //     onPressed: () {},
          //     style: ElevatedButton.styleFrom(
          //       shape: StadiumBorder(),
          //       padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          //       backgroundColor: Colors.blue,
          //     ),
          //     child: Text(
          //       'Read Pulse',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ));

        // OutlinedButton(
        //   onPressed: () {},
        //   style: OutlinedButton.styleFrom(
        //     side: BorderSide(color: Colors.blue, width: 2),
        //     shape: StadiumBorder(), // Optional: pill shape
        //     padding: EdgeInsets.symmetric(horizontal: 2, vertical: 12),
        //     tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Avoid extra padding
        //     minimumSize: Size(0, 0), // Let it size naturally
        //   ),
        //   child: Text(
        //     'Read Pulse',
        //     style: TextStyle(color: Colors.blue, fontSize: 16),
        //   ),
        // )

    );

    

    // add other widgets here if necessary
  }

  //and here to add the items to the cctv screen

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Center(child: Text('$CCTV_BarLabel')),
      ), 
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return _items[index]; // Display each widget in the list
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Stats_Screen extends StatefulWidget {
  @override
  Stats_ScreenState createState() => Stats_ScreenState();

}

class Stats_ScreenState extends State<Stats_Screen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('History & Stats', style: TextStyle(fontSize: 24)),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key}); //maybe unnecessary
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {

  // String homeScreenBarLabel = "Home Control";

  int _selectedIndex = 0;
  final _pageController = PageController();
  // PageController _pageController = PageController();

  //list of screens
  final List<Widget> _screens = [
    // SwitchScreen(), //disabled temporarily to check loading issues
    Control_Screen(),
    Stats_Screen(),
  ];

  // void updateAppbarLabel(String label) { {
  //   setState(() {
  //     globalAppBarLabel = label;
  //   });
  // }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
      // _pageController.jumpToPage(index);
      // print('Page index: $_selectedIndex');
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: Text('$homeScreenBarLabel')),
      // ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index when page is swiped
          });
        },
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, //BottomNavigationBarType.shifting
        // backgroundColor: Colors.transparent,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // When a navigation item is tapped
        items:  
            const <BottomNavigationBarItem>[
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.camera), //model_training_sharp
              //   label: 'Control'), //center_focus_strong_outlined, model_training_sharp
              BottomNavigationBarItem(icon: Icon(Icons.toll_outlined), label: 'Control'),
              // BottomNavigationBarItem(icon: Icon(Icons.multiline_chart_outlined), label: 'Database'), //light
              BottomNavigationBarItem(icon: Icon(Icons.webhook_rounded), label: 'Stats'), //webhook_rounded
            ],
            ),
    );
  }

}

class mainRunnerApp extends StatelessWidget{
  const mainRunnerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      themeMode: ThemeMode.dark,
      title: 'welstech',
      theme: ThemeData(
          brightness: Brightness.dark, // Dark theme
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // useMaterial3: true,
        ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    // home: DemoState(), // this is just for demo
  );
    // throw UnimplementedError();
  }
}

void main() {
  runApp(const mainRunnerApp());

}
