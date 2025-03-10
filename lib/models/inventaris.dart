import 'package:nh_manajemen_inventory/models/Merk.dart';
import 'package:nh_manajemen_inventory/models/Seri.dart';
import 'package:nh_manajemen_inventory/models/Unit.dart';
import 'package:nh_manajemen_inventory/models/barang.dart';
import 'package:nh_manajemen_inventory/models/kartu_perawatan.dart';

import 'Wilayah.dart';

class Inventaris {
  final int id;
  final String kode;
  final String nilaiAwal;
  final String nilaiBuku;
  final String pengguna;
  final String status;
  final String penyusutan;
  final String? keterangan;
  final String? foto;
  final Barang barang;
  final Wilayah wilayah;
  final Merk merk;
  final Seri seri;
  final Unit unit;
  final KartuPerawatan? kartuPerawatan;

  Inventaris({
    required this.id,
    required this.kode,
    required this.nilaiAwal,
    required this.nilaiBuku,
    required this.pengguna,
    required this.status,
    required this.penyusutan,
    this.keterangan,
    this.foto,
    required this.barang,
    required this.wilayah,
    required this.merk,
    required this.seri,
    required this.unit,
    this.kartuPerawatan,
  });

  factory Inventaris.fromJson(Map<String, dynamic> json) {
    return Inventaris(
      id: json['id'],
      kode: json['kode'],
      nilaiAwal: json['nilai_awal'].toString(),
      nilaiBuku: json['nilai_buku'].toString(),
      pengguna: json['pengguna'],
      status: json['status'],
      penyusutan: json['penyusutan'],
      keterangan: json['keterangan'],
      foto: json['foto'],
      barang: Barang.fromJson(json['barang']),
      wilayah: Wilayah.fromJson(json['wilayah']),
      merk: Merk.fromJson(json['merk']),
      seri: Seri.fromJson(json['seri']),
      unit: Unit.fromJson(json['unit']),
      kartuPerawatan: json['kartu_perawatan'] != null ? KartuPerawatan.fromJson(json['kartu_perawatan']) : null,
    );
  }
}