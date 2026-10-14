import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ListView Example")),
      body: ListView(
        children: [
          ListTile(title: Text("Item 1")),
          ListTile(title: Text("Item 2")),
          ListTile(title: Text("Item 3")),
          ListTile(title: Text("Item 4")),
          ListTile(title: Text("Item 5")),
        ],
      ),
    );
  }
}
