import '../utils/timestamp_parser.dart';

enum UserStatus {
  active,
  disabled,
  invited;

  String toJson() => name;

  static UserStatus fromJson(String json) => UserStatus.values.byName(json);
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
  final String? verificationCode;

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
    this.verificationCode,
  });

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      accountId: map['accountId'] ?? '',
      name: map['name'] as String?,
      email: map['email'] as String?,
      status: UserStatus.fromJson(map['status'] as String),
      inviteToken: map['inviteToken'] as String?,
      invitedById: map['invitedById'] as String?,
      verificationCode: map['verificationCode'] as String?,
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
      'status': status?.toJson(),
      'inviteToken': inviteToken,
      'invitedById': invitedById,
      'verificationCode': verificationCode,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
