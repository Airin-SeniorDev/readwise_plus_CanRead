// นำเข้าแพ็กเกจที่จำเป็น
import 'package:cloud_firestore/cloud_firestore.dart'; // สำหรับเชื่อมต่อ Firestore
import 'package:flutter/material.dart'; // สำหรับสร้าง UI ใน Flutter
import 'package:intl/intl.dart'; // สำหรับจัดรูปแบบวันที่
import '../services/tts_service_web.dart'; // บริการแปลงข้อความเป็นเสียง
import 'voiceread_screen.dart'; // นำเข้า screen ฟังเสียง
import 'package:readwise_plus/screens/pricescan_screen.dart'; // นำเข้า screen เปรียบเทียบราคา

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key}); // constructor แบบ const

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255), // สีพื้นหลัง
      appBar: AppBar(
        leading: IconButton(
          // ปุ่มย้อนกลับ
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Favorites',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0, // ไม่มีเงา
      ),

      // ตัวแสดงข้อมูลแบบ real-time จาก Firestore
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('favorites')
                .orderBy('created_at', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ), // แสดงวงกลมโหลด
            );
          }

          final docs = snapshot.data?.docs ?? []; // ดึงเอกสารจาก snapshot

          if (docs.isEmpty) {
            // ถ้าไม่มีข้อมูล
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 72,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ยังไม่มีข้อความที่บันทึกไว้',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ข้อความที่บันทึกจะแสดงที่นี่',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                  ),
                ],
              ),
            );
          }

          // แสดงรายการ favorite ทั้งหมด
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final text = data['text'] ?? '';
              final lang = data['lang'] ?? '';
              final timestamp = data['created_at'] as Timestamp?;
              final date = timestamp?.toDate();
              final formattedDate =
                  date != null
                      ? DateFormat('dd MMM yyyy • HH:mm').format(date)
                      : '-';

              // ตั้งค่าภาษาแสดงผล
              String languageName = 'ไทย';
              if (lang == 'en-US') {
                languageName = 'English';
              }

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      offset: const Offset(0, 3),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ข้อความ
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        text,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // เส้นแบ่ง
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey.shade100,
                    ),

                    // บรรทัดล่างที่มีภาษา + วันที่ + ปุ่ม
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          // ชิปแสดงภาษา
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.language,
                                  size: 14,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  languageName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // ชิปแสดงวันที่
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  size: 14,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // ปุ่มพูดข้อความ
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            color: Colors.blue,
                            tooltip: 'ฟังข้อความ',
                            onPressed: () {
                              TTSWebService.speak(text, 1.0, lang); // เรียก TTS
                            },
                          ),
                          // ปุ่มลบ
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red.shade400,
                            tooltip: 'ลบข้อความ',
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      backgroundColor: Colors.grey.shade50,
                                      title: const Text(
                                        'ยืนยันการลบ',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: const Text(
                                        'คุณต้องการลบข้อความนี้หรือไม่?',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: Text(
                                            'ยกเลิก',
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            elevation: 2,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 10,
                                            ),
                                          ),
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text(
                                            'ลบ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                              );

                              // ถ้ายืนยัน = true
                              if (confirm == true) {
                                await doc.reference
                                    .delete(); // ลบ document นี้จาก Firestore
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('🗑 ลบข้อความแล้ว'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),

      // เมนูด้านล่าง (Bottom Navigation)
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
                      color: Color.fromARGB(255, 158, 158, 158),
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
                    'Price Books',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // ปุ่มลอย เพิ่มหรือสแกนใหม่
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.pop(context); // กลับไปหน้าหลัก
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
