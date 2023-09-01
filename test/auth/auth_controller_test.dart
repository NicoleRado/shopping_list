import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
import 'package:shopping_list/auth/application/auth_controller.dart';
import 'package:shopping_list/auth/application/auth_state.dart';
import 'package:shopping_list/auth/domain/auth_failure.dart';
import 'package:shopping_list/auth/infrastructure/auth_repository.dart';

import 'auth_controller_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  const email = 'test@email.com';
  const password = 'password';
  final authException = FirebaseAuthException(code: 'ERROR', message: 'Error.');

  late MockAuthRepository mockAuthRepository;
  late ProviderContainer providerContainer;
  late StreamController<bool> isAuthenticatedController;
  late AuthController authController;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    providerContainer = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWith((ref) => mockAuthRepository),
      ],
    );

    isAuthenticatedController = StreamController<bool>();
    when(mockAuthRepository.isAuthenticated()).thenAnswer(
      (_) => isAuthenticatedController.stream,
    );
    isAuthenticatedController.add(false);

    authController = providerContainer.read(authControllerProvider.notifier);
  });

  tearDown(() => isAuthenticatedController.close());

  group('authStateChanges', () {
    test(
        'Tests if authStateChanges set isAuthenticated state when isAuthenticated stream emits true',
        () async {
      expect(authController.state, const AuthState.isUnauthenticated());

      isAuthenticatedController.add(true);

      // Since the stream listener is asynchronous, after executing the
      // isAuthenticatedController.add() method, the expect() method would be
      // executed directly, even before the stream listener is executed. The
      // Future.delayed() method forces the event loop to process all pending
      // tasks in the queue before continuing the processing of the subsequent
      // code.
      await Future.delayed(Duration.zero);

      expect(authController.state, const AuthState.isAuthenticated());
    });

    test(
        'Tests if authStateChanges set isUnauthenticated state when isAuthenticated stream emits false',
        () async {
      expect(authController.state, const AuthState.isUnauthenticated());

      isAuthenticatedController.add(false);

      await Future.delayed(Duration.zero);

      expect(authController.state, const AuthState.isUnauthenticated());
    });
  });

  group('login', () {
    test('tests, if a correct sign in leads to a loading state', () async {
      expect(authController.state, const AuthState.isUnauthenticated());
      provideDummy<Result<Unit, FirebaseAuthException>>(const Ok(unit));

      when(mockAuthRepository.signInWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((_) => Future.value(const Ok(unit)));

      await authController.login(email: email, password: password);

      expect(authController.state, const AuthState.isLoading());
    });

    test('tests, if an authException leads to an failure state during sign in',
        () async {
      expect(authController.state, const AuthState.isUnauthenticated());
      provideDummy<Result<Unit, FirebaseAuthException>>(Err(authException));

      when(mockAuthRepository.signInWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((_) => Future.value(Err(authException)));

      await authController.login(email: email, password: password);

      expect(authController.state,
          const AuthState.isFailure(authFailure: AuthFailure.loginFailure()));
    });
  });

  group('register', () {
    test('tests, if a correct register leads to a loading state', () async {
      expect(authController.state, const AuthState.isUnauthenticated());
      provideDummy<Result<Unit, Exception>>(const Ok(unit));

      when(mockAuthRepository.registerWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((_) => Future.value(const Ok(unit)));

      await authController.register(email: email, password: password);

      expect(authController.state, const AuthState.isLoading());
    });

    test('tests, if an authException leads to an failure state during register',
        () async {
      expect(authController.state, const AuthState.isUnauthenticated());
      provideDummy<Result<Unit, Exception>>(Err(authException));

      when(mockAuthRepository.registerWithEmailAndPassword(
              email: email, password: password))
          .thenAnswer((_) => Future.value(Err(authException)));

      await authController.register(email: email, password: password);

      expect(
          authController.state,
          AuthState.isFailure(
              authFailure: AuthFailure.registerFailure(
                  message: authException.toString())));
    });
  });

  group('signOut', () {
    test('tests, if a correct signout leads to a loading state', () async {
      expect(authController.state, const AuthState.isUnauthenticated());

      isAuthenticatedController.add(true);
      Future.delayed(Duration.zero);
      expect(authController.state, const AuthState.isAuthenticated());

      provideDummy<Result<Unit, Exception>>(const Ok(unit));

      when(mockAuthRepository.signOut())
          .thenAnswer((_) => Future.value(const Ok(unit)));

      await authController.signOut();

      expect(authController.state, const AuthState.isLoading());
    });

    test('tests, if an authException leads to an failure state during signout',
        () async {
      provideDummy<Result<Unit, Exception>>(Err(authException));

      when(mockAuthRepository.signOut())
          .thenAnswer((_) => Future.value(Err(authException)));

      await authController.signOut();

      expect(
          authController.state,
          const AuthState.isFailure(
            authFailure: AuthFailure.signOutFailure(),
          ));
    });
  });
}
