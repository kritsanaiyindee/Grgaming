import 'package:flutter/material.dart';

class IconSelectionScreen extends StatelessWidget {
  final List<IconData> selectedIcons = [
    Icons.favorite,
    Icons.star,
    Icons.access_alarm,
    Icons.accessibility,
    // Add more icons as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select an Icon'),
      ),
      body: ListView.builder(
        itemCount: selectedIcons.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(selectedIcons[index], size: 36.0),
            title: Text(_iconName(selectedIcons[index])),
            onTap: () {
              // Handle icon selection here
              print('Selected Icon: ${_iconName(selectedIcons[index])}');
            },
          );
        },
      ),
    );
  }

  String _iconName(IconData icon) {
    return icon.toString().substring(12); // Remove the 'Icons.' prefix
  }
}