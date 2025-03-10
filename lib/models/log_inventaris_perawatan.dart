import 'inventaris_perawatan.dart';

class LogInventarisPerawatan {
  final int id;
  final String status;
  final InventarisPerawatan inventarisPerawatan;

  LogInventarisPerawatan({
    required this.id,
    required this.status,
    required this.inventarisPerawatan,
  });

  factory LogInventarisPerawatan.fromJson(Map<String, dynamic> json) {
    return LogInventarisPerawatan(
      id: json['id'],
      status: json['status'],
      inventarisPerawatan: InventarisPerawatan.fromJson(json['inventaris']),
    );
  }
}