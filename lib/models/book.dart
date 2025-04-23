// File: lib/models/book.dart
class Book {
  final String id;
  final String name;
  final String author;
  final String publisher;
  final String link;
  final String image;
  final double price;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.publisher,
    required this.link,
    required this.image,
    required this.price,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      author: json['author'],
      publisher: json['publisher'],
      link: json['link'],
      image: json['image'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
