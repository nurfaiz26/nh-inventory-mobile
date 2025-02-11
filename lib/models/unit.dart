class Unit {
  final String nama;
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Unit(
      {required this.id, this.createdAt, this.updatedAt, required this.nama});

  // Factory method to create a Unit from JSON
  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'],
      nama: json['nama'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Method to convert a Unit to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
