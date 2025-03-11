import 'package:intl/intl.dart';
import 'package:nh_manajemen_inventory/models/jenis_perawatan.dart';

class Perawatan {
  final int id;
  final String keterangan;
  final String createdAt;
  final String updatedAt;
  final JenisPerawatan jenisPerawatan;

  Perawatan({
    required this.id,
    required this.keterangan,
    required this.createdAt,
    required this.updatedAt,
    required this.jenisPerawatan,
  });

  factory Perawatan.fromJson(Map<String, dynamic> json) {
    print(json);
    return Perawatan(
      id: json['id'],
      keterangan: json['keterangan'],
      createdAt: DateFormat("dd-MM-yyyy").format(DateTime.parse(json['created_at'])).toString(),
      updatedAt: DateFormat("dd-MM-yyyy").format(DateTime.parse(json['updated_at'])).toString(),
      jenisPerawatan: JenisPerawatan.fromJson(json['jenis_perawatan']),
    );
  }
}