import 'dart:convert';

import 'package:firebase_authentication_project/src/domains/local/auth_credential_storage/model/auth_credentials.dart';

class AuthenticationStateModel {
  final bool rememberMe;
  final bool showPassword;
  final AuthCredentialModel? savedAuthCred;

  const AuthenticationStateModel({
    this.savedAuthCred,
    this.rememberMe = false,
    this.showPassword = false,
  });

  AuthenticationStateModel copyWith({
    bool? rememberMe,
    bool? showPassword,
    AuthCredentialModel? savedAuthCred,
  }) {
    return AuthenticationStateModel(
      rememberMe: rememberMe ?? this.rememberMe,
      showPassword: showPassword ?? this.showPassword,
      savedAuthCred: savedAuthCred ?? this.savedAuthCred,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'rememberMe': rememberMe,
      'showPassword': showPassword,
      'savedAuthCred': savedAuthCred?.toMap(),
    };
  }

  factory AuthenticationStateModel.fromMap(Map<String, dynamic> map) {
    return AuthenticationStateModel(
      rememberMe: map['rememberMe'] as bool,
      showPassword: map['showPassword'] as bool,
      savedAuthCred: map['savedAuthCred'] != null
          ? AuthCredentialModel.fromMap(
              map['savedAuthCred'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthenticationStateModel.fromJson(String source) =>
      AuthenticationStateModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AuthenticationStateModel(rememberMe: $rememberMe, showPassword: $showPassword, savedAuthCred: $savedAuthCred)';

  @override
  bool operator ==(covariant AuthenticationStateModel other) {
    if (identical(this, other)) return true;

    return other.rememberMe == rememberMe &&
        other.showPassword == showPassword &&
        other.savedAuthCred == savedAuthCred;
  }

  @override
  int get hashCode =>
      rememberMe.hashCode ^ showPassword.hashCode ^ savedAuthCred.hashCode;
}
