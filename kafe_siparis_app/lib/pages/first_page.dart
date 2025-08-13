//Yygulamanın giriş ekranı. Masa seçimi yapılır, menü ekranına geçilir
import 'package:flutter/material.dart';
import 'menu_page.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String? _secilenMasa;
  final List<String> masalar = ['A1', 'A2', 'B1', 'B2', 'C1'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(title: const Text("Sipariş Ver"), elevation: 0),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF8D6E63), Color(0xFFD7CCC8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MenuPage(masaNo: "QR-Simulasyon"),
                          ),
                        );
                      },
                      icon: const Icon(Icons.qr_code, size: 28),
                      label: const Text(
                        "QR ile Giriş (Simülasyon)",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 24),
                    DropdownButtonFormField<String>(
                      value: _secilenMasa,
                      decoration: const InputDecoration(
                        labelText: "Masa Seçiniz",
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onChanged: (value) {
                        setState(() => _secilenMasa = value);
                      },
                      items: masalar.map((masa) {
                        return DropdownMenuItem(value: masa, child: Text(masa));
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    if (_secilenMasa != null)
                      Chip(
                        label: Text("Seçilen Masa: $_secilenMasa"),
                        avatar: const Icon(Icons.event_seat),
                        backgroundColor: Colors.brown.shade200,
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _secilenMasa == null
                          ? null
                          : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      MenuPage(masaNo: _secilenMasa!),
                                ),
                              );
                            },
                      icon: const Icon(Icons.restaurant_menu),
                      label: const Text("Menüye Geç"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
