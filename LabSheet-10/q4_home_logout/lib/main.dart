import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const LabApp());
}

class LabApp extends StatelessWidget {
  const LabApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
    home: const HomePage(),
  );
}

class HomePage extends StatelessWidget { const HomePage({super.key}); @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q4 Home and Logout')),body:Center(child:StreamBuilder<User?>(stream:FirebaseAuth.instance.authStateChanges(),builder:(context,s){if(s.connectionState==ConnectionState.waiting)return const CircularProgressIndicator();final user=s.data;if(user==null)return const Text('No user is signed in. Complete Q2 or Q3 first.');return Column(mainAxisSize:MainAxisSize.min,children:[const Icon(Icons.account_circle,size:72),Text('Logged in email: ${user.email}',style:const TextStyle(fontSize:18)),const SizedBox(height:16),FilledButton.icon(onPressed:()=>FirebaseAuth.instance.signOut(),icon:const Icon(Icons.logout),label:const Text('Logout')]);}))); }
}
