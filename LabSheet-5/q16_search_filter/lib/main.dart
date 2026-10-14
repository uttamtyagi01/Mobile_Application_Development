import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> names = [
    "John",
    "Emma",
    "Michael",
    "Sophia",
    "David",
    "Daniel",
    "Olivia",
    "James",
  ];

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final filteredNames = names.where((name) {
      return name.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Search Filter")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search name",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNames.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredNames[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
