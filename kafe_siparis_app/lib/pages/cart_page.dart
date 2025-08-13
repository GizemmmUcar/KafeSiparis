//Sepetteki ürünleri listeler. Toplam tutarı, adet ve fiyat bilgisini gösterir. Sipariş onaylandığında firebase'e kaydeder.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';

class CartPage extends StatelessWidget {
  final String masaNo;
  final Map<String, int> sepet;
  const CartPage({super.key, required this.masaNo, required this.sepet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sepet")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('urunler').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final urunDocs = snapshot.data!.docs
                .where((doc) => sepet.keys.contains(doc.id))
                .toList();

            final double toplamTutar = urunDocs.fold(0.0, (previousValue, doc) {
              final data = doc.data() as Map<String, dynamic>;
              final id = doc.id;
              final adet = sepet[id] ?? 0;
              final fiyat = (data['fiyat'] ?? 0).toDouble();
              return previousValue + (fiyat * adet);
            });

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: urunDocs.length,
                    itemBuilder: (context, index) {
                      final data =
                          urunDocs[index].data() as Map<String, dynamic>;
                      final id = urunDocs[index].id;
                      final adet = sepet[id] ?? 0;
                      final ad = data['ad'] ?? 'Ad yok';
                      final fiyat = (data['fiyat'] ?? 0).toDouble();
                      final imageUrl = data['imageUrl'] ?? '';

                      return Card(
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(ad),
                          subtitle: Text(
                            "₺$fiyat x $adet = ₺${(fiyat * adet).toStringAsFixed(2)}",
                          ),
                          trailing: Text(
                            "x$adet",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Toplam: ₺${toplamTutar.toStringAsFixed(2)}",
                  style:
                      Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ) ??
                      TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                ),

                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    final urunler = urunDocs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final id = doc.id;
                      final adet = sepet[id] ?? 0;
                      return {
                        'id': id,
                        'ad': data['ad'],
                        'adet': adet,
                        'fiyat': data['fiyat'],
                      };
                    }).toList();

                    await FirebaseService.siparisGonder(
                      context: context,
                      masaNo: masaNo,
                      urunler: urunler,
                      toplamTutar: toplamTutar,
                    );
                  },
                  icon: const Icon(Icons.check_circle),
                  label: const Text("Siparişi Onayla"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
