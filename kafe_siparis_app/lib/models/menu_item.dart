class MenuItem {
  final String id;
  final String name;
  final String kategori;
  final double fiyat;
  final String imageUrl;

  MenuItem({
    required this.id,
    required this.name,
    required this.kategori,
    required this.fiyat,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'ad': name,
      'kategori': kategori,
      'fiyat': fiyat,
      'imageUrl': imageUrl,
    };
  }
}
