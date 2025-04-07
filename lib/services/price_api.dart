class PriceAPI {
  static Future<String> getPriceForISBN(String isbn) async {
    // Mock data
    await Future.delayed(const Duration(seconds: 1));
    return '''
Mock prices for ISBN $isbn:
• Shopee: ฿150
• JD Central: ฿145
• Amazon: \$4.99
''';
  }
}
