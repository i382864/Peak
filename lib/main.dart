import 'package:figmaas/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
  Gemini.init(apiKey: GEMINI_API_KEY,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF2A1B5D),
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}