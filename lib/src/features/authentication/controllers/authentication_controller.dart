import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authentication_project/src/domains/firebase/auth_repository/auth_repository.dart';
import 'package:firebase_authentication_project/src/domains/local/auth_credential_storage/local_auth_credential_storage.dart';
import 'package:firebase_authentication_project/src/domains/local/auth_credential_storage/model/auth_credentials.dart';
import 'package:firebase_authentication_project/src/features/authentication/models/authentication_state.dart';
import 'package:firebase_authentication_project/src/utilities/dribble_snackbar/scaffold_utilities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationControllerProvider = AsyncNotifierProvider<
    AuthenticationStateNotifier, AuthenticationStateModel>(
  AuthenticationStateNotifier.new,
);

class AuthenticationStateNotifier
    extends AsyncNotifier<AuthenticationStateModel> {
  @override
  FutureOr<AuthenticationStateModel> build() async {
    final authData = ref.watch(authStorageProvider).requireValue;
    return AuthenticationStateModel(savedAuthCred: authData);
  }

  switchPasswordVisibility() {
    if (state.hasValue) {
      state = AsyncData(
        state.value!.copyWith(showPassword: !(state.value!.showPassword)),
      );
    }
  }

  switchRememberMe() {
    if (state.hasValue) {
      state = AsyncData(
        state.value!.copyWith(rememberMe: !(state.value!.rememberMe)),
      );
    }
  }

  void attemptLogin({required AuthCredentialModel data}) async {
    final prevState = state;
    state = const AsyncValue.loading();
    try {
      final firebaseAuth = ref.read(authRepositoryProvider);
      await firebaseAuth.passwordSignIn(
        email: data.email,
        password: data.password,
      );
      if (prevState.valueOrNull?.rememberMe ?? false) {
        await ref
            .read(authStorageProvider.notifier)
            .storeAuthCredential(data: data);
      }
      state = prevState;
    } catch (e, s) {
      log("#Error(AuthenticationStateNotifier -> attemptLogin)",
          error: e, stackTrace: s);
      state = prevState;
      if (e is FirebaseAuthException) {
        log("$e");
        showToastError("(${e.code}) : ${e.message}", "Login Failed!");
      } else {
        showToastError(e.toString());
      }
    }
  }

  void attemptRegistration({required AuthCredentialModel data}) async {
    final prevState = state;
    state = const AsyncValue.loading();
    try {
      final firebaseAuth = ref.read(authRepositoryProvider);
      await firebaseAuth.passwordRegistration(
        email: data.email,
        password: data.password,
      );
      showToastSuccess("Account registered successfully!", "Congratulations!");

      state = prevState;
    } catch (e, s) {
      log("#Error(AuthenticationStateNotifier -> attemptLogin)",
          error: e, stackTrace: s);
      state = prevState;
      if (e is FirebaseAuthException) {
        log("$e");
        showToastError("(${e.code}) : ${e.message}", "Registration Failed!");
      } else {
        showToastError(e.toString());
      }
    }
  }

  void attemptGoogleAuth() async {
    final prevState = state;
    state = const AsyncValue.loading();
    try {
      final firebaseAuth = ref.read(authRepositoryProvider);
      await firebaseAuth.authenticateWithGoogle();
      showToastSuccess("User authenticated successfully!", "Congratulations!");
      state = prevState;
    } catch (e, s) {
      log("#Error(AuthenticationStateNotifier -> attemptLogin)",
          error: e, stackTrace: s);
      state = prevState;
      if (e is FirebaseAuthException) {
        log("$e");
        showToastError("(${e.code}) : ${e.message}", "Login Failed!");
      } else {
        showToastError(e.toString());
      }
    }
  }
}
