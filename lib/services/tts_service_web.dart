// 🔹 เปิดใช้งานการเชื่อม JavaScript ด้วย @JS annotation
@JS()
library; // ✅ ใช้เพื่อเปิด context สำหรับเรียก JavaScript function ในเว็บ

// 🔹 นำเข้าฟีเจอร์ JS interop ของ Dart
import 'package:js/js.dart';
import 'dart:js' as js; // ใช้เรียก JavaScript method โดยตรงผ่าน context

// 🔹 ระบุว่าเราจะเรียก JavaScript ฟังก์ชันชื่อว่า "speakText"
@JS('speakText')
external void speakText(String text, String lang, double rate);
// ⬆️ ต้องมีฟังก์ชัน speakText ที่ฝั่ง JS (เช่นใน index.html หรือ JS แยก) เพื่อทำงานร่วมกัน

// 🔸 คลาส Dart ที่ใช้เรียก speakText แบบ wrapper
class TTSWebService {
  // ฟังก์ชัน static สำหรับเรียก TTS ด้วยพารามิเตอร์
  static void speak(String text, double rate, String langCode) {
    // เรียกใช้ JavaScript function โดยตรง
    js.context.callMethod('speakText', [text, langCode, rate]);
    // ✅ ทำให้ Flutter Web เรียก JavaScript พูดข้อความได้
  }
}
