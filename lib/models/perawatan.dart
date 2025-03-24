import 'package:intl/intl.dart';
import 'package:nh_manajemen_inventory/models/jenis_perawatan.dart';

class Perawatan {
  final int id;
  final String? keterangan;
  final String? createdAt;
  final String? updatedAt;
  final JenisPerawatan? jenisPerawatan;

  Perawatan({
    required this.id,
    required this.keterangan,
    required this.createdAt,
    required this.updatedAt,
    required this.jenisPerawatan,
  });

  factory Perawatan.fromJson(Map<String, dynamic> json) {
    return Perawatan(
      id: json['id'],
      keterangan: json['keterangan'],
      createdAt: json['created_at'] != null ? DateFormat("dd-MM-yyyy").format(DateTime.parse(json['created_at'])).toString() : null,
      updatedAt: json['updated_at'] != null ? DateFormat("dd-MM-yyyy").format(DateTime.parse(json['updated_at'])).toString() : null,
      jenisPerawatan: json['jenis_perawatan'] != null ? JenisPerawatan.fromJson(json['jenis_perawatan']) : null,
    );
  }
}