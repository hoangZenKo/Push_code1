class University {
  final String id;
  final String name;
  final String? address;
  final String? phone;
  final String? email;
  final DateTime createdAt;

  University({
    required this.id,
    required this.name,
    this.address,
    this.phone,
    this.email,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory University.fromMap(Map<String, dynamic> map) {
    return University(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      phone: map['phone'],
      email: map['email'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  University copyWith({
    String? id,
    String? name,
    String? address,
    String? phone,
    String? email,
    DateTime? createdAt,
  }) {
    return University(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}