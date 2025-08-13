// uygulamanın başlangıç dosyası. firebase ı başlattı uygulamaın teması belirlendi uygulama açıldığında first page den başlatıldı
//
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'pages/first_page.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); //Firebase i başlatır uygulama Firebase e bağlanır
  await initializeDateFormatting('tr_TR', null);

  runApp(const MyApp());  //uygulamayı başlatır
}

class MyApp extends StatelessWidget {  //uygulamanın tasarımı 
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kafe Sipariş App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Color(0xFFD7CCC8),

        appBarTheme: AppBarTheme(
          backgroundColor: Colors.brown.shade400,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.brown,
            foregroundColor: Colors.white,
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),

        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.brown.shade400,
          foregroundColor: Colors.white,
        ),

        cardTheme: CardThemeData(
          color: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),

        listTileTheme: ListTileThemeData(
          iconColor: Colors.brown.shade400,
          textColor: Colors.black,
          titleTextStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          subtitleTextStyle: TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ),

      home: const FirstPage(), //uygulamanın ilk açıldığında bu sayfayla başlaması için
    );
  }
}
