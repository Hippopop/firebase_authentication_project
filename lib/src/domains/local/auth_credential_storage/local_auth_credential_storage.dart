import 'dart:async';

import 'package:firebase_authentication_project/src/domains/local/auth_credential_storage/model/auth_credentials.dart';
import 'package:firebase_authentication_project/src/domains/local/config/secure_storage_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStorageProvider =
    AsyncNotifierProvider<AuthCredentialStorageNotifier, AuthCredentialModel?>(
  AuthCredentialStorageNotifier.new,
);

class AuthCredentialStorageNotifier
    extends AsyncNotifier<AuthCredentialModel?> {
  static const _authCredentialKey = "#AUTH_CREDENTIAL_STORAGE_KEY";
  @override
  FutureOr<AuthCredentialModel?> build() async {
    final storage = ref.watch(secureStorageProvider);
    final storedData = await storage.read(key: _authCredentialKey);
    if (storedData != null) {
      return AuthCredentialModel.fromJson(storedData);
    }
    return null;
  }

  Future<void> storeAuthCredential({required AuthCredentialModel data}) async {
    final storage = ref.read(secureStorageProvider);
    await storage.write(key: _authCredentialKey, value: data.toJson());
    ref.invalidateSelf();
  }
}
