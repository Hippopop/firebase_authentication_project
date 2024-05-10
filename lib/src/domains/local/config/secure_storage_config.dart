import 'package:firebase_authentication_project/src/constants/settings/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => FlutterSecureStorage(
    aOptions: (() => const AndroidOptions(
          encryptedSharedPreferences: true,
          preferencesKeyPrefix: AppSettings.apiKey,
        ))(),
  ),
);
