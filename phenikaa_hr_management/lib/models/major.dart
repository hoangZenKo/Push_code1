class Major {
  final String id;
  final String name;
  final String? code;
  final String departmentId;
  final String? description;
  final DateTime createdAt;

  Major({
    required this.id,
    required this.name,
    this.code,
    required this.departmentId,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'departmentId': departmentId,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Major.fromMap(Map<String, dynamic> map) {
    return Major(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      departmentId: map['departmentId'],
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  Major copyWith({
    String? id,
    String? name,
    String? code,
    String? departmentId,
    String? description,
    DateTime? createdAt,
  }) {
    return Major(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      departmentId: departmentId ?? this.departmentId,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}