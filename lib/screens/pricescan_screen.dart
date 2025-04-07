import 'package:flutter/material.dart';
import '../services/price_api.dart';

class PriceScanScreen extends StatefulWidget {
  const PriceScanScreen({super.key});

  @override
  State<PriceScanScreen> createState() => _PriceScanScreenState();
}

class _PriceScanScreenState extends State<PriceScanScreen> {
  String isbn = '';
  String result = '';

  void _search() async {
    final res = await PriceAPI.getPriceForISBN(isbn);
    setState(() {
      result = res;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PriceScan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Enter ISBN'),
              onChanged: (val) => isbn = val,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Search Price'),
              onPressed: _search,
            ),
            const SizedBox(height: 20),
            Text(result),
          ],
        ),
      ),
    );
  }
}
