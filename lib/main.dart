import 'package:flutter/material.dart';
import 'presentation/screens/app_shell.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PropVeil App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1D9A8A), // teal accent
        scaffoldBackgroundColor: const Color(0xFF0A1628), // bg-canvas
      ),
      home: const AppShell(),
    );
  }
}

