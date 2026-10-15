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
    home: const AuthStatePage(),
  );
}

class AuthStatePage extends StatelessWidget {const AuthStatePage({super.key});@override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q7 authStateChanges')),body:StreamBuilder<User?>(stream:FirebaseAuth.instance.authStateChanges(),builder:(context,s){if(s.connectionState==ConnectionState.waiting)return const Center(child:CircularProgressIndicator());final user=s.data;if(user==null)return const Center(child:Text('LOGIN SCREEN
No active session',textAlign:TextAlign.center));return Center(child:Column(mainAxisSize:MainAxisSize.min,children:[const Text('HOME SCREEN',style:TextStyle(fontSize:24)),Text('Signed in: ${user.email}'),FilledButton(onPressed:()=>FirebaseAuth.instance.signOut(),child:const Text('Logout'))]));}));}
}
