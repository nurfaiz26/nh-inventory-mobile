class Wilayah {
  final String nama;
  final int id;
  final DateTime? created_at;
  final DateTime? updated_at;

  Wilayah(
      {required this.id, this.created_at, this.updated_at, required this.nama});

  // Factory method to create a Wilayah from JSON
  factory Wilayah.fromJson(Map<String, dynamic> json) {
    return Wilayah(
      id: json['id'],
      nama: json['nama'],
      created_at: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updated_at: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Method to convert a Wilayah to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'created_at': created_at?.toIso8601String(),
      'updated_at': updated_at?.toIso8601String(),
    };
  }
}
