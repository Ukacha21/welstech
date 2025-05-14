import 'package:flutter/material.dart';

class SwitchList extends StatefulWidget {
  @override
  _SwitchListState createState() => _SwitchListState();
}

class _SwitchListState extends State<SwitchList> {
  // A map to store the state of each switch
  Map<String, bool> switchStates = {
    'Switch 1': false,
    'Switch 2': true,
    'Switch 3': false,
    'Switch 4': true,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Switch List'),
      ),
      body: ListView(
        children: switchStates.keys.map((switchLabel) {
          return SwitchListTile(
            title: Text(switchLabel),
            value: switchStates[switchLabel]!,
            onChanged: (bool value) {
              setState(() {
                switchStates[switchLabel] = value; // Update the state of the switch
              });
            },
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SwitchList(),
  ));
}
