import 'package:cloud_firestore/cloud_firestore.dart';

class LockAppDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<bool?> getBoolean(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      return doc.exists ? doc['isActive'] as bool? : null;
    } catch (e) {
      throw Exception('Failed to fetch boolean: $e');
    }
  }
}
