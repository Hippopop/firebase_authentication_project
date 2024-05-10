import 'package:firebase_authentication_project/src/constants/assets/assets.dart';
import 'package:firebase_authentication_project/src/domains/local/auth_credential_storage/local_auth_credential_storage.dart';
import 'package:firebase_authentication_project/src/domains/local/auth_credential_storage/model/auth_credentials.dart';
import 'package:firebase_authentication_project/src/features/authentication/controllers/authentication_controller.dart';
import 'package:firebase_authentication_project/src/features/authentication/views/registration_screen.dart';
import 'package:firebase_authentication_project/src/services/theme/app_theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_authentication_project/src/constants/design/border_radius.dart';
import 'package:firebase_authentication_project/src/constants/design/paddings.dart';
import 'package:firebase_authentication_project/src/global/widgets/custom_titled_textfield.dart';
import 'package:firebase_authentication_project/src/global/widgets/responsive_two_sided_card.dart';
import 'package:firebase_authentication_project/src/utilities/extensions/size_utilities.dart';
import 'package:firebase_authentication_project/src/utilities/forms/custom_form_validator.dart';
import 'package:firebase_authentication_project/src/utilities/responsive/responsive_state_wrapper.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const route = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResponsiveParentWrapper(
        builder: (context, state) {
          return switch (state) {
            > ResponsiveState.sm => Center(
                child: ResponsiveTwoSidedCard(
                  leftSideWidget: SizedBox.expand(
                    child: Image.asset(
                      ImageAssets.loginImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                  rightSideWidget: Padding(
                    padding: vertical24 + vertical16 + horizontal12,
                    child: const VerticalLoginArea(),
                  ),
                ),
              ),
            _ => SafeArea(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: ResponsiveState.xs.max,
                    ),
                    child: const VerticalLoginArea(),
                  ),
                ),
              )
          };
        },
      ),
    );
  }
}

class VerticalLoginArea extends ConsumerStatefulWidget {
  const VerticalLoginArea({super.key});

  @override
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VerticalLoginAreaState();
}

class _VerticalLoginAreaState extends ConsumerState<VerticalLoginArea> {
  late final formKey = GlobalKey<FormState>();

  late final emailFocus = FocusNode();
  late final TextEditingController emailController;
  late final passwordFocus = FocusNode();
  late final TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    final currentVal = ref.read(authStorageProvider).requireValue;
    emailController = TextEditingController(text: currentVal?.email);
    passwordController = TextEditingController(text: currentVal?.password);
  }

  @override
  void dispose() {
    emailFocus.dispose();
    emailController.dispose();
    passwordFocus.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Consumer(
        builder: (context, ref, child) {
          final authController = ref.watch(authenticationControllerProvider);
          final VoidCallback? loginFunction = authController.isLoading
              ? null
              : () async {
                  final formState = formKey.currentState?.validate();
                  if (formState ?? false) {
                    final controller = ref.read(
                      authenticationControllerProvider.notifier,
                    );
                    controller.attemptLogin(
                      data: AuthCredentialModel(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    );
                  }
                };
          return Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: horizontal24,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Hi, Welcome Back! 👋",
                        style: context.text.headlineMedium,
                      ),
                      Text(
                        "Hello again, you've been missed!",
                        style: context.text.labelMedium?.copyWith(
                          color: context.color.borderGreyColor,
                        ),
                      ),
                      50.height,
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
                            !(authController.valueOrNull?.showPassword ??
                                false),
                        validators: [isRequired, tooShort6],
                        focus: passwordFocus,
                        controller: passwordController,
                        submit: (_) => loginFunction?.call(),
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
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Checkbox(
                                  value:
                                      (authController.valueOrNull?.rememberMe ??
                                          false),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  onChanged: (value) => ref
                                      .read(authenticationControllerProvider
                                          .notifier)
                                      .switchRememberMe(),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                      onTap: () {
                                        final controller = ref.read(
                                          authenticationControllerProvider
                                              .notifier,
                                        );
                                        controller.switchRememberMe();
                                      },
                                      child: const Padding(
                                        padding: all6,
                                        child: Text(
                                          "Remember me",
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                borderRadius: br8,
                                onTap: () {},
                                child: Padding(
                                  padding: all6,
                                  child: Text(
                                    "Forget password",
                                    style: context.text.labelMedium?.copyWith(
                                      color: context.color.errorState,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      16.height,
                      Builder(builder: (context) {
                        return FilledButton(
                          onPressed: loginFunction,
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
                                    "Login",
                                  ),
                                ),
                        );
                      }),
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
                              onPressed: () => ref
                                  .read(
                                      authenticationControllerProvider.notifier)
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
                            text: "Don't have an account? ",
                            style: context.text.titleMedium,
                            children: [
                              TextSpan(
                                text: "Register.",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () =>
                                      context.push(RegistrationScreen.route),
                                style: TextStyle(
                                  color: context.color.mainSecondBatch,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
