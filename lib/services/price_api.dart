import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String naiinUrl =
      'https://67fa6b878ee14a542627a3db.mockapi.io/api/search_book/naiin';
  static const String seedUrl =
      'https://67fa6b878ee14a542627a3db.mockapi.io/api/search_book/seed';

  static Future<List<Book>> fetchNaiinBooks() async {
    final response = await http.get(Uri.parse(naiinUrl));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      return data.map((item) => Book.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Naiin books');
    }
  }

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
