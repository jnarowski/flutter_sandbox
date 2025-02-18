import '../utils/timestamp_parser.dart';

enum UserStatus {
  active,
  disabled,
  invited;
}

class User {
  final String id;
  final String? email;
  final String? name;
  final String accountId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserStatus? status;

  final String? inviteToken;
  final String? invitedById;

  User({
    required this.id,
    required this.accountId,
    required this.email,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.status,
    this.inviteToken,
    this.invitedById,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      accountId: map['accountId'] ?? '',
      name: map['name'] as String?,
      email: map['email'] as String?,
      status: map['status'] as UserStatus?,
      inviteToken: map['inviteToken'] as String?,
      invitedById: map['invitedById'] as String?,
      createdAt: TimestampParser.parseTimestamp(map['createdAt']),
      updatedAt: TimestampParser.parseTimestamp(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'accountId': accountId,
      'status': status,
      'inviteToken': inviteToken,
      'invitedById': invitedById,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
