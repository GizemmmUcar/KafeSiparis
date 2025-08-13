import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'siparis_detay_page.dart';

class SiparisListesiPage extends StatefulWidget {
  const SiparisListesiPage({super.key});

  @override
  State<SiparisListesiPage> createState() => _SiparisListesiPageState();
}

class _SiparisListesiPageState extends State<SiparisListesiPage> {
  DateTime seciliTarih = DateTime.now();

  Future<void> _tarihSec() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: seciliTarih,
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        seciliTarih = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Seçili günün başlangıcı ve bitişi
    final gunBaslangic =
        DateTime(seciliTarih.year, seciliTarih.month, seciliTarih.day);
    final gunBitis = gunBaslangic.add(const Duration(days: 1));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Siparişler'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _tarihSec,
            tooltip: 'Tarih Seç',
          ),
        ],
      ),
      body: Column(
        children: [
          // Tarih gösterge kartı
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tarih: ${seciliTarih.day}/${seciliTarih.month}/${seciliTarih.year}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (seciliTarih.day == DateTime.now().day &&
                      seciliTarih.month == DateTime.now().month &&
                      seciliTarih.year == DateTime.now().year)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'BUGÜN',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Sipariş listesi
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('siparisler')
                  .where('tarih',
                      isGreaterThanOrEqualTo: Timestamp.fromDate(gunBaslangic))
                  .where('tarih', isLessThan: Timestamp.fromDate(gunBitis))
                  .orderBy('tarih', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Hata oluştu'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final siparisler = snapshot.data!.docs;

                if (siparisler.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long,
                            size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'Bu tarihte sipariş yok',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: siparisler.length,
                  itemBuilder: (context, index) {
                    final siparis = siparisler[index];
                    final data = siparis.data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: ListTile(
                        title: Text('Masa No: ${data['masaNo'] ?? '-'}'),
                        subtitle: Text(
                          'Saat: ${_saatFormat((data['tarih'] as Timestamp).toDate())}\n'
                          'Toplam Tutar: ${data['toplamTutar'] ?? '-'} ₺\n'
                          'Durum: ${data['durum'] ?? 'Hazırlanıyor'}',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SiparisDetayPage(
                                siparisId: siparis.id,
                                siparisData: data,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _saatFormat(DateTime tarih) {
    return '${tarih.hour.toString().padLeft(2, '0')}:${tarih.minute.toString().padLeft(2, '0')}';
  }
}
