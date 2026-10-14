import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ListTile Example")),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text("John"),
            subtitle: Text("Software Developer"),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Emma"),
            subtitle: Text("Designer"),
          ),
        ],
      ),
    );
  }
}
