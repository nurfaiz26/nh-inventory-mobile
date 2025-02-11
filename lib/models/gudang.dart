import 'cabang.dart';

class Gudang {
  final int id;
  final String nama;
  final String telepon;
  final Cabang cabang;

  Gudang({
    required this.id,
    required this.nama,
    required this.telepon,
    required this.cabang,
  });

  factory Gudang.fromJson(Map<String, dynamic> json) {
    return Gudang(
      id: json['id'],
      nama: json['nama'],
      telepon: json['telepon'],
      cabang: Cabang.fromJson(json['cabang']),
    );
  }
}