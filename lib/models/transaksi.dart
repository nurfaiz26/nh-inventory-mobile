import 'package:nh_manajemen_inventory/models/Unit.dart';
import 'package:nh_manajemen_inventory/models/gudang.dart';

class Transaksi {
  final String kode;
  final Gudang gudang;
  final Unit unit;

  Transaksi({
    required this.kode,
    required this.gudang,
    required this.unit,
  });

  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      kode: json['kode'],
      gudang: Gudang.fromJson(json['gudang']),
      unit: Unit.fromJson(json['unit']),
    );
  }
}