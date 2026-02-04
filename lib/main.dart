import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:i_aswaq/features/auth/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const IAswaqApp());
}

class IAswaqApp extends StatelessWidget {
  const IAswaqApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'i-aswaq',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}