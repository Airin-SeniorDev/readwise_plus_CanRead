import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../services/ocr_web_service.dart';
import '../services/tts_service_web.dart'; // ✅ เรียกใช้ TTS static

class VoiceReadScreen extends StatefulWidget {
  const VoiceReadScreen({super.key});

  @override
  State<VoiceReadScreen> createState() => _VoiceReadScreenState();
}

class _VoiceReadScreenState extends State<VoiceReadScreen> {
  Uint8List? _imageBytes;
  String scannedText = 'ยังไม่ได้สแกนภาพ';
  bool isLoading = false;

  Future<void> _pickImageAndScan() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;

      setState(() {
        _imageBytes = bytes;
        isLoading = true;
        scannedText = '🔄 กำลังสแกนข้อความ...';
      });

      final text = await OCRWebService.scanImage(bytes);

      setState(() {
        scannedText = text;
        isLoading = false;
      });

      // ✅ ใช้ static method ของ TTSWebService
      TTSWebService.speak(text);
    } else {
      setState(() {
        scannedText = '❌ ไม่ได้เลือกรูปภาพ';
      });
    }
  }

  void _speakAgain() {
    // ✅ ใช้ static method ของ TTSWebService
    TTSWebService.speak(scannedText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VoiceRead')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickImageAndScan,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Image & Scan'),
            ),
            const SizedBox(height: 20),
            if (_imageBytes != null) Image.memory(_imageBytes!, height: 200),
            const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (!isLoading && scannedText.trim().isNotEmpty)
              ElevatedButton.icon(
                onPressed: _speakAgain,
                icon: const Icon(Icons.volume_up),
                label: const Text('Speak Again'),
              ),
            const SizedBox(height: 10),
            Expanded(child: SingleChildScrollView(child: Text(scannedText))),
          ],
        ),
      ),
    );
  }
}
