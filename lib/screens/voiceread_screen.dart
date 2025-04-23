import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import '../services/ocr_web_service.dart';
import '../services/favorite_service.dart';
import '../services/tts_service_web.dart';
import 'favorites_screen.dart';
import 'package:readwise_plus/screens/pricescan_screen.dart';

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

  // void _pausePlayback() {
  //   TTSWebService.pause();
  // }

  // void _resumePlayback() {
  //   TTSWebService.resume();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('VoiceRead Mode'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Image placeholder area
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  _imageBytes != null
                      ? Image.memory(_imageBytes!, fit: BoxFit.contain)
                      : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image,
                            size: 64,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "No image selected",
                            style: TextStyle(color: Colors.grey.shade500),
                          ),
                        ],
                      ),
            ),
            const SizedBox(height: 20),

            // Upload File button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _pickImageAndScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Upload File',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),

            const SizedBox(height: 20),

            // Add the language selection dropdown here
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "🌐 เลือกภาษาเสียงพูด",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
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
              ],
            ),

            const SizedBox(height: 20),
            // Controls Row (Speak again and Save text)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _speakAgain,
                    icon: const Icon(Icons.volume_up),
                    label: const Text('Speak Again'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await FavoriteService.saveFavorite(
                        scannedText,
                        selectedLang,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('⭐ บันทึกข้อความเรียบร้อยแล้ว'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Save Text'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Playback controls
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     const Text('10', style: TextStyle(fontWeight: FontWeight.bold)),
            //     const SizedBox(width: 40),
            //     Container(
            //       decoration: BoxDecoration(
            //         color: Colors.grey.shade200,
            //         borderRadius: BorderRadius.circular(8),
            //       ),
            //       padding: const EdgeInsets.all(8),
            //       child: const Icon(Icons.pause, size: 28),
            //     ),
            //     const SizedBox(width: 40),
            //     const Text('10', style: TextStyle(fontWeight: FontWeight.bold)),
            //   ],
            // ),
            const SizedBox(height: 25),

            // Speed slider
            Row(
              children: [
                // const Text(
                //   'Speed : ',
                //   style: TextStyle(fontWeight: FontWeight.bold),
                // ),
                const SizedBox(width: 10),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.blue,
                      inactiveTrackColor: Colors.grey.shade200,
                      thumbColor: Colors.white,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8.0,
                        elevation: 2,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16.0,
                      ),
                    ),
                    child: Slider(
                      min: 0.5,
                      max: 2.0,
                      divisions: 6,
                      value: speechRate,
                      onChanged: (value) {
                        setState(() {
                          speechRate = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // "ข้อความที่ตรวจเจอ" section
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "📜 ข้อความที่ตรวจเจอ",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    scannedText,
                    style: TextStyle(color: Colors.grey.shade800, height: 1.5),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.home,
                    color: Color.fromARGB(255, 158, 158, 158),
                    size: 24,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color.fromARGB(255, 158, 158, 158),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const VoiceReadScreen()),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.volume_up,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'VoiceRead',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // ชอบ
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FavoritesScreen()),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.star, color: Colors.grey, size: 24),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Favorites',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),

            // หนังสือ
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PriceScanScreen()),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.auto_stories,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Price Book',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
