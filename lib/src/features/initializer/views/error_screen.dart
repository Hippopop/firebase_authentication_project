import 'package:flutter/material.dart';
import 'package:firebase_authentication_project/src/constants/design/paddings.dart';
import 'package:firebase_authentication_project/src/services/theme/light/light_theme.dart';
import 'package:firebase_authentication_project/src/utilities/extensions/size_utilities.dart';
import 'package:firebase_authentication_project/src/utilities/dribble_snackbar/scaffold_utilities.dart';

class ErrorApp extends StatelessWidget {
  const ErrorApp({
    super.key,
    this.error,
    this.onRefresh,
    this.stackTrace,
  });

  final Object? error;
  final VoidCallback? onRefresh;
  final StackTrace? stackTrace;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      home: GlobalErrorPage(
        error: error,
        stackTrace: stackTrace,
        onRefreshCall: onRefresh,
      ),
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: ScaffoldUtilities.instance.key,
    );
  }
}

class GlobalErrorPage extends StatelessWidget {
  const GlobalErrorPage({
    super.key,
    this.error,
    this.stackTrace,
    this.onRefreshCall,
  });

  final Object? error;
  final StackTrace? stackTrace;
  final VoidCallback? onRefreshCall;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: horizontal16,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Error",
                  ),
                  Text(error.toString()),
                  24.height,
                  if (onRefreshCall != null) ...[
                    ElevatedButton(
                      onPressed: onRefreshCall,
                      child: const Text("Refresh"),
                    ),
                  ],
                  24.height,
                  Text(
                    stackTrace.toString(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
