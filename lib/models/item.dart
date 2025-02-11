class Item {
  final int id;
  final String nama;

  Item({
    required this.id,
    required this.nama,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      nama: json['nama'],
    );
  }
}