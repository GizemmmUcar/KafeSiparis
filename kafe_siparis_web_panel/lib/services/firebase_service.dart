import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getSiparislerStream() {
    return _firestore.collection('siparisler').orderBy('tarih', descending: true).snapshots();
  }
}
