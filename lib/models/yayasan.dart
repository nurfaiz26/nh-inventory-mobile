import 'package:nh_manajemen_inventory/models/Unit.dart';

class Yayasan {
  final int id;
  final String nama;
  final String kode;

  Yayasan({
    required this.id,
    required this.nama,
    required this.kode,
  });

  factory Yayasan.fromJson(Map<String, dynamic> json) {
    return Yayasan(
      id: json['id'],
      nama: json['nama'],
      kode: json['kode'],
    );
  }
}