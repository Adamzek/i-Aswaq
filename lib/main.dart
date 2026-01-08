import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
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
