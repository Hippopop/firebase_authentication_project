import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_authentication_project/src/app.dart';
import 'package:firebase_authentication_project/src/features/initializer/views/error_screen.dart';
import 'package:firebase_authentication_project/src/features/initializer/views/splash_screen.dart';

import '../controllers/app_initialization_provider.dart';

class AppInitializer extends ConsumerWidget {
  const AppInitializer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appInitProvider);

    return appStartupState.when(
      data: (_) => const MyApp(),
      loading: () => const SplashScreen(),
      error: (error, stacktrace) => ErrorApp(
        error: error,
        stackTrace: stacktrace,
        onRefresh: () => ref.invalidate(appInitProvider),
      ),
    );
  }
}
