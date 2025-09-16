class Department {
  final String id;
  final String name;
  final String facultyId;
  final String? description;
  final DateTime createdAt;

  Department({
    required this.id,
    required this.name,
    required this.facultyId,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'facultyId': facultyId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Department.fromMap(Map<String, dynamic> map) {
    return Department(
      id: map['id'],
      name: map['name'],
      facultyId: map['facultyId'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Department copyWith({
    String? id,
    String? name,
    String? facultyId,
    String? description,
    DateTime? createdAt,
  }) {
    return Department(
      id: id ?? this.id,
      name: name ?? this.name,
      facultyId: facultyId ?? this.facultyId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}