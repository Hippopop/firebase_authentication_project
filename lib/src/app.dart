import 'package:firebase_authentication_project/src/services/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_authentication_project/src/services/router/app_router.dart';

import 'constants/settings/app_settings.dart';
import 'utilities/dribble_snackbar/scaffold_utilities.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final router = ref.watch(appRouterProvider);
        return MaterialApp.router(
          theme: lightTheme,
          routerConfig: router,
          title: AppSettings.appName,
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: ScaffoldUtilities.instance.key,
        );
      },
    );
  }
}
