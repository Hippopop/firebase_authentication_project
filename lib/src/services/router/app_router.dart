import 'package:firebase_authentication_project/src/features/authentication/views/login_screen.dart';
import 'package:firebase_authentication_project/src/features/authentication/views/registration_screen.dart';
import 'package:firebase_authentication_project/src/services/authentication/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_authentication_project/src/features/homepage/views/homepage.dart';

final appRouterProvider = Provider<GoRouter>(
  (ref) {
    final authState = ref.watch(authStateProvider);
    return GoRouter(
      routes: [
        GoRoute(
          path: Homepage.route,
          builder: (context, state) => const Homepage(),
        ),
        GoRoute(
          path: LoginScreen.route,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: RegistrationScreen.route,
          builder: (context, state) => const RegistrationScreen(),
        ),
      ],
      redirect: (context, state) async {
        final path = state.matchedLocation;
        if (authState.isLoading || authState.hasError) return null;
        final value = authState.value;
        bool isAuthPath =
            (path == LoginScreen.route || path == RegistrationScreen.route);
        if ((value?.isAuthenticated ?? false) && isAuthPath) {
          return Homepage.route;
        }
        return null;
      },
    );
  },
);
