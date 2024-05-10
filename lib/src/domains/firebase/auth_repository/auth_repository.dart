import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication_project/src/domains/firebase/config/firebase_configs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final authRepositoryProvider = Provider<FirebaseAuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return FirebaseAuthRepository(authProvider: firebaseAuth);
});

class FirebaseAuthRepository {
  final FirebaseAuth authProvider;
  FirebaseAuthRepository({required this.authProvider});

  Future<void> signOut() => authProvider.signOut();
  Stream<User?> userStateChangeStream() => authProvider.userChanges();
  Stream<User?> currentAuthStateStream() => authProvider.authStateChanges();

  Future<UserCredential> passwordSignIn({
    required String email,
    required String password,
  }) async {
    try {
      return authProvider.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e, s) {
      log(
        "#Error(FirebaseAuthRepository -> passwordSignIn)",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<UserCredential> passwordRegistration({
    required String email,
    required String password,
  }) async {
    try {
      return authProvider.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e, s) {
      log(
        "#Error(FirebaseAuthRepository -> passwordRegistration)",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  Future<UserCredential> authenticateWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e, s) {
      log(
        "#Error(FirebaseAuthRepository -> authenticateWithGoogle)",
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }
}

extension AuthExceptionSerializer on FirebaseAuthException {}
