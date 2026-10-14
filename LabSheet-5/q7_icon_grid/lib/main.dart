import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  final List<IconData> icons = [
    Icons.home,
    Icons.person,
    Icons.settings,
    Icons.favorite,
    Icons.star,
    Icons.email,
    Icons.phone,
    Icons.camera_alt,
    Icons.map,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Icon Grid")),
      body: GridView.count(
        crossAxisCount: 3,
        children: icons.map((icon) {
          return Card(
            child: Center(
              child: Icon(
                icon,
                size: 40,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
