import 'package:firebase_authentication_project/src/constants/assets/assets.dart';
import 'package:firebase_authentication_project/src/constants/design/paddings.dart';
import 'package:firebase_authentication_project/src/domains/firebase/auth_repository/auth_repository.dart';
import 'package:firebase_authentication_project/src/services/authentication/auth_provider.dart';
import 'package:firebase_authentication_project/src/services/theme/app_theme.dart';
import 'package:firebase_authentication_project/src/utilities/extensions/size_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Homepage extends StatelessWidget {
  static const route = "/Homepage";
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Consumer(
            builder: (context, ref, child) {
              final user = ref.watch(authStateProvider);
              final currentUser = user.requireValue;
              return SingleChildScrollView(
                child: Padding(
                  padding: horizontal12,
                  child: Column(
                    children: [
                      Text(
                        "Whooaah! You've reached your final destination.",
                        textAlign: TextAlign.center,
                        style: context.text.headlineMedium,
                      ),
                      24.height,
                      CircleAvatar(
                        minRadius: 32,
                        maxRadius: 72,
                        backgroundColor: Colors.white,
                        foregroundImage: NetworkImage(
                            currentUser.currentUser?.photoURL ?? ""),
                        backgroundImage: const AssetImage(ImageAssets.profile),
                      ),
                      24.height,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            currentUser.currentUser?.email ?? "",
                            style: context.text.headlineSmall,
                          ),
                          if (currentUser.currentUser?.emailVerified ??
                              false) ...[
                            8.width,
                            const Icon(
                              Icons.verified,
                              color: Colors.green,
                            ),
                          ],
                        ],
                      ),
                      12.height,
                      Text(
                        currentUser.currentUser?.displayName ?? "",
                        style: context.text.headlineSmall,
                      ),
                      12.height,
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () {
                                final repo = ref.read(authRepositoryProvider);
                                repo.signOut();
                              },
                              child: const Text("Logout"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
