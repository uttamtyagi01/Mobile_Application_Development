import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stateless vs Stateful")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatelessExample(),
            SizedBox(height: 30),
            StatefulExample(),
          ],
        ),
      ),
    );
  }
}

class StatelessExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "StatelessWidget: UI does not change",
      style: TextStyle(fontSize: 18),
    );
  }
}

class StatefulExample extends StatefulWidget {
  @override
  State<StatefulExample> createState() => _StatefulExampleState();
}

class _StatefulExampleState extends State<StatefulExample> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "StatefulWidget Count: $count",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              count++;
            });
          },
          child: Text("Increase"),
        ),
      ],
    );
  }
}
