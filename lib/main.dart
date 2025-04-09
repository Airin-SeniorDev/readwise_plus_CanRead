import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // 👈 สำคัญ
import 'package:readwise_plus/screens/home_screen.dart'; // 👈 เปลี่ยนเป็น path ของคุณ
import 'screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions.currentPlatform, // 👈 เชื่อม config Firebase
  );

  runApp(const ReadWiseApp());
}

void testReadFirebase() async {
  final snapshot = await FirebaseFirestore.instance.collection('test').get();
  for (var doc in snapshot.docs) {
    print('🔥 Firebase document: ${doc.data()}');
  }
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
