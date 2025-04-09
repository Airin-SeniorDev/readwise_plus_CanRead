import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/tts_service_web.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⭐ ข้อความที่บันทึกไว้')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('favorites')
                .orderBy('created_at', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(child: Text('ยังไม่มีข้อความที่บันทึกไว้'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final text = data['text'] ?? '';
              final lang = data['lang'] ?? '';
              final timestamp = data['created_at'] as Timestamp?;
              final date = timestamp?.toDate();
              final formattedDate =
                  date != null
                      ? DateFormat('dd/MM/yyyy HH:mm').format(date)
                      : '-';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(text),
                  subtitle: Text('🌐 $lang   🕒 $formattedDate'),
                  isThreeLine: true,
                  trailing: Wrap(
                    spacing: 8,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        tooltip: 'ฟังข้อความ',
                        onPressed: () {
                          TTSWebService.speak(text, 1.0, lang);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        tooltip: 'ลบข้อความ',
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('ยืนยันการลบ'),
                                  content: const Text(
                                    'คุณต้องการลบข้อความนี้หรือไม่?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('ยกเลิก'),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('ลบ'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            await doc.reference.delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('🗑 ลบข้อความแล้ว')),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
