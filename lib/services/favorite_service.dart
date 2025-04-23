// นำเข้า Firebase Firestore เพื่อใช้งานฐานข้อมูลแบบ cloud
import 'package:cloud_firestore/cloud_firestore.dart';

// 🔹 สร้างคลาส FavoriteService แบบ static ไม่ต้องสร้าง instance
class FavoriteService {
  // 🔸 เมธอดแบบ static ใช้บันทึกข้อความที่ผู้ใช้เลือกลง Firestore
  static Future<void> saveFavorite(String text, String lang) async {
    // สร้าง reference ไปยัง collection 'favorites' และสร้าง document ใหม่ (id แบบสุ่ม)
    final docRef = FirebaseFirestore.instance.collection('favorites').doc();

    // บันทึกข้อมูลลง document นี้
    await docRef.set({
      'text': text, // ข้อความที่บันทึก
      'lang': lang, // ภาษาที่เลือก (เช่น 'th-TH', 'en-US')
      'created_at':
          FieldValue.serverTimestamp(), // วันเวลาที่บันทึก (จาก server)
    });
  }
}
