import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/auth/infrastructure/auth_repository.dart';
import 'package:shopping_list/helpers/domain/constants.dart';

import 'auth_repository_test.mocks.dart' as mockito;

@GenerateMocks([FirebaseAuth, FirebaseFirestore])
void main() {
  const email = 'test@email.com';
  const password = 'password';
  final authException = FirebaseAuthException(code: 'ERROR', message: 'Error.');
  final firestoreException = FirebaseException(plugin: 'ERROR');
  final user = MockUser();

  late MockFirebaseAuth fakeAuth;
  late mockito.MockFirebaseAuth mockitoAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late mockito.MockFirebaseFirestore mockitoFirestore;

  late AuthRepository authRepository;
  late AuthRepository mockitoAuthRepositoryWithFakeAuth;
  late AuthRepository mockitoAuthRepositoryWithFakeFirestore;

  setUp(() {
    fakeAuth = MockFirebaseAuth();
    mockitoAuth = mockito.MockFirebaseAuth();
    mockitoFirestore = mockito.MockFirebaseFirestore();
    fakeFirestore = FakeFirebaseFirestore();

    authRepository = AuthRepository(auth: fakeAuth, firestore: fakeFirestore);
    mockitoAuthRepositoryWithFakeAuth =
        AuthRepository(auth: mockitoAuth, firestore: fakeFirestore);
    mockitoAuthRepositoryWithFakeFirestore =
        AuthRepository(auth: fakeAuth, firestore: mockitoFirestore);
  });

  group('isAuthenticated', () {
    test('Tests if stream map returns true when user is authenticated',
        () async {
      when(mockitoAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(user));

      expect(mockitoAuthRepositoryWithFakeAuth.isAuthenticated(), emits(true));
    });

    test('Tests if stream map returns false when user is not authenticated',
        () async {
      when(mockitoAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(null));

      expect(mockitoAuthRepositoryWithFakeAuth.isAuthenticated(), emits(false));
    });
  });

  group('signInWithEmailAndPassword', () {
    test(
        'Tests if a user can successfully authenticated with email and password',
        () async {
      expect(fakeAuth.currentUser, equals(null));

      final result = await authRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isOk(), true);
      expect(fakeAuth.currentUser, isNotNull);
    });

    test(
        'Tests if Error is thrown, when signInWithEmailAndPassword returns Error',
        () async {
      when(mockitoAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(authException);

      final result =
          await mockitoAuthRepositoryWithFakeAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isErr(), true);
    });
  });

  group('registerWithEmailAndPassword', () {
    test('Tests if a user can successfully register', () async {
      final result = await authRepository.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isOk(), true);
    });

    test('Tests if a user was successfully authenticated after register',
        () async {
      expect(fakeAuth.currentUser, equals(null));

      final result = await authRepository.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isOk(), true);
      expect(fakeAuth.currentUser, isNotNull);
    });

    test('Tests if a user has an entry in users collection after register',
        () async {
      final snapshotBeforeRegister =
          await fakeFirestore.collection(JsonParams.usersCollection).get();

      expect(snapshotBeforeRegister.docs, hasLength(0));

      final result = await authRepository.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isOk(), true);

      final snapshotAfterRegister =
          await fakeFirestore.collection(JsonParams.usersCollection).get();
      expect(snapshotAfterRegister.docs, hasLength(1));
    });

    test(
        'Tests if Error is thrown, when createUserWithEmailAndPassword returns Error',
        () async {
      when(mockitoAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .thenThrow(authException);

      final result =
          await mockitoAuthRepositoryWithFakeAuth.registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isErr(), true);
    });

    test('Tests if Error is thrown, if no user can be set in firestore',
        () async {
      when(mockitoFirestore.collection(any)).thenThrow(firestoreException);

      final result = await mockitoAuthRepositoryWithFakeFirestore
          .registerWithEmailAndPassword(
        email: email,
        password: password,
      );

      expect(result.isErr(), true);
    });
  });

  group('signOut', () {
    test('Tests if a user can successfully signOut', () async {
      await fakeAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      expect(fakeAuth.currentUser, isNotNull);

      final result = await authRepository.signOut();

      expect(result.isOk(), true);
      expect(fakeAuth.currentUser, equals(null));
    });

    test('Tests if Error is thrown, when user can not sign out', () async {
      when(mockitoAuth.signOut()).thenThrow(authException);

      final result = await mockitoAuthRepositoryWithFakeAuth.signOut();

      expect(result.isErr(), true);
    });
  });
}
