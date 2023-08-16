import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/auth/application/auth_controller.dart';

import '../../constants.dart';

class SignInTab extends ConsumerStatefulWidget {
  const SignInTab({super.key, required this.isRegister});

  final bool isRegister;

  @override
  ConsumerState<SignInTab> createState() => _SignInTabState();
}

class _SignInTabState extends ConsumerState<SignInTab> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? validateEmailAddress(String? input) {
    if (input == null ||
        input.isEmpty ||
        !RegExp(Regex.email).hasMatch(input)) {
      return tr('sign_in_page.validator_failure.email_failure');
    } else {
      return null;
    }
  }

  String? validatePassword(String? input) {
    if (input == null ||
        input.isEmpty ||
        !RegExp(Regex.password).hasMatch(input)) {
      return tr('sign_in_page.validator_failure.password_failure');
    } else {
      return null;
    }
  }

  Future<void> signUp(String email, String password) async {
    if (widget.isRegister) {
      await ref
          .read(authControllerProvider.notifier)
          .register(email: email, password: password);
    } else {
      await ref
          .read(authControllerProvider.notifier)
          .login(email: email, password: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  widget.isRegister ? Icons.person_add : Icons.account_circle,
                  size: 250.0,
                  color: Theme.of(context).hintColor,
                )),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                autofocus: true,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.mail_outline),
                  labelText:
                      tr('sign_in_page.text_form_field_title.email_label'),
                ),
                validator: validateEmailAddress,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock_outline),
                  labelText:
                      tr('sign_in_page.text_form_field_title.password_label'),
                  errorMaxLines: 2,
                ),
                validator: validatePassword,
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await signUp(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                }
              },
              child: ref.watch(authControllerProvider).maybeWhen(
                    isLoading: () => const CircularProgressIndicator(),
                    orElse: () => Text(widget.isRegister
                        ? tr('sign_in_page.button_title.register_button_title')
                        : tr('sign_in_page.button_title.login_button_title')),
                  ),
            )
          ],
        ),
      ),
    );
  }
}
