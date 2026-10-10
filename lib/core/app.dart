import 'package:flutter/material.dart';
import '../presentation/screens/auth/login_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Titan Core Banking',
      home: LoginScreen(),
    );
  }
}