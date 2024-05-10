import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  final duration = const Duration(seconds: 3);
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: duration,
    );
    _animationController
      ..addListener(() => setState(() {}))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return Opacity(
            opacity: (1 - _animationController.value),
            child: Center(
              child: SizedBox.square(
                dimension: constraints.maxWidth - 120,
                child: const FittedBox(
                  child: Center(
                    child: Icon(Icons.star),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
