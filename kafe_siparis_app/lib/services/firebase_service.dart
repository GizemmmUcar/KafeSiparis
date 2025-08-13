//Servis, kullanıcı siparişi onayladığında siparişi firebase'e kaydeder ve sipariş durum sayfasına yönlendirir.
//Firestore masa no, ürün listesi, toplam tutar ve tarih bilgisi kaydeder.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/siparis_durum_page.dart';

class FirebaseService {
  static Future<void> siparisGonder({
    required BuildContext context,
    required String masaNo,
    required List<Map<String, dynamic>> urunler,
    required double toplamTutar,
  }) async {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    DateTime now = DateTime.now();

    DocumentReference ref = FirebaseFirestore.instance
        .collection('siparisler')
        .doc('siparis_${masaNo}_$timestamp');

    await ref.set({
      'masaNo': masaNo,
      'urunler': urunler,
      'toplamTutar': toplamTutar,
      'tarih': now,
      'durum': 'Hazırlanıyor',
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SiparisDurumPage(siparisRef: ref)),
    );
  }
}
