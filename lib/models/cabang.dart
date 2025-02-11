class Cabang {
  final int id;
  final String nama;
  final String kode;

  Cabang({
    required this.id,
    required this.nama,
    required this.kode,
  });

  factory Cabang.fromJson(Map<String, dynamic> json) {
    return Cabang(
      id: json['id'],
      nama: json['nama'],
      kode: json['kode'],
    );
  }
}