import 'package:flutter/material.dart';

class CCTV extends StatefulWidget {
  @override
  _CCTVState createState() => _CCTVState();
}

class _CCTVState extends State<CCTV> {
  // List to hold widgets of different types
  final List<Widget> _items = [];

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
  void _addText() {
    setState(() {
      _items.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'This is a text widget',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic Widgets'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _addContainer,
                child: Text('Add Container'),
              ),
              ElevatedButton(
                onPressed: _addText,
                child: Text('Add Text'),
              ),
              ElevatedButton(
                onPressed: _addImage,
                child: Text('Add Image'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CCTV(),
  ));
}
