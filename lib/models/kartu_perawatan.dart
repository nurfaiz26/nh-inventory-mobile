import 'package:nh_manajemen_inventory/models/Unit.dart';
import 'package:nh_manajemen_inventory/models/log_inventaris_perawatan.dart';
import 'package:nh_manajemen_inventory/models/yayasan.dart';

class KartuPerawatan {
  final int id;
  final String pengguna;
  final String? log;
  final List<dynamic>? logInvetarisPerawatan;
  final Unit unit;
  final Yayasan yayasan;

  KartuPerawatan({
    required this.id,
    required this.pengguna,
    this.log,
    this.logInvetarisPerawatan,
    required this.unit,
    required this.yayasan,
  });

  factory KartuPerawatan.fromJson(Map<String, dynamic> json) {
    return KartuPerawatan(
      id: json['id'],
      pengguna: json['pengguna'],
      log: json['log'],
      logInvetarisPerawatan: json['log_inventarises']
          ?.map(
              (logInventaris) => LogInventarisPerawatan.fromJson(logInventaris))
          .toList(),
      unit: Unit.fromJson(json['unit']),
      yayasan: Yayasan.fromJson(json['yayasan']),
    );
  }
}
