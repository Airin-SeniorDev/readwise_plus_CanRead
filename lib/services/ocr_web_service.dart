// 🔹 ใช้ http package สำหรับส่ง HTTP request
import 'package:http/http.dart' as http;

// 🔹 ใช้สำหรับแปลง JSON
import 'dart:convert';

// 🔹 ใช้สำหรับจัดการข้อมูลภาพแบบ byte
import 'dart:typed_data';

// 🔸 คลาส OCRWebService สำหรับเรียกใช้ OCR API
class OCRWebService {
  // 🔑 คีย์ API จาก ocr.space (สามารถใช้ key ทดสอบนี้ได้ แต่ไม่ควรเผยแพร่ในโปรดักชัน)
  static const String _apiKey = 'K83611259588957';

  // 🔹 ฟังก์ชันหลักสำหรับส่งภาพไปยัง OCR API และรับข้อความกลับมา
  static Future<String> scanImage(Uint8List imageBytes) async {
    // 🔸 กำหนด URL ของ API
    final uri = Uri.parse('https://api.ocr.space/parse/image');

    // 🔸 สร้าง HTTP request แบบ multipart สำหรับส่งภาพ
    final request =
        http.MultipartRequest('POST', uri)
          ..fields['apikey'] =
              _apiKey // ส่ง API key ไปในฟิลด์
          ..fields['language'] =
              'eng' // 🔁 เปลี่ยนเป็น 'tha' ได้ถ้าต้องการสแกนภาษาไทย
          ..files.add(
            http.MultipartFile.fromBytes(
              'file', // ฟิลด์ชื่อ 'file' คือชื่อ key ที่ API ต้องการ
              imageBytes, // ไฟล์ภาพที่เป็น byte array
              filename: 'upload.png', // ชื่อไฟล์จำลอง
            ),
          );

    // 🔸 ส่ง request ไปยัง API และรอรับ response แบบ stream
    final streamedResponse = await request.send();

    // 🔸 แปลง stream เป็น HTTP response ปกติ
    final response = await http.Response.fromStream(streamedResponse);

    // 🔸 แปลงเนื้อหาจาก JSON เป็น Map
    final result = json.decode(response.body);

    // 🔸 ตรวจสอบว่า OCR สำเร็จหรือไม่
    if (result['IsErroredOnProcessing'] == false) {
      // 🔹 ถ้าสำเร็จ → คืนข้อความที่ตรวจเจอ
      return result['ParsedResults'][0]['ParsedText'] ?? 'ไม่พบข้อความในภาพ';
    } else {
      // 🔹 ถ้าล้มเหลว → คืนข้อความแจ้งเตือน
      return '❌ OCR Failed: ${result['ErrorMessage'] ?? 'Unknown error'}';
    }
  }
}
