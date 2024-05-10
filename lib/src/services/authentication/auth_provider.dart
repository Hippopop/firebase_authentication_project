import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_authentication_project/src/domains/firebase/auth_repository/auth_repository.dart';

final authStateProvider =
    StreamProvider<({bool isAuthenticated, User? currentUser})>((ref) async* {
  final state = ref.watch(authRepositoryProvider);
  yield* state.currentAuthStateStream().map(
        (event) => (isAuthenticated: event != null, currentUser: event),
      );
});
