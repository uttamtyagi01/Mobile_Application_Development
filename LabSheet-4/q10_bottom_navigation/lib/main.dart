import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NavigationScreen(),
    );
  }
}

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    Center(child: Text('First Screen', style: TextStyle(fontSize: 24))),
    Center(child: Text('Second Screen', style: TextStyle(fontSize: 24))),
    Center(child: Text('Third Screen', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Three Screens')),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.looks_one), label: 'First'),
          BottomNavigationBarItem(icon: Icon(Icons.looks_two), label: 'Second'),
          BottomNavigationBarItem(icon: Icon(Icons.looks_3), label: 'Third'),
        ],
      ),
    );
  }
}
