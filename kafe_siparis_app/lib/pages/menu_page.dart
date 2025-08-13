//Firebase'den ürünleri canlı olarak çeker ve kategorilere göre gösterir. "+" "-"" butonları ile sepete ürün ekler veya çıkartır. Sepet butonu ile sepet ekranına geçer
//
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cart_page.dart';

class MenuPage extends StatefulWidget {
  final String masaNo;
  const MenuPage({super.key, required this.masaNo});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final Map<String, int> sepet = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Menü")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('urunler').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;
          final kategoriler = docs
              .map(
                (doc) =>
                    (doc.data() as Map<String, dynamic>)['kategori'] ?? 'Diğer',
              )
              .toSet()
              .toList();

          return DefaultTabController(
            length: kategoriler.length,
            child: Column(
              children: [
                TabBar(
                  isScrollable: true,
                  tabs: kategoriler.map((k) => Tab(text: k)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: kategoriler.map((kategori) {
                      final kategoriUrunler = docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return data['kategori'] == kategori;
                      }).toList();

                      return ListView.builder(
                        itemCount: kategoriUrunler.length,
                        itemBuilder: (context, index) {
                          final doc = kategoriUrunler[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final id = doc.id;
                          final ad = data['ad'] ?? 'Ürün';
                          final fiyat = data['fiyat'] ?? 0;
                          final imageUrl =
                              data['imageUrl'] ??
                              'https://via.placeholder.com/150';

                          final adet = sepet[id] ?? 0;
                          return Card(
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return SizedBox(
                                          width: 50,
                                          height: 50,
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        );
                                      },
                                  errorBuilder: (context, error, stackTrace) {
                                    return SizedBox(
                                      width: 50,
                                      height: 50,
                                      child: Icon(
                                        Icons.broken_image,
                                        color: Colors.grey,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              title: Text(ad),
                              subtitle: Text("₺$fiyat"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (adet > 0) {
                                          sepet[id] = adet - 1;
                                          if (sepet[id] == 0) {
                                            sepet.remove(id);
                                          }
                                        }
                                      });
                                    },
                                  ),
                                  Text(adet.toString()),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        sepet[id] = adet + 1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: sepet.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CartPage(
                      masaNo: widget.masaNo,
                      sepet: Map<String, int>.from(sepet),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_cart_checkout),
              label: const Text("Sepet"),
            )
          : null,
    );
  }
}
