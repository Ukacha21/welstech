import 'package:flutter/material.dart';
// import 'package:flutter/web_ui.dart' as ui;
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// dynamic globalAppBarLabel = "Enie Home Controll";

class DemoState extends StatefulWidget{
  Demo createState() => Demo();
}

class Demo extends State<DemoState> {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Hello there')),
      ),
      body: 
        const Center(
          child: Text("centered text"),
        ),
    );
  }
}

class SwitchScreen extends StatefulWidget {
  @override
  SwitchListState createState() => SwitchListState();
}

class SwitchListState extends State<SwitchScreen> {
  
  String switchScreenBarLabel = "Switch Control";
  
  // A map to store the state of each switch
  Map<String, bool> switchStates = {
    'Front Door': false,
    'Back Door': false,
    'Alarm Systems': true,
    'Compound Lights': false,
    'House Main Lights': false,
    'RGB TapeLights': false,
    'House Kitchen Lights': false,
   
    'Garage Gate': true,
    'Small Gate': true,

    'Rooms Fire Systems': false,
    'General Fire Systems': true,
    'Compjound Lights': false,
    'Windows / Curtains': true,
  };



  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Center(child: Text('$switchScreenBarLabel')),
      ),
      
      body: ListView(
        children: switchStates.keys.map((switchLabel) {
          return SwitchListTile(
            title: Text(switchLabel),
            value: switchStates[switchLabel]!,
            onChanged: (bool value) {
              setState(() {
                //call other functions that will handle the state change
                String res = (switchStates[switchLabel] == true ) ? 'close' : 'open';
                switchScreenBarLabel = '$switchLabel is $res';
                print(switchScreenBarLabel);
                //handle other raspberry pi and database changes
                switchStates[switchLabel] = value; // Update the state of the switch
              });
              // print('$switchLabel is ${switchStates[switchLabel]}');

            },
          );
        }).toList(),
      ),
  
      
    );
  }
}

class Control_Screen extends StatefulWidget {
  @override
  CCTV_ScreenState createState() => CCTV_ScreenState();
}

class CCTV_ScreenState extends State<Control_Screen> {
  // @override
  String CCTV_BarLabel = "heart rate control  ";

  final List<Widget> _items = [];

  // Function to add a new item
  // void _addItem() {
  //   setState(() {
  //     _items.add(_items.length + 1); // Add a new item (incremental number)
  //   });
  // }

  // Function to add a container
  void _addContainer() {
    setState(() {
      _items.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Text(
            'This is a container',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    });
  }

  // Function to add a text item
  void _addText(String passedText) {
    setState(() {
      _items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            '$passedText',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ),
      );
    });
  }

  // Function to add an image
  void _addImage() {
    setState(() {
      _items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Image.network(
            'https://via.placeholder.com/150',
            height: 150.0,
          ),
        ),
      );
    });
  }

  // Call add functions betteeen here 
  @override
  //you need initstate to add widgets to the dymanic list
  void initState() {
    super.initState();
    // _addContainer(); // Automatically add a container when the app starts
    // _items.add( //for cctv1 - living room
    //     Container(
    //       margin: EdgeInsets.symmetric(vertical: 8.0),
    //       padding: EdgeInsets.all(16.0),
    //       decoration: BoxDecoration(
    //         color: Colors.blue[600],
    //         borderRadius: BorderRadius.circular(10.0),
    //       ),
    //       child: 
    //         Column(
    //           children: [
    //             Row(
    //               children: [
    //                 Image.asset("assets/icons/icon.png",
    //                   scale: 30,),
    //                 const SizedBox(
    //                   width: 20.0
    //                 ),
    //                 const Text(
    //                 'Living room',
    //                 style: TextStyle(fontSize: 18.0),
    //                 ),
    //               ],
    //             ),
    //             Center(
    //               child: Container(
    //                 margin: EdgeInsets.symmetric(vertical: 8.0),
    //                 padding: EdgeInsets.all(16.0),
    //                 child: Image.asset(// replace image.asset with  the retrieved video/footage
    //                   "assets/icons/icon.png",
    //                   scale: 20,
    //                   height: 150.0,
    //                 ),
    //               )
    //             ),
    //           ],
    //         ),
    //     ),
    //   );

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
                    '72--',
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

    _items.add(const SizedBox(
        height: 210.0
        ));

    // _items.add(// Spacer pushes the button to the bottom
    //         Spacer());
    
    _items.add(
      Center(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                print('Custom icon button tapped!');
              },
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
                      'Calibrate Pulse',
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

  //     Column(
  //     children: [
  //       Row(
  //         children: [
  //           Spacer(),
  //         ],
  //       ), // This only works if the parent allows it (e.g., in a full-height Column)

  //      Center(
  //       child: TextButton.icon(
  //         onPressed: () {
  //           print('Custom icon button tapped!');
  //         },
  //         icon: Icon(
  //           Icons.favorite,
  //           color: Colors.blue,
  //           size: 32, //heart or other icons size
  //         ),
  //         label: Text(
  //           'Read Pulse',
  //           style: TextStyle(
  //             color: Color.fromARGB(255, 230, 217, 216),
  //             fontSize: 20, // text size
  //           ),
  //         ), 
  //       style: TextButton.styleFrom(
  //           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //           side: BorderSide(color: Colors.blue, width: 2),
  //           shape: StadiumBorder(),
  //         ),
  //       ),
  //            ),
  //   ],
  // )



      // Center(
      //   child: IconButton(
      //     onPressed: () {
      //       print('Custom icon button tapped!');
      //     },
      //     icon: Row(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
              
      //         Icon(
      //           Icons.favorite, 
      //           color: Colors.blue,
      //           size: 32, //this sise is for the icon, and does not affect the text font size
      //           ),
                
      //         SizedBox(width: 4),
              
      //         const Text('Read Pulse', style: TextStyle(color: const Color.fromARGB(255, 230, 217, 216), fontSize: 20)),
      //       ],
          
      //     ),
      //     )
      //   )
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

    
    //continues adding the other CCTV items here

    // _items.add(
    //   Row(
    //     children: [
    //       Image.asset("assets/icons/icon.png",
    //       scale: 9,),
    //     ],
    //   )
    // );

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
class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();

}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Settings Screen', style: TextStyle(fontSize: 24)),
    );
  }
}

class HomeScreen extends StatefulWidget {
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
    SettingsScreen(),
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
              BottomNavigationBarItem(icon: Icon(Icons.webhook_rounded), label: 'Settings'), //webhook_rounded
            ],
            ),
    );
  }

}


void main() {
  runApp(MaterialApp(
    themeMode: ThemeMode.dark,
    title: 'Home Control',
    theme: ThemeData(
        brightness: Brightness.dark, // Dark theme
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
    // home: DemoState(), // this is just for demo
  ));
}
