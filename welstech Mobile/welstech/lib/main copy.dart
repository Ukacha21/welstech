import 'package:flutter/material.dart';
// import 'package:flutter/web_ui.dart' as ui;
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  @override
  _SwitchListState createState() => _SwitchListState();
}

class _SwitchListState extends State<MainScreen> {
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

  String appBarLabel = "Enie";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('$appBarLabel')),
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
                appBarLabel = '$switchLabel is $res';
                //handle other raspberry pi and database changes
                switchStates[switchLabel] = value; // Update the state of the switch
              });
              // print('$switchLabel is ${switchStates[switchLabel]}');

            },
          );
        }).toList(),
      ),
    
      bottomNavigationBar: 
      Container(
        margin: EdgeInsets.only(bottom: 5.0, right: 6.0, left: 6.0), // Adjust to raise the navbar
        decoration: BoxDecoration(
        color: const Color.fromARGB(255, 12, 15, 123),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),  // Adjust the radius as needed
          topRight: Radius.circular(16), // Adjust the radius as needed
          bottomLeft: Radius.circular(16),  // bottom left and
          bottomRight: Radius.circular(16), // bottom right are removable
        ),
        ),
        child: BottomNavigationBar( 
          items: [
            BottomNavigationBarItem(icon: const Icon(Icons.model_training_sharp), label: 'Control'), //center_focus_strong_outlined, model_training_sharp
            BottomNavigationBarItem(icon: Icon(Icons.camera), label: 'CCTV'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
          backgroundColor: Colors.transparent,
          
        ),
      )
      
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
    home: MainScreen(),
  ));
}
