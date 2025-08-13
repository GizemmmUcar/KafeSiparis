import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class OrderProvider extends ChangeNotifier {
  String? masaNo;
  final Map<MenuItem, int> _sepet = {};

  Map<MenuItem, int> get sepet => _sepet;

  double get toplamTutar =>
      _sepet.entries.fold(0, (toplam, e) => toplam + e.key.fiyat * e.value);

  void setMasaNo(String no) {
    masaNo = no;
    notifyListeners();
  }

  void urunEkle(MenuItem item) {
    if (_sepet.containsKey(item)) {
      _sepet[item] = _sepet[item]! + 1;
    } else {
      _sepet[item] = 1;
    }
    notifyListeners();
  }

  void urunAzalt(MenuItem item) {
    if (_sepet.containsKey(item)) {
      if (_sepet[item]! > 1) {
        _sepet[item] = _sepet[item]! - 1;
      } else {
        _sepet.remove(item);
      }
      notifyListeners();
    }
  }

  void sepetiTemizle() {
    _sepet.clear();
    notifyListeners();
  }
}