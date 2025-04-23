// File: lib/screens/pricescan_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/book.dart'; // Make sure this path is correct
import '../services/price_api.dart'; // Make sure this path is correct
import 'favorites_screen.dart';
import 'voiceread_screen.dart';

class PriceScanScreen extends StatefulWidget {
  const PriceScanScreen({super.key});

  @override
  _PriceScanScreenState createState() => _PriceScanScreenState();
}

// For the naming error in home_screen.dart - rename this alias
// Add this line to home_screen.dart at top of file:
// export 'pricescan_screen.dart' show PriceScanScreen as PriceScreen;

class _PriceScanScreenState extends State<PriceScanScreen> {
  List<Book> allBooks = [];
  List<Book> filteredBooks = [];
  bool isLoading = true;
  String searchQuery = '';

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllBooks();
  }

  Future<void> fetchAllBooks() async {
    try {
      final naiinBooks = await ApiService.fetchNaiinBooks();
      final seedBooks = await ApiService.fetchSeedBooks();
      final combined = [...naiinBooks, ...seedBooks];

      // setState(() {
      //   allBooks = combined;
      //   filteredBooks = combined;
      //   isLoading = false;
      // });

      setState(() {
        allBooks = combined;
        filteredBooks = []; // ยังไม่โชว์ข้อมูล
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('เกิดข้อผิดพลาดในการดึงข้อมูลหนังสือ: $e');
    }
  }

  void _search(String query) {
    final filtered =
        allBooks
            .where(
              (book) =>
                  book.name.toLowerCase().contains(query.toLowerCase()) ||
                  book.author.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    // ใน _search()
    setState(() {
      searchQuery = query;
      filteredBooks = filtered;
      _searchController.clear(); // ✅ ล้างช่องค้นหา
    });
  }

  // // String _getStoreName(String url) {
  // //   if (url.contains("naiin.com")) return "naiin";
  // //   if (url.contains("se-ed.com")) return "se-ed";
  // //   return "ร้านอื่น ๆ";
  // // }

  // // String _getSourceAPI(String url) {
  // //   if (url.contains("naiin.com")) return "naiin";
  // //   if (url.contains("se-ed.com")) return "seed";
  // //   return "";
  // // }

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
        title: const Text("Search for books"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      // ✅ body ของ Scaffold ต้องไม่มี bottomNavigationBar อยู่ข้างใน
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    //tap ค้นหา
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onSubmitted:
                                _search, // ✅ กด Enter บนคีย์บอร์ดเพื่อค้นหา
                            textInputAction:
                                TextInputAction
                                    .search, // ✅ ให้ปุ่ม Enter เป็น Search
                            decoration: InputDecoration(
                              hintText: ' ',
                              prefixIcon: const Icon(
                                Icons.search,
                                color: Color.fromARGB(
                                  255,
                                  134,
                                  134,
                                  134,
                                ), // ✅ เปลี่ยนสีไอคอนที่นี่
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
                            minimumSize: const Size(
                              100,
                              40,
                            ), // กำหนดความกว้างต่ำสุด 100 และความสูงต่ำสุด 40
                          ),
                          child: const Row(
                            //mainAxisSize: MainAxisSize.min,
                            children: [
                              //Icon(Icons.search, color: Colors.grey),
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

                  // ✅ เช็คกรณีไม่พบข้อมูล
                  if (filteredBooks.isEmpty)
                    const Expanded(
                      child: Center(child: Text("ไม่พบหนังสือที่ค้นหา")),
                    )
                  else
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

      // ✅ ย้าย bottomNavigationBar มาไว้ตรงนี้
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
