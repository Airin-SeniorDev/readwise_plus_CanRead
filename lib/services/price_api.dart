// 🔹 สำหรับแปลง JSON
import 'dart:convert';

// 🔹 ใช้สำหรับ HTTP Request
import 'package:http/http.dart' as http;

// 🔹 นำเข้าคลาส Book ที่กำหนดโมเดลของหนังสือ
import '../models/book.dart';

// 🔸 คลาสสำหรับดึงข้อมูลหนังสือจาก mock API
class ApiService {
  // 🔸 URL สำหรับดึงข้อมูลจากร้าน Naiin (mock)
  static const String naiinUrl =
      'https://67fa6b878ee14a542627a3db.mockapi.io/api/search_book/naiin';

  // 🔸 URL สำหรับดึงข้อมูลจากร้าน SE-ED (mock)
  static const String seedUrl =
      'https://67fa6b878ee14a542627a3db.mockapi.io/api/search_book/seed';

  // 🔸 ดึงข้อมูลหนังสือจาก Naiin
  static Future<List<Book>> fetchNaiinBooks() async {
    final response = await http.get(Uri.parse(naiinUrl)); // ส่ง GET request

    // ถ้าสถานะ OK (200)
    if (response.statusCode == 200) {
      // แปลงข้อมูล JSON ที่เข้ารหัสเป็น UTF8
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));

      // แปลงข้อมูล JSON เป็นลิสต์ของ Book
      return data.map((item) => Book.fromJson(item)).toList();
    } else {
      // ถ้าล้มเหลว → ขว้าง error
      throw Exception('Failed to load Naiin books');
    }
  }

  // 🔸 ดึงข้อมูลหนังสือจาก SE-ED
  static Future<List<Book>> fetchSeedBooks() async {
    final response = await http.get(Uri.parse(seedUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load SE-ED books');
    }
  }
}
