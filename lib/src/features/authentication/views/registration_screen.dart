import 'package:firebase_authentication_project/src/constants/assets/assets.dart';
import 'package:firebase_authentication_project/src/domains/local/auth_credential_storage/model/auth_credentials.dart';
import 'package:firebase_authentication_project/src/features/authentication/controllers/authentication_controller.dart';
import 'package:firebase_authentication_project/src/features/authentication/views/login_screen.dart';
import 'package:firebase_authentication_project/src/services/theme/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_authentication_project/src/constants/design/paddings.dart';

import 'package:firebase_authentication_project/src/global/widgets/custom_titled_textfield.dart';
import 'package:firebase_authentication_project/src/global/widgets/responsive_two_sided_card.dart';
import 'package:firebase_authentication_project/src/utilities/extensions/size_utilities.dart';
import 'package:firebase_authentication_project/src/utilities/forms/custom_form_validator.dart';
import 'package:firebase_authentication_project/src/utilities/responsive/responsive_state_wrapper.dart';
import 'package:go_router/go_router.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});
  static const route = "/RegistrationScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveParentWrapper(builder: (context, currentState) {
        return switch (currentState) {
          > ResponsiveState.sm => Center(
              child: ResponsiveTwoSidedCard(
                leftSideWidget: const LeftSideRegistrationPart(),
                rightSideWidget: Padding(
                  padding: vertical24 + vertical16 + horizontal12,
                  child: const VerticalRegistrationArea(
                    showForSinglePart: true,
                  ),
                ),
              ),
            ),
          _ => SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveState.xs.max,
                  ),
                  child: const VerticalRegistrationArea(
                    showForSinglePart: false,
                  ),
                ),
              ),
            ),
        };
      }),
    );
  }
}

class VerticalRegistrationArea extends StatefulWidget {
  const VerticalRegistrationArea({
    super.key,
    required this.showForSinglePart,
  });

  final bool showForSinglePart;

  @override
  State<VerticalRegistrationArea> createState() =>
      _VerticalRegistrationAreaState();
}

class _VerticalRegistrationAreaState extends State<VerticalRegistrationArea> {
  late final emailFocus = FocusNode();
  late final emailController = TextEditingController();
  late final passwordFocus = FocusNode();
  late final passwordController = TextEditingController();
  late final confirmPasswordFocus = FocusNode();
  late final confirmPasswordController = TextEditingController();

