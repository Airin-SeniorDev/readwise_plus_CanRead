import 'package:flutter/material.dart';
import 'voiceread_screen.dart';
import 'pricescan_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ReadWise+')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VoiceReadScreen()),
                );
              },
              icon: const Icon(Icons.mic),
              label: const Text('VoiceRead Mode'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PriceScanScreen()),
                );
              },
              icon: const Icon(Icons.search),
              label: const Text('PriceScan Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
