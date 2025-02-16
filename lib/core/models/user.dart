class User {
  final String id;
  final String? email;
  final String? name;
  final String accountId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.accountId,
    required this.email,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
        id: map['id'] ?? '', // Provide default empty string for required fields
        accountId: map['accountId'] ?? '',
        name: map['name'] as String?, // Optional fields can be null
        email: map['email'] as String?);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'accountId': accountId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
