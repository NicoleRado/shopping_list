import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/presentation/styled_scaffold.dart';
import '../application/auth_controller.dart';
import 'sign_in_tab.dart';

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
                      tr('sign_in_page.sign_in_error.login_failure'),
                  registerFailure: (message) => tr(
                      'sign_in_page.sign_in_error.register_failure',
                      args: [message!]),
                  signOutFailure: () =>
                      tr('sign_in_page.sign_in_error.sign_out_failure'),
                ),
              ),
            ),
          );
        }
      }),
    );

    return DefaultTabController(
        length: 2,
        child: StyledScaffold(
          title: tr('sign_in_page.sign_in_page_title'),
          bottom: TabBar(
            labelColor: Theme.of(context).canvasColor,
            tabs: [
              Tab(text: tr('sign_in_page.sign_in_tabs.login_tab_title')),
              Tab(text: tr('sign_in_page.sign_in_tabs.register_tab_title')),
            ],
          ),
          body: const TabBarView(children: [
            SignInTab(isRegister: false),
            SignInTab(isRegister: true),
          ]),
        ));
  }
}
