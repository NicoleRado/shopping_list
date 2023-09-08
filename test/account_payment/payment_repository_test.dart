import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/account_payment/infrastructure/payment_repository.dart';
import 'package:shopping_list/helpers/domain/constants.dart';
import 'package:shopping_list/lists/domain/user.dart' as model;

import 'payment_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  FirebaseAuth,
  User,
  DocumentReference,
  CollectionReference
])
void main() {
  const userId = '7HJv7vzbPc6EY7VxBx1MdSkp6gfv';
  final userData = {
    JsonParams.userId: userId,
    JsonParams.ownLists: [],
    JsonParams.invitedLists: [],
    JsonParams.isPaidAccount: false,
  };
  final firestoreException = FirebaseException(plugin: 'ERROR');

  late User mockUser;

  late MockFirebaseAuth mockFirebaseAuth;
  late MockFirebaseFirestore mockFirestore;
  late FakeFirebaseFirestore fakeFirestore;

  late CollectionReference<Map<String, dynamic>> fakeUserCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockDocumentReference;
  late MockCollectionReference<Map<String, dynamic>> mockCollectionReference;

  late PaymentRepository mockPaymentRepository;
  late PaymentRepository fakePaymentRepository;

  setUp(() {
    mockUser = MockUser();

    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = MockFirebaseFirestore();
    fakeFirestore = FakeFirebaseFirestore();

    fakeUserCollectionReference =
        fakeFirestore.collection(JsonParams.usersCollection);
    mockDocumentReference = MockDocumentReference();
    mockCollectionReference = MockCollectionReference();

    mockPaymentRepository = PaymentRepository(
      auth: mockFirebaseAuth,
      firestore: mockFirestore,
    );
    fakePaymentRepository = PaymentRepository(
      auth: mockFirebaseAuth,
      firestore: fakeFirestore,
    );

    fakeUserCollectionReference.doc(userId).set(userData);

    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    when(mockUser.uid).thenReturn(userId);
    when(mockFirestore.collection(any)).thenReturn(mockCollectionReference);
    when(mockCollectionReference.doc(any)).thenReturn(mockDocumentReference);
  });

  group('updatePaidFlag', () {
    test('Tests if a user can successfully updatePaidFlag', () async {
      final result = await fakePaymentRepository.updatePaidFlag();

      expect(result.isOk(), true);
    });

    test('Tests if a user can successfully update the paid flag in firestore',
        () async {
      final snapshotBeforeUpdate =
          await fakeUserCollectionReference.doc(userId).get();
      final userModelBeforeUpdate =
          model.User.fromJson(snapshotBeforeUpdate.data()!);
      expect(userModelBeforeUpdate.isPaidAccount, equals(false));

      await fakePaymentRepository.updatePaidFlag();

      final snapshotAfterUpdate =
          await fakeUserCollectionReference.doc(userId).get();
      final userModelAfterUpdate =
          model.User.fromJson(snapshotAfterUpdate.data()!);
      expect(userModelAfterUpdate.isPaidAccount, equals(true));
    });

    test('Tests if Error is thrown, when paid flag can not be updated',
        () async {
      when(mockDocumentReference.update(any)).thenThrow(firestoreException);

      final result = await mockPaymentRepository.updatePaidFlag();

      expect(result.isErr(), true);
    });
  });
}
