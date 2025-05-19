import 'package:nh_manajemen_inventory/models/Wilayah.dart';
import 'package:nh_manajemen_inventory/models/inventaris.dart';
import 'package:nh_manajemen_inventory/models/transaksi.dart';

class LogTransaksi {
  final int id;
  final String jumlah;
  final String totalHarga;
  final String status;
  final int userId;
  final int gudangId;
  final int? gudangTujuanId;
  final int transaksiId;
  final String createdAt;
  final String updatedAt;
  final String sisa;
  final Inventaris inventaris;
  final Transaksi transaksi;

  LogTransaksi({
    required this.id,
    required this.jumlah,
    required this.totalHarga,
    required this.status,
    required this.userId,
    required this.gudangId,
    this.gudangTujuanId,
    required this.transaksiId,
    required this.createdAt,
    required this.updatedAt,
    required this.sisa,
    required this.inventaris,
    required this.transaksi,
  });

  factory LogTransaksi.fromJson(Map<String, dynamic> json) {
    return LogTransaksi(
      id: json['log']['id'],
      jumlah: json['log']['jumlah'],
      totalHarga: json['log']['total_harga'],
      status: json['log']['status'],
      userId: json['log']['user_id'],
      gudangId: json['log']['gudang_id'],
      gudangTujuanId: json['log']['gudang_tujuan_id'],
      transaksiId: json['log']['transaksi_id'],
      createdAt: json['log']['created_at'],
      updatedAt: json['log']['updated_at'],
      sisa: json['log']['sisa'],
      inventaris: Inventaris.fromJson(json['log']['inventaris']),
      transaksi: Transaksi.fromJson(json['log']['transaksi']),
    );
  }
}
