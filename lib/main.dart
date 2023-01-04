import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sku_pramuka/screen/signin_screen.dart';
import 'package:sku_pramuka/screen/signup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pramuka',
      home: SignIn(),
    );
  }
}
