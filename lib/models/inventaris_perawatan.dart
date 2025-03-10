import 'package:nh_manajemen_inventory/models/Merk.dart';
import 'package:nh_manajemen_inventory/models/Seri.dart';
import 'package:nh_manajemen_inventory/models/barang.dart';

class InventarisPerawatan {
  final String kode;
  final Barang barang;
  final Merk merk;
  final Seri seri;

  InventarisPerawatan({
    required this.kode,
    required this.barang,
    required this.merk,
    required this.seri,
  });

  factory InventarisPerawatan.fromJson(Map<String, dynamic> json) {
    return InventarisPerawatan(
      kode: json['kode'],
      barang: Barang.fromJson(json['barang']),
      merk: Merk.fromJson(json['merk']),
      seri: Seri.fromJson(json['seri']),
    );
  }
}