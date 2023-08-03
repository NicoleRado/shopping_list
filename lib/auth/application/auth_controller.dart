import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_failure.dart';
import '../infrastructure/auth_repository.dart';
import 'auth_state.dart';

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
    (ref) => AuthController(ref.read(authRepositoryProvider)));

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.authRepository)
      : super(const AuthState.isUnauthenticated());

  final AuthRepository authRepository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.isLoading();

    final result = await authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    state = await result.whenAsync(
      ok: (_) async {
        final userData = await authRepository.getUserData();
        return userData.when(
          ok: (user) => AuthState.isAuthenticated(user: user),
          err: (_) => const AuthState.isFailure(
            authFailure: AuthFailure.userDataFailure(),
          ),
        );
      },
      err: (_) async => const AuthState.isFailure(
        authFailure: AuthFailure.loginFailure(),
      ),
    );
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    state = const AuthState.isLoading();

    final result = await authRepository.registerWithEmailAndPassword(
      email: email,
      password: password,
    );
    state = await result.whenAsync(
      ok: (_) async {
        final userData = await authRepository.getUserData();
        return userData.when(
          ok: (user) => AuthState.isAuthenticated(user: user),
          err: (_) => const AuthState.isFailure(
            authFailure: AuthFailure.userDataFailure(),
          ),
        );
      },
      err: (err) async => AuthState.isFailure(
        authFailure: AuthFailure.registerFailure(message: err.message),
      ),
    );
  }

  Future<void> signOut() async {
    final result = await authRepository.signOut();
    state = result.when(
      ok: (_) => const AuthState.isUnauthenticated(),
      err: (_) => const AuthState.isFailure(
        authFailure: AuthFailure.signOutFailure(),
      ),
    );
  }
}
