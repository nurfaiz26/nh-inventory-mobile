import 'package:nh_manajemen_inventory/models/item.dart';

import 'gudang.dart';

class Barang {
  final int id;
  final String kode;
  final Item item;
  final Gudang gudang;

  Barang({
    required this.id,
    required this.kode,
    required this.item,
    required this.gudang,
  });

  factory Barang.fromJson(Map<String, dynamic> json) {
    return Barang(
      id: json['id'],
      kode: json['kode'],
      item: Item.fromJson(json['item']),
      gudang: Gudang.fromJson(json['gudang']),
    );
  }
}