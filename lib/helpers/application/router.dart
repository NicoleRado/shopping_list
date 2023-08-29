import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../account_payment/presentation/account_payment_page.dart';
import '../../auth/application/auth_controller.dart';
import '../../auth/presentation/sign_in_page.dart';
import '../../list_entries/presentation/list_entries_page.dart';
import '../../lists/presentation/list_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: '/',
          builder: (context, state) => const ListPage(),
          routes: [
            GoRoute(
              path: 'accountPayment',
              name: 'accountPayment',
              builder: (context, state) => const AccountPaymentPage(),
            ),
            GoRoute(
              path: 'list_entries_page/:id',
              name: 'list_entries_page',
              builder: (context, state) {
                final id = state.pathParameters['id'];
                return ListEntriesPage(id: id!);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/signIn',
          name: '/signIn',
          builder: (context, state) => const SignInPage(),
        ),
      ],
      redirect: (_, state) {
        if (state.uri.toString() != '/signIn') {
          return ref.watch(
            authControllerProvider.select(
              (currentState) => currentState.maybeWhen(
                isAuthenticated: () => state.uri.toString(),
                orElse: () => '/signIn',
              ),
            ),
          );
        }
        return null;
      });
});
