import 'base_model.dart';

enum UserStatus {
  active,
  disabled,
  invited;

  String toJson() => name;

  static UserStatus fromJson(String json) => UserStatus.values.byName(json);
}

class User extends BaseModel {
  @override
  final String id;
  final String accountId;
  final String email;
  final String? name;
  final UserStatus status;
  final String? inviteToken;
  final String? invitedById;
  final String? verificationCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.accountId,
    required this.email,
    this.name,
    required this.status,
    this.inviteToken,
    this.invitedById,
    this.verificationCode,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'accountId': accountId,
      'email': email,
      'name': name,
      'status': status.toJson(),
      'inviteToken': inviteToken,
      'invitedById': invitedById,
      'verificationCode': verificationCode,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      accountId: map['accountId'],
      email: map['email'],
      name: map['name'],
      status: UserStatus.fromJson(map['status']),
      inviteToken: map['inviteToken'],
      invitedById: map['invitedById'],
      verificationCode: map['verificationCode'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  User copyWith({
    String? id,
    String? accountId,
    String? email,
    String? name,
    UserStatus? status,
    String? inviteToken,
    String? invitedById,
    String? verificationCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      email: email ?? this.email,
      name: name ?? this.name,
      status: status ?? this.status,
      inviteToken: inviteToken ?? this.inviteToken,
      invitedById: invitedById ?? this.invitedById,
      verificationCode: verificationCode, // Allow null for verification code
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
