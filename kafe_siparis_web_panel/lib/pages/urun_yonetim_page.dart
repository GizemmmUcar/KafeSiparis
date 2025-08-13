//ürünlerin eklenmesi,düzenlenmesi ve silinmesi için kullanılan sayfa.yeni ürün ekleyebiliri,ürünlerin bilgilerini güncellenebilir veya silebilir. Tüm işlemler Firestore’a bağlı ve canlı olarak çalışır.”
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UrunYonetimPage extends StatefulWidget {
  const UrunYonetimPage({super.key});

  @override
  State<UrunYonetimPage> createState() => _UrunYonetimPageState();
}

class _UrunYonetimPageState extends State<UrunYonetimPage> {
  final TextEditingController _adController = TextEditingController();
  final TextEditingController _fiyatController = TextEditingController();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  Future<void> urunEkle() async {
    try {
      await FirebaseFirestore.instance.collection('urunler').add({
        'ad': _adController.text.trim(),
        'fiyat': double.tryParse(_fiyatController.text.trim()) ?? 0,
        'kategori': _kategoriController.text.trim(),
        'imageUrl': _imageUrlController.text.trim(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Ürün başarıyla eklendi")),
      );
      _adController.clear();
      _fiyatController.clear();
      _kategoriController.clear();
      _imageUrlController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Hata: $e")),
      );
    }
  }

  void urunGuncelleModal(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final TextEditingController adController =
        TextEditingController(text: data['ad']);
    final TextEditingController fiyatController =
        TextEditingController(text: data['fiyat'].toString());
    final TextEditingController kategoriController =
        TextEditingController(text: data['kategori']);
    final TextEditingController imageUrlController =
        TextEditingController(text: data['imageUrl']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Ürünü Güncelle",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                  controller: adController,
                  decoration: const InputDecoration(labelText: "Ürün Adı")),
              TextField(
                  controller: fiyatController,
                  decoration: const InputDecoration(labelText: "Fiyat"),
                  keyboardType: TextInputType.number),
              TextField(
                  controller: kategoriController,
                  decoration: const InputDecoration(labelText: "Kategori")),
              TextField(
                  controller: imageUrlController,
                  decoration: const InputDecoration(labelText: "Resim URL")),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: () async {
                  await doc.reference.update({
                    'ad': adController.text.trim(),
                    'fiyat': double.tryParse(fiyatController.text.trim()) ?? 0,
                    'kategori': kategoriController.text.trim(),
                    'imageUrl': imageUrlController.text.trim(),
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("✅ Ürün güncellendi")),
                  );
                },
                icon: const Icon(Icons.save),
                label: const Text("Güncelle"),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ürün Yönetimi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text("Yeni Ürün Ekle",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
                controller: _adController,
                decoration: const InputDecoration(labelText: "Ürün Adı")),
            TextField(
                controller: _fiyatController,
                decoration: const InputDecoration(labelText: "Fiyat"),
                keyboardType: TextInputType.number),
            TextField(
                controller: _kategoriController,
                decoration: const InputDecoration(labelText: "Kategori")),
            TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: "Resim URL")),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: urunEkle,
              icon: const Icon(Icons.add),
              label: const Text("Ürün Ekle"),
            ),
            const Divider(height: 30),
            const Text("Ekli Ürünler",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('urunler').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index].data() as Map<String, dynamic>;
                    return Card(
                      child: ListTile(
                        title: Text("${data['ad']} - ₺${data['fiyat']}"),
                        subtitle: Text(data['kategori'] ?? 'Kategori yok'),
                        onTap: () => urunGuncelleModal(docs[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await docs[index].reference.delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("🗑️ Ürün silindi")),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
