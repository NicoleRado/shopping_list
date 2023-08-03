import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping_list/auth/application/auth_controller.dart';

import 'auth/presentation/sign_in_page.dart';
import 'lists/presentation/list_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ListPage(),
        ),
        GoRoute(
          path: '/signIn',
          builder: (context, state) => const SignInPage(),
        ),
      ],
      redirect: (_, state) {
        if (state.uri.toString() != '/signIn') {
          return ref.watch(
            authControllerProvider.select(
              (currentState) => currentState.maybeWhen(
                isAuthenticated: (_) => '/',
                orElse: () => '/signIn',
              ),
            ),
          );
        }
      });
});
