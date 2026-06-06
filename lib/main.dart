import 'package:flutter/material.dart';
import 'presentation/screens/app_shell.dart';
import 'theme/app_theme.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PropVeil App',
      debugShowCheckedModeBanner: false,
      theme: PropveilTheme.darkTheme,
      home: const AppShell(),
    );
  }
}

