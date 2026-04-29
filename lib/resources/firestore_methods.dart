import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ✅ FIXED STREAM (sorted + safe)
  Stream<QuerySnapshot<Map<String, dynamic>>> get meetingsHistory => _firestore
      .collection('users')
      .doc(_auth.currentUser!.uid)
      .collection('meetings')
      .orderBy('createdAt', descending: true) // 🔥 IMPORTANT
      .snapshots();

  // ✅ FIXED SAVE METHOD
  Future<void> addToMeetingHistory(String meetingName) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('meetings')
          .add({
        'meetingName': meetingName,
        'createdAt': FieldValue.serverTimestamp(), // 🔥 IMPORTANT
      });
    } catch (e) {
      print(e);
    }
  }
}