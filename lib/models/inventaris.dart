import 'package:nh_manajemen_inventory/models/barang.dart';

import 'Wilayah.dart';

class Inventaris {
  final String kode;
  final String nilaiAwal;
  final String nilaiBuku;
  final String pengguna;
  final Barang barang;
  final Wilayah wilayah;

  Inventaris({
    required this.kode,
    required this.nilaiAwal,
    required this.nilaiBuku,
    required this.pengguna,
    required this.barang,
    required this.wilayah,
  });

  factory Inventaris.fromJson(Map<String, dynamic> json) {
    return Inventaris(
      kode: json['kode'],
      nilaiAwal: json['nilai_awal'],
      nilaiBuku: json['nilai_buku'],
      pengguna: json['pengguna'],
      barang: Barang.fromJson(json['barang']),
      wilayah: Wilayah.fromJson(json['wilayah']),
    );
  }
}