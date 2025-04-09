import 'package:cloud_firestore/cloud_firestore.dart';

class FavoriteService {
  static Future<void> saveFavorite(String text, String lang) async {
    final docRef = FirebaseFirestore.instance.collection('favorites').doc();

    await docRef.set({
      'text': text,
      'lang': lang,
      'created_at': FieldValue.serverTimestamp(),
    });
  }
}
