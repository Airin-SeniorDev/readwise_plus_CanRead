// File: lib/screens/pricescan_screen.dart

// 🔹 นำเข้าแพ็กเกจพื้นฐานที่ใช้ในแอป
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // สำหรับเปิดลิงก์เว็บในเบราว์เซอร์
import '../models/book.dart'; // โมเดลข้อมูลหนังสือ
import '../services/price_api.dart'; // API เรียกข้อมูลราคาหนังสือ
import 'favorites_screen.dart'; // หน้ารายการโปรด
import 'voiceread_screen.dart'; // หน้าอ่านออกเสียง

// 🔹 StatefulWidget เพื่อให้สามารถเปลี่ยนแปลง UI เมื่อมีการค้นหา
class PriceScanScreen extends StatefulWidget {
  const PriceScanScreen({super.key});

  @override
  _PriceScanScreenState createState() => _PriceScanScreenState();
}

class _PriceScanScreenState extends State<PriceScanScreen> {
  // 🔹 ตัวแปรเก็บรายการหนังสือทั้งหมด และหนังสือที่ค้นหาได้
  List<Book> allBooks = [];
  List<Book> filteredBooks = [];

  bool isLoading = true; // แสดง loading ระหว่างโหลดข้อมูล
  String searchQuery = ''; // คำค้นหา

  final TextEditingController _searchController =
      TextEditingController(); // ควบคุมช่องค้นหา

  @override
  void initState() {
    super.initState();
    fetchAllBooks(); // โหลดข้อมูลเมื่อเริ่มหน้าจอ
  }

  // 🔹 ฟังก์ชันโหลดหนังสือจาก API ทั้ง naiin และ se-ed
  Future<void> fetchAllBooks() async {
    try {
      final naiinBooks = await ApiService.fetchNaiinBooks();
      final seedBooks = await ApiService.fetchSeedBooks();
      final combined = [...naiinBooks, ...seedBooks]; // รวมข้อมูลทั้งหมด

      setState(() {
        allBooks = combined;
        filteredBooks = []; // เริ่มต้นไม่แสดงรายการ
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('เกิดข้อผิดพลาดในการดึงข้อมูลหนังสือ: $e');
    }
  }

  // 🔹 ฟังก์ชันค้นหาหนังสือจากชื่อหรือผู้แต่ง
  void _search(String query) {
    final filtered =
        allBooks
            .where(
              (book) =>
                  book.name.toLowerCase().contains(query.toLowerCase()) ||
                  book.author.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    setState(() {
      searchQuery = query;
      filteredBooks = filtered;
      _searchController.clear(); // ล้างช่องค้นหาเมื่อค้นหาเสร็จ
    });
  }

  // 🔹 ฟังก์ชันเปิดลิงก์ไปยังร้านหนังสือ
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'ไม่สามารถเปิด URL $url ได้';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search for books"), // ชื่อหน้าจอ
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      backgroundColor: const Color.fromARGB(255, 255, 255, 255),

      // 🔹 แสดง loading หรือเนื้อหาขึ้นอยู่กับสถานะ
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  // 🔸 ช่องค้นหา + ปุ่ม search
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted: _search, // ค้นหาเมื่อกด enter
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              hintText: ' ',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color.fromARGB(255, 134, 134, 134),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: const Color.fromARGB(
                                255,
                                238,
                                238,
                                238,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8, height: 10),
                        ElevatedButton(
                          onPressed: () {
                            _search(_searchController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[200],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            minimumSize: const Size(100, 40),
                          ),
                          child: const Row(
                            children: [
                              SizedBox(width: 8, height: 20),
                              Text(
                                "search",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 🔸 ถ้าไม่พบหนังสือที่ค้นหา
                  if (filteredBooks.isEmpty)
                    const Expanded(
                      child: Center(child: Text("ไม่พบหนังสือที่ค้นหา")),
                    )
                  else
                    // 🔸 แสดงรายการหนังสือ
                    Expanded(
                      child: ListView.separated(
                        itemCount: filteredBooks.length,
                        separatorBuilder:
                            (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index];
                          final source =
                              book.link.contains("naiin.com")
                                  ? "naiin"
                                  : book.link.contains("se-ed.com")
                                  ? "seed"
                                  : "";

                          return InkWell(
                            onTap: () => _launchURL(book.link),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  // 🔸 โลโก้ร้าน
                                  if (source == "naiin" || source == "seed")
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Image.asset(
                                        source == "naiin"
                                            ? 'assets/images/logo-naiin.png'
                                            : 'assets/images/logo-seed.png',
                                        width: 60,
                                        height: 60,
                                        errorBuilder:
                                            (_, __, ___) => Container(
                                              width: 60,
                                              height: 60,
                                              color: Colors.red,
                                            ),
                                      ),
                                    ),

                                  // 🔸 รูปหน้าปกหนังสือ
                                  Padding(
                                    padding: const EdgeInsets.only(right: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        book.image,
                                        width: 50,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (_, __, ___) => Container(
                                              width: 50,
                                              height: 65,
                                              color: Colors.red[400],
                                              child: Center(
                                                child: Text(
                                                  book.name.split(' ')[0],
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),

                                  // 🔸 รายละเอียดหนังสือ
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          book.author,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Text(
                                          book.publisher,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // 🔸 ราคาหนังสือ
                                  SizedBox(
                                    width: 70,
                                    child: Text(
                                      "\$${book.price.toStringAsFixed(2)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),

      // 🔹 แถบเมนูด้านล่าง (Bottom Navigation)
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 🔸 ปุ่ม Home
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

            // 🔸 ปุ่ม VoiceRead
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

            // 🔸 ปุ่ม Favorites
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

            // 🔸 ปุ่ม Price Book
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
