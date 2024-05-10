import 'package:firebase_authentication_project/firebase_options.dart';
import 'package:firebase_authentication_project/src/domains/local/auth_credential_storage/local_auth_credential_storage.dart';
import 'package:firebase_authentication_project/src/services/authentication/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final appInitProvider = FutureProvider<void>(
  (ref) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await ref.read(authStateProvider.future);
    await ref.read(authStorageProvider.future);
  },
);
