//Sipariş verildikten sonra sipariş durumunu takip eder. Sipariş durumunu,masa no,sipariş tarihi ve ürün listesini gösterir. Sipariş bilgisi canlı takip edilir.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SiparisDurumPage extends StatelessWidget {
  final DocumentReference siparisRef;

  const SiparisDurumPage({super.key, required this.siparisRef});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sipariş Durumu"), centerTitle: true),

      body: StreamBuilder<DocumentSnapshot>(
        stream: siparisRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Bir hata oluştu."));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.greenAccent),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final masaNo = data['masaNo'] ?? 'Bilinmiyor';
          final durum = data['durum'] ?? 'Bilinmiyor';
          final toplamTutar = data['toplamTutar'] ?? 0;
          final urunler = List<Map<String, dynamic>>.from(
            data['urunler'] ?? [],
          );
          final tarih = (data['tarih'] as Timestamp).toDate();

          final formattedDate = DateFormat(
            'dd.MM.yyyy HH:mm',
            'tr_TR',
          ).format(tarih);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.event_seat,
                      color: Colors.greenAccent,
                    ),
                    title: Text("Masa No: $masaNo"),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.access_time,
                      color: Colors.greenAccent,
                    ),
                    title: Text("Tarih: $formattedDate"),
                  ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.inventory,
                      color: Colors.greenAccent,
                    ),
                    title: Text("Durum: $durum"),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Ürünler:",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 8),
                ...urunler.map(
                  (u) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      "- ${u['ad']} x${u['adet']} (₺${(u['fiyat'] * u['adet']).toStringAsFixed(2)})",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.attach_money,
                      color: Colors.greenAccent,
                    ),
                    title: Text(
                      "Toplam Tutar: ₺${toplamTutar.toStringAsFixed(2)}",
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