  late final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();

    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(
        builder: (context, ref, child) {
          final authController = ref.watch(authenticationControllerProvider);

          final VoidCallback? registerFunction = authController.isLoading
              ? null
              : () async {
                  final formValid = formKey.currentState?.validate();
                  if (formValid ?? false) {
                    final controller = ref.read(
                      authenticationControllerProvider.notifier,
                    );
                    controller.attemptRegistration(
                      data: AuthCredentialModel(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    );
                  }
                };
          return SingleChildScrollView(
            child: Padding(
              padding: horizontal24,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (!widget.showForSinglePart) ...[
                      32.height,
                      Text(
                        "Create an account!",
                        style: context.text.headlineMedium,
                      ),
                      Text(
                        "Start a organized life today.",
                        style: context.text.labelMedium?.copyWith(
                          color: context.color.borderGreyColor,
                        ),
                      ),
                      25.height,
                    ],
                    const Center(
                      child: CircleAvatar(
                        minRadius: 32,
                        maxRadius: 72,
                        backgroundColor: Colors.white,
                        foregroundImage: AssetImage(ImageAssets.profile),
                      ),
                    ),
                    25.height,
                    CustomTitledTextFormField(
                      title: "Email",
                      hintText: "Please Enter Your Email Address",
                      validators: [isRequired, isEmail],
                      focus: emailFocus,
                      nextFocus: passwordFocus,
                      controller: emailController,
                      inputType: TextInputType.emailAddress,
                    ),
                    12.height,
                    CustomTitledTextFormField(
                      title: "Password",
                      hintText: "Please Enter Your Password",
                      isObscured:
                          !(authController.valueOrNull?.showPassword ?? false),
                      validators: [isRequired, tooShort6],
                      controller: passwordController,
                      focus: passwordFocus,
                      nextFocus: confirmPasswordFocus,
                      suffixIcon: IconButton(
                        onPressed: () => ref
                            .read(authenticationControllerProvider.notifier)
                            .switchPasswordVisibility(),
                        icon: Icon(
                          (authController.valueOrNull?.showPassword ?? false)
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    12.height,
                    CustomTitledTextFormField(
                      title: "Confirm Password",
                      hintText: "Please Re-Enter Your Password",
                      isObscured:
                          !(authController.valueOrNull?.showPassword ?? false),
                      validators: [
                        isRequired,
                        tooShort6,
                        (value, name) => (
                              value != passwordController.text,
                              "$name doesn't match with Password!"
                            ),
                      ],
                      controller: confirmPasswordController,
                      focus: confirmPasswordFocus,
                      suffixIcon: IconButton(
                        onPressed: () => ref
                            .read(authenticationControllerProvider.notifier)
                            .switchPasswordVisibility(),
                        icon: Icon(
                          (authController.valueOrNull?.showPassword ?? false)
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                      submit: (value) => registerFunction?.call(),
                    ),
                    16.height,
                    Builder(builder: (context) {
                      return FilledButton(
                        onPressed: registerFunction,
                        child: authController.isLoading
                            ? const Padding(
                                padding: vertical8,
                                child: SizedBox.square(
                                  dimension: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: vertical8,
                                child: Text(
                                  "Sign Up",
                                ),
                              ),
                      );
                    }),
                    if (!widget.showForSinglePart) ...[
                      18.height,
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(),
                          ),
                          Padding(
                            padding: horizontal18,
                            child: Text(
                              "Or With",
                              style: context.text.labelMedium?.copyWith(
                                color: context.color.secondaryText,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(),
                          ),
                        ],
                      ),
                      18.height,
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: Padding(
                                padding: vertical8,
                                child: SizedBox.square(
                                  dimension: 24,
                                  child: Padding(
                                    padding: all3,
                                    child: Image.asset(AssetIcons.googleIcon),
                                  ),
                                ),
                              ),
                              label: const Text("Google"),
                            ),
                          ),
                        ],
                      ),
                      32.height,
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: context.text.titleMedium,
                            children: [
                              TextSpan(
                                text: "Login.",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => context.go(LoginScreen.route),
                                style: TextStyle(
                                  color: context.color.mainSecondBatch,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      32.height,
                    ],
                    if (widget.showForSinglePart) 100.height,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LeftSideRegistrationPart extends StatelessWidget {
  const LeftSideRegistrationPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox.expand(
          child: Image.asset(
            ImageAssets.loginImage,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox.expand(
          child: ColoredBox(
            color: Colors.white38,
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 16,
          bottom: 16,
          child: Consumer(
            builder: (context, ref, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        32.height,
                        Text(
                          "Create an account!",
                          style: context.text.headlineLarge?.copyWith(
                            color: context.color.opposite,
                          ),
                        ),
                        Text(
                          "Start a organized life today.",
                          style: context.text.headlineSmall?.copyWith(
                            color: context.color.opposite,
                          ),
                        ),
                        25.height,
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Expanded(
                        child: Divider(),
                      ),
                      Padding(
                        padding: horizontal18,
                        child: Text(
                          "Or With",
                          style: context.text.labelMedium?.copyWith(
                            color: context.color.secondaryText,
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Divider(),
                      ),
                    ],
                  ),
                  18.height,
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => ref
                              .read(authenticationControllerProvider.notifier)
                              .attemptGoogleAuth(),
                          icon: Padding(
                            padding: vertical8,
                            child: SizedBox.square(
                              dimension: 24,
                              child: Padding(
                                padding: all3,
                                child: Image.asset(AssetIcons.googleIcon),
                              ),
                            ),
                          ),
                          label: const Text("Google"),
                        ),
                      ),
                    ],
                  ),
                  32.height,
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: context.text.titleMedium,
                        children: [
                          TextSpan(
                            text: "Login.",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => context.go(LoginScreen.route),
                            style: TextStyle(
                              color: context.color.mainSecondBatch,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  48.height,
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
