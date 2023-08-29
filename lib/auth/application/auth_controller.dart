import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_failure.dart';
import '../infrastructure/auth_repository.dart';
import 'auth_state.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) => AuthController(
          ref.read(authRepositoryProvider),
        ));

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.authRepository)
      : super(const AuthState.isUnauthenticated()) {
    authStateChanges = authRepository.isAuthenticated().listen(
      (isAuthenticated) {
        state = isAuthenticated
            ? const AuthState.isAuthenticated()
            : const AuthState.isUnauthenticated();
      },
    );
  }

  final AuthRepository authRepository;
  late final StreamSubscription authStateChanges;

  @override
  void dispose() {
    authStateChanges.cancel();
    super.dispose();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.isLoading();

    state = await authRepository
        .signInWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then(
          (result) => result.when(
            ok: (_) => state,
            err: (_) => const AuthState.isFailure(
              authFailure: AuthFailure.loginFailure(),
            ),
          ),
        );
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = const AuthState.isLoading();

    state = await authRepository
        .registerWithEmailAndPassword(
          email: email,
          password: password,
        )
        .then(
          (result) => result.when(
            ok: (_) => state,
            err: (err) => AuthState.isFailure(
              authFailure: AuthFailure.registerFailure(message: err.message),
            ),
          ),
        );
  }

  Future<void> signOut() async {
    state = await authRepository.signOut().then(
          (result) => result.when(
            ok: (_) => state,
            err: (_) => const AuthState.isFailure(
              authFailure: AuthFailure.signOutFailure(),
            ),
          ),
        );
  }
}
