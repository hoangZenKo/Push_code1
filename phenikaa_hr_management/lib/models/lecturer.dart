class Lecturer {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? position;
  final String majorId;
  final DateTime createdAt;

  Lecturer({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.position,
    required this.majorId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'position': position,
      'majorId': majorId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Lecturer.fromMap(Map<String, dynamic> map) {
    return Lecturer(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      position: map['position'],
      majorId: map['majorId'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Lecturer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? position,
    String? majorId,
    DateTime? createdAt,
  }) {
    return Lecturer(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      position: position ?? this.position,
      majorId: majorId ?? this.majorId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}