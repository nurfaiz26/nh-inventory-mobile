class JenisPerawatan {
  final int id;
  final String nama;

  JenisPerawatan({
    required this.id,
    required this.nama,
  });

  factory JenisPerawatan.fromJson(Map<String, dynamic> json) {
    return JenisPerawatan(
      id: json['id'],
      nama: json['nama'],
    );
  }
}
