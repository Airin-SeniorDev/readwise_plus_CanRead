import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../services/ocr_web_service.dart';
import '../services/favorite_service.dart';
import '../services/tts_service_web.dart';

class VoiceReadScreen extends StatefulWidget {
  const VoiceReadScreen({super.key});

  @override
  State<VoiceReadScreen> createState() => _VoiceReadScreenState();
}

class _VoiceReadScreenState extends State<VoiceReadScreen> {
  Uint8List? _imageBytes;
  String scannedText = 'ยังไม่ได้สแกนภาพ';
  bool isLoading = false;
  double speechRate = 1.0;
  String selectedLang = 'th-TH'; // ภาษาเริ่มต้น

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

      TTSWebService.speak(text, speechRate, selectedLang);
    } else {
      setState(() {
        scannedText = '❌ ไม่ได้เลือกรูปภาพ';
      });
    }
  }

  void _speakAgain() {
    TTSWebService.speak(scannedText, speechRate, selectedLang);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VoiceRead')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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

            // ✅ เงื่อนไขที่แสดงเฉพาะตอน OCR สำเร็จจริง
            if (!isLoading &&
                scannedText.trim().isNotEmpty &&
                scannedText != 'ยังไม่ได้สแกนภาพ' &&
                scannedText != '❌ ไม่ได้เลือกรูปภาพ') ...[
              ElevatedButton.icon(
                onPressed: _speakAgain,
                icon: const Icon(Icons.volume_up),
                label: const Text('Speak Again'),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  await FavoriteService.saveFavorite(scannedText, selectedLang);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('⭐ บันทึกข้อความเรียบร้อยแล้ว'),
                    ),
                  );
                },
                icon: const Icon(Icons.star),
                label: const Text('บันทึกข้อความ'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber.shade700,
                  foregroundColor: Colors.black,
                ),
              ),
            ],

            const SizedBox(height: 20),
            const Text(
              "🌐 เลือกภาษาเสียงพูด",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedLang,
              items: const [
                DropdownMenuItem(value: 'th-TH', child: Text('ภาษาไทย')),
                DropdownMenuItem(value: 'en-US', child: Text('English')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedLang = value;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "🔊 ความเร็วเสียงพูด",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Slider(
              min: 0.5,
              max: 2.0,
              divisions: 6,
              label: speechRate.toStringAsFixed(1),
              value: speechRate,
              onChanged: (value) {
                setState(() {
                  speechRate = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text(
              "📜 ข้อความที่ตรวจเจอ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: SingleChildScrollView(child: Text(scannedText))),
          ],
        ),
      ),
    );
  }
}
