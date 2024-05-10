import 'dart:convert';

class AuthCredentialModel {
  final String email;
  final String password;
  AuthCredentialModel({
    required this.email,
    required this.password,
  });

  AuthCredentialModel copyWith({
    String? email,
    String? password,
  }) {
    return AuthCredentialModel(
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  factory AuthCredentialModel.fromMap(Map<String, dynamic> map) {
    return AuthCredentialModel(
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthCredentialModel.fromJson(String source) =>
      AuthCredentialModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthCredentialModel(email: $email, password: $password)';

  @override
  bool operator ==(covariant AuthCredentialModel other) {
    if (identical(this, other)) return true;

    return other.email == email && other.password == password;
  }

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}
