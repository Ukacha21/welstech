import 'package:flutter/material.dart';
// import 'package:flutter/web_ui.dart' as ui;
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// dynamic globalAppBarLabel = "Enie Home Controll";

class SwitchScreen extends StatefulWidget {
  @override
  SwitchListState createState() => SwitchListState();
}

class SwitchListState extends State<SwitchScreen> {
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


  String switchScreenBarLabel = "Switch Control";

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

class CCTV_Screen extends StatefulWidget {
  @override
  CCTV_ScreenState createState() => CCTV_ScreenState();
}

class CCTV_ScreenState extends State<CCTV_Screen> {
  // @override
  String CCTV_BarLabel = "CCTV Surveilance";

  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Center(child: Text('$CCTV_BarLabel')),
      ),
    body: Center(
      child: Text('Surveilance Screen', style: TextStyle(fontSize: 24)),
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
  Widget build(
    BuildContext context) {
      return const Center(
        child: Text('Settings Screen - Welcome', style: TextStyle(fontSize: 24)),
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
    SwitchScreen(),
    CCTV_Screen(),
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
      _pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.decelerate);
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
              BottomNavigationBarItem(
                icon: Icon(Icons.toll_outlined), //model_training_sharp
                label: 'Control'), //center_focus_strong_outlined, model_training_sharp
              BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'CCTV'),
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
    home: HomeScreen(),
  ));
}
