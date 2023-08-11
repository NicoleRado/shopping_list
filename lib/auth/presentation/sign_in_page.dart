import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/auth/application/auth_controller.dart';
import 'package:shopping_list/auth/presentation/sign_in_tab.dart';

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      authControllerProvider.select(
        (currentState) => currentState.maybeWhen(
          isFailure: (failure) => failure,
          orElse: () => null,
        ),
      ),
      ((previous, next) {
        if (next != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                next.when(
                    loginFailure: () =>
                        'Something went wrong during login. Please try again.',
                    registerFailure: (message) =>
                        'Something went wrong during register. $message. Please try again.',
                    signOutFailure: () =>
                        'Something went wrong during sign out. Please try again.'),
              ),
            ),
          );
        }
      }),
    );

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Authenticate'),
            centerTitle: true,
            backgroundColor: Theme.of(context).primaryColor,
            bottom: TabBar(
              labelColor: Theme.of(context).canvasColor,
              tabs: const [
                Tab(text: 'Login'),
                Tab(text: 'Register'),
              ],
            ),
          ),
          body: const TabBarView(children: [
            SignInTab(isRegister: false),
            SignInTab(isRegister: true),
          ]),
        ));
  }
}
