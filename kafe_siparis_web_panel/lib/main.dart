//başlangıç dosyası firebase kurulumu yapıldu. tarih bilgileri ayarlandı ve ana sayfa olan dashboard açıldı
import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();  //firebase başlatılır
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('tr_TR', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kafe Sipariş Web Panel',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const DashboardPage(), //uygulama açılldığında ana ekranı gösterir
    );
  }
}
