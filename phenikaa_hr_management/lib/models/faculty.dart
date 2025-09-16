class Faculty {
  final String id;
  final String name;
  final String universityId;
  final String? description;
  final DateTime createdAt;

  Faculty({
    required this.id,
    required this.name,
    required this.universityId,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'universityId': universityId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Faculty.fromMap(Map<String, dynamic> map) {
    return Faculty(
      id: map['id'],
      name: map['name'],
      universityId: map['universityId'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Faculty copyWith({
    String? id,
    String? name,
    String? universityId,
    String? description,
    DateTime? createdAt,
  }) {
    return Faculty(
      id: id ?? this.id,
      name: name ?? this.name,
      universityId: universityId ?? this.universityId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}