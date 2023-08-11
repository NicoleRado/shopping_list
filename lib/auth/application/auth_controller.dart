import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/auth_failure.dart';
import '../infrastructure/auth_repository.dart';
import 'auth_state.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) => AuthController(
          ref.read(authRepositoryProvider),
          ref.read(isAuthenticatedStreamProvider),
        ));

class AuthController extends StateNotifier<AuthState> {
  AuthController(this.authRepository, this.isAuthenticatedStream)
      : super(const AuthState.isUnauthenticated()) {
    authStateChanges = isAuthenticatedStream.listen(
      (user) {
        if (user == null) {
          state = const AuthState.isUnauthenticated();
        } else {
          print('------------------- ${user.uid} --------------------------');
          state = AuthState.isAuthenticated(userId: user.uid);
        }
      },
    );
  }

  final AuthRepository authRepository;
  final Stream<User?> isAuthenticatedStream;
  StreamSubscription? authStateChanges;

  @override
  void dispose() {
    authStateChanges?.cancel();
    super.dispose();
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = const AuthState.isLoading();

    final result = await authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    state = await result.when(
      ok: (_) => state,
      err: (_) => const AuthState.isFailure(
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
    state = await result.when(
      ok: (_) => state,
      err: (err) => AuthState.isFailure(
        authFailure: AuthFailure.registerFailure(message: err.message),
      ),
    );
  }

  Future<void> signOut() async {
    final result = await authRepository.signOut();
    state = result.when(
      ok: (_) => state,
      err: (_) => const AuthState.isFailure(
        authFailure: AuthFailure.signOutFailure(),
      ),
    );
  }
}
