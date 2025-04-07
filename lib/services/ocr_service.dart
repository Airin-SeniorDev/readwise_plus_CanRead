import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OCRService {
  // ฟังก์ชันเลือกภาพจาก Gallery
  static Future<File?> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null; // ถ้าไม่ได้เลือกรูป
    return File(pickedFile.path); // คืนค่าภาพที่เลือก
  }

  static Future<String> readTextFromImage(File image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    final RecognizedText recognizedText = await textDetector.processImage(
      inputImage,
    );
    await textDetector.close();

    return recognizedText.text;
  }
}
