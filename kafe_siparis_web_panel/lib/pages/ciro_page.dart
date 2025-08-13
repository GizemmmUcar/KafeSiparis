//Günlük ciro takibi için.Toplam ciroyu,sipariş sayısını ve ortalama sipariş tutarını canlı hesaplar gösterir.Ciro seviyesine göre performans değerlendirmesi yapar.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CiroPage extends StatelessWidget {
  const CiroPage({Key? key}) : super(key: key);

  Future<double> hesaplaGunlukCiro() async {
    double toplamCiro = 0;
    DateTime bugun = DateTime.now();
    DateTime bugunBaslangic = DateTime(bugun.year, bugun.month, bugun.day);
    DateTime bugunBitis = bugunBaslangic.add(const Duration(days: 1));

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('siparisler')
        .where('tarih',
            isGreaterThanOrEqualTo: Timestamp.fromDate(bugunBaslangic))
        .where('tarih', isLessThan: Timestamp.fromDate(bugunBitis))
        .get();

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      toplamCiro += (data['toplamTutar'] ?? 0).toDouble();
    }
    return toplamCiro;
  }

  Future<int> hesaplaSiparisAdedi() async {
    DateTime bugun = DateTime.now();
    DateTime bugunBaslangic = DateTime(bugun.year, bugun.month, bugun.day);
    DateTime bugunBitis = bugunBaslangic.add(const Duration(days: 1));

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('siparisler')
        .where('tarih',
            isGreaterThanOrEqualTo: Timestamp.fromDate(bugunBaslangic))
        .where('tarih', isLessThan: Timestamp.fromDate(bugunBitis))
        .get();

    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    String bugunTarih =
        DateFormat('dd MMMM yyyy', 'tr_TR').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Günlük Ciro',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF8D6E63),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8D6E63),
              Color(0xFFF5F5F5),
            ],
            stops: [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarih başlığı
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        bugunTarih,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                Expanded(
                  child: FutureBuilder<List<dynamic>>(
                    future: Future.wait([
                      hesaplaGunlukCiro(),
                      hesaplaSiparisAdedi(),
                    ]),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingWidget();
                      }
                      if (snapshot.hasError) {
                        return _buildErrorWidget();
                      }

                      double ciro = snapshot.data![0] as double;
                      int siparisAdedi = snapshot.data![1] as int;
                      String formattedCiro =
                          NumberFormat.currency(locale: 'tr_TR', symbol: '₺')
                              .format(ciro);

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              elevation: 12,
                              shadowColor: Colors.black26,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF2196F3),
                                      Color(0xFF1976D2),
                                    ],
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.trending_up,
                                      size: 48,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(height: 12),
                                    const Text(
                                      'Bugünkü Ciro',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      formattedCiro,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard(
                                    title: 'Sipariş Adedi',
                                    value: siparisAdedi.toString(),
                                    icon: Icons.receipt_long,
                                    color: const Color(0xFF4CAF50),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard(
                                    title: 'Ortalama Sipariş',
                                    value: siparisAdedi > 0
                                        ? NumberFormat.currency(
                                                locale: 'tr_TR', symbol: '₺')
                                            .format(ciro / siparisAdedi)
                                        : '₺0,00',
                                    icon: Icons.calculate,
                                    color: const Color(0xFFFF9800),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.analytics,
                                          color: Colors.grey[600],
                                          size: 24,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Günlük Performans',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    _buildPerformanceIndicator(ciro),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
          SizedBox(height: 16),
          Text(
            'Ciro hesaplanıyor...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          const Text(
            'Bir hata oluştu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Ciro hesaplanırken hata oluştu',
            style: TextStyle(
              color: Color(0xFF757575),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: color.withOpacity(0.1),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceIndicator(double ciro) {
    String performansMetni;
    Color performansRengi;
    IconData performansIcon;

    if (ciro >= 10000) {
      performansMetni = 'Mükemmel Performans!';
      performansRengi = Colors.green;
      performansIcon = Icons.trending_up;
    } else if (ciro >= 7000) {
      performansMetni = 'İyi Performans';
      performansRengi = Colors.blue;
      performansIcon = Icons.show_chart;
    } else if (ciro >= 3000) {
      performansMetni = 'Orta Performans';
      performansRengi = Colors.orange;
      performansIcon = Icons.trending_flat;
    } else {
      performansMetni = 'Düşük Performans';
      performansRengi = Colors.red;
      performansIcon = Icons.trending_down;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: performansRengi.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: performansRengi.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            performansIcon,
            color: performansRengi,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            performansMetni,
            style: TextStyle(
              color: performansRengi,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
