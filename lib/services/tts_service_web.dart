@JS() // ✅ ต้องใส่ไว้ก่อนการใช้ @JS(...)
library tts_web_service;

import 'package:js/js.dart';

@JS('speakText') // ✅ เชื่อมไปยัง function ใน index.html
external void speakText(String text);

class TTSWebService {
  static void speak(String text) {
    speakText(text); // ✅ เรียกใช้ JS function ที่ฝังไว้ใน index.html
  }
}
