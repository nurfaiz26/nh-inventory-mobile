import 'package:nh_manajemen_inventory/models/Unit.dart';
import 'package:nh_manajemen_inventory/models/log_inventaris_perawatan.dart';
import 'package:nh_manajemen_inventory/models/perawatan.dart';
import 'package:nh_manajemen_inventory/models/yayasan.dart';

class KartuPerawatan {
  final int id;
  final String pengguna;
  final String? log;
  final List<dynamic>? logInvetarisPerawatan;
  final List<dynamic>? perawatans;
  final Unit unit;
  final Yayasan yayasan;

  KartuPerawatan({
    required this.id,
    required this.pengguna,
    this.log,
    this.logInvetarisPerawatan,
    required this.perawatans,
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
      perawatans: json['perawatans']
          ?.map(
              (perawatan) => Perawatan.fromJson(perawatan))
          .toList(),
      unit: Unit.fromJson(json['unit']),
      yayasan: Yayasan.fromJson(json['yayasan']),
    );
  }
}
