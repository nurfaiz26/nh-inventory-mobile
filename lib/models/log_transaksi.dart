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
  final int? stokId;
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
    this.stokId,
    required this.transaksiId,
    required this.createdAt,
    required this.updatedAt,
    required this.sisa,
    required this.inventaris,
    required this.transaksi,
  });

  factory LogTransaksi.fromJson(Map<String, dynamic> json) {
    return LogTransaksi(
      id: json['id'],
      jumlah: json['jumlah'],
      totalHarga: json['total_harga'],
      status: json['status'],
      userId: json['user_id'],
      gudangId: json['gudang_id'],
      gudangTujuanId: json['gudang_tujuan_id'],
      stokId: json['stok_id'],
      transaksiId: json['transaksi_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      sisa: json['sisa'],
      inventaris: Inventaris.fromJson(json['inventaris']),
      transaksi: Transaksi.fromJson(json['transaksi']),
    );
  }
}
