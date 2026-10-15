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
    home: const AuthErrorPage(),
  );
}

class AuthErrorPage extends StatefulWidget { const AuthErrorPage({super.key}); @override State<AuthErrorPage> createState()=>_AuthErrorPageState(); }
class _AuthErrorPageState extends State<AuthErrorPage>{final email=TextEditingController(),password=TextEditingController();bool busy=false;
 Future<void> login()async{setState(()=>busy=true);try{await FirebaseAuth.instance.signInWithEmailAndPassword(email:email.text.trim(),password:password.text);if(mounted)ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Login successful')));}on FirebaseAuthException catch(e){if(mounted)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text('Login failed: ${e.message??e.code}')));}finally{if(mounted)setState(()=>busy=false);}}
 @override void dispose(){email.dispose();password.dispose();super.dispose();}
 @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Q5 Authentication Errors')),body:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[const Text('Try an invalid email or password to see an error SnackBar.'),TextField(controller:email,decoration:const InputDecoration(labelText:'Email')),TextField(controller:password,obscureText:true,decoration:const InputDecoration(labelText:'Password')),FilledButton(onPressed:busy?null:login,child:Text(busy?'Please wait…':'Login'))])));
}
