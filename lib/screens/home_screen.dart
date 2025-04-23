// นำเข้าแพ็กเกจที่จำเป็นสำหรับ UI และนำทางไปยังหน้าต่างๆ
import 'package:flutter/material.dart';
import 'voiceread_screen.dart'; // หน้าสำหรับโหมดอ่านออกเสียง
import 'package:readwise_plus/screens/pricescan_screen.dart'; // หน้าสำหรับเปรียบเทียบราคาหนังสือ
import 'favorites_screen.dart'; // หน้ารายการที่ถูกบันทึกไว้

// คลาส StatelessWidget สำหรับหน้า Home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key}); // Constructor แบบ const เพื่อประหยัด memory

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold: โครงสร้างหลักของหน้าจอ
      backgroundColor: const Color.fromARGB(
        255,
        255,
        255,
        255,
      ), // สีพื้นหลังขาว
      // AppBar แบบโปร่งใส
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),

      // เนื้อหาหลักในหน้าจอ
      body: Padding(
        padding: const EdgeInsets.all(16.0), // margin รอบๆ เนื้อหา
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // แถวบนสุด: โลโก้ ReadWise+ และชื่อแอป
            Row(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                  height: 40,
                ), // รูปโลโก้
                const SizedBox(width: 12),
                const Text(
                  'ReadWise+',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),

            const SizedBox(height: 24), // ระยะห่างก่อนการ์ดแรก
            // การ์ด: VoiceRead Mode
            Card(
              elevation: 2, // เงาการ์ด
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // ขอบโค้ง
              ),
              child: InkWell(
                onTap: () {
                  // เมื่อแตะการ์ดนี้ → ไปหน้า VoiceRead
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VoiceReadScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // ไอคอน
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.volume_up,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // ข้อความ
                      const Text(
                        'VoiceRead Mode',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16), // ระยะห่างก่อนการ์ดที่สอง
            // การ์ด: PriceScan Mode
            Card(
              elevation: 2,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // ไปหน้า PriceScan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const PriceScanScreen()),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.crop_free,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Text(
                        'Price of Books',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // เมนูด้านล่าง (Bottom Navigation)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ปุ่ม Home
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

            // ปุ่ม VoiceRead
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

            // ปุ่ม Favorites
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

            // ปุ่ม Price Books
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
    );
  }
}
