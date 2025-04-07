import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ReadWiseApp());
}

class ReadWiseApp extends StatelessWidget {
  const ReadWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ReadWise+',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
