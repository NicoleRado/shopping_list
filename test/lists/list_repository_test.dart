import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/helpers/domain/constants.dart';
import 'package:shopping_list/list_entries/domain/list_with_entries.dart';
import 'package:shopping_list/lists/domain/list_data.dart';
import 'package:shopping_list/lists/domain/user.dart' as model;
import 'package:shopping_list/lists/infrastructure/list_repository.dart';

import 'list_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  DocumentReference,
  CollectionReference,
  DocumentSnapshot,
  User
])
void main() {
  const userId = '7HJv7vzbPc6EY7VxBx1MdSkp6gfv';
  const listId = '5PC6gsxNO3els2x1ZziU';
  const invitedListId = 'A6E8NwIFIKWaA5sPjX2Y';
  const listName = 'testList';
  const invitedListName = 'invitedTestList';
  const newListName = 'newListName';
  final listData = {
    JsonParams.listId: listId,
    JsonParams.listName: listName,
    JsonParams.listEntries: ['openEntryName'],
    JsonParams.completedEntries: ['completedEntryName'],
  };
  final invitedListData = {
    JsonParams.listId: invitedListId,
    JsonParams.listName: invitedListName,
    JsonParams.listEntries: ['openEntryName'],
    JsonParams.completedEntries: ['completedEntryName'],
  };
  final listDataModel = ListData.fromJson(listData);

  ///TODO: is needed for the exitList test
  // final invitedListDataModel = ListData.fromJson(invitedListData);
  final userData = {
    JsonParams.userId: userId,
    JsonParams.ownLists: [listData],
    JsonParams.invitedLists: [invitedListData],
    JsonParams.isPaidAccount: false,
  };
  final userDataModel = model.User.fromJson(userData);
  final firestoreException = FirebaseException(plugin: 'ERROR');

  late MockFirebaseAuth mockitoAuth;
  late FakeFirebaseFirestore fakeFirestore;
  late MockFirebaseFirestore mockitoFirestore;

  late User authUser;
  late CollectionReference<Map<String, dynamic>> fakeListCollectionReference;
  late CollectionReference<Map<String, dynamic>> fakeUserCollectionReference;
  late MockDocumentReference<Map<String, dynamic>> mockitoDocumentReference;
  late MockCollectionReference<Map<String, dynamic>> mockitoCollectionReference;

  late MockDocumentSnapshot<Map<String, dynamic>> mockitoDocumentSnapshot;

  late ListRepository mockitoListRepository;
  late ListRepository fakeListRepository;

  setUp(() {
    mockitoAuth = MockFirebaseAuth();
    mockitoFirestore = MockFirebaseFirestore();
    fakeFirestore = FakeFirebaseFirestore();

    authUser = MockUser();
    fakeListCollectionReference =
        fakeFirestore.collection(JsonParams.listsCollection);
    fakeUserCollectionReference =
        fakeFirestore.collection(JsonParams.usersCollection);
    mockitoDocumentReference = MockDocumentReference();
    mockitoCollectionReference = MockCollectionReference();

    mockitoDocumentSnapshot = MockDocumentSnapshot();

    mockitoListRepository =
        ListRepository(auth: mockitoAuth, firestore: mockitoFirestore);
    fakeListRepository =
        ListRepository(auth: mockitoAuth, firestore: fakeFirestore);

    fakeListCollectionReference.doc(listId).set(listData);
    fakeUserCollectionReference.doc(userId).set(userData);

    when(mockitoAuth.currentUser).thenReturn(authUser);
    when(authUser.uid).thenReturn(userId);
    when(mockitoFirestore.collection(any))
        .thenReturn(mockitoCollectionReference);
    when(mockitoCollectionReference.doc(any))
        .thenReturn(mockitoDocumentReference);

    when(mockitoDocumentReference.snapshots())
        .thenAnswer((_) => Stream.value(mockitoDocumentSnapshot));
  });

  group('getUserData', () {
    test('Tests if getUserData returns stream with User data', () async {
      when(mockitoDocumentSnapshot.data()).thenReturn(userData);

      final resultStream = mockitoListRepository.getUserData();

      final result = await resultStream.toList();
      final user = result[0].when(
        ok: (user) => user,
        err: (_) => null,
      );
      expect(result[0].isOk(), true);
      expect(user, equals(userDataModel));
    });

    test('Tests if getUserData returns stream with Error, when no user exists',
        () async {
      when(mockitoDocumentSnapshot.data()).thenReturn(null);

      final resultStream = mockitoListRepository.getUserData();

      final result = await resultStream.toList();
      final user = result[0].when(
        ok: (user) => user,
        err: (_) => null,
      );

      expect(result[0].isErr(), true);
      expect(user, equals(null));
    });
  });

  group('createList', () {
    test('Tests if a user can successfully create a List', () async {
      final result = await fakeListRepository.createList(
        user: userDataModel,
        listName: newListName,
      );

      expect(result.isOk(), true);
    });

    test(
        'Tests if a user can successfully create a List and add it to users own lists',
        () async {
      final docSnapshotBeforeCreateList =
          await fakeUserCollectionReference.doc(userId).get();
      final userDataBeforeCreateList =
          model.User.fromJson(docSnapshotBeforeCreateList.data()!);

      expect(userDataBeforeCreateList.ownLists, contains(listDataModel));

      await fakeListRepository.createList(
        user: userDataModel,
        listName: newListName,
      );
      final docSnapshotAfterCreateList =
          await fakeUserCollectionReference.doc(userId).get();
      final userDataAfterCreateList =
          model.User.fromJson(docSnapshotAfterCreateList.data()!);

      expect(
        userDataAfterCreateList.ownLists
            .any((listData) => listData.name == newListName),
        true,
      );
    });

    test(
        'Tests if a user can successfully create a List and add it to lists collection',
        () async {
      final snapshotBeforeCreateList = await fakeListCollectionReference.get();
      expect(snapshotBeforeCreateList.docs, hasLength(1));

      await fakeListRepository.createList(
        user: userDataModel,
        listName: newListName,
      );
      final snapshotAfterCreateList = await fakeListCollectionReference.get();
      final listOfShoppingLists = snapshotAfterCreateList.docs
          .map((list) => ListWithEntries.fromJson(list.data()))
          .toList();

      expect(snapshotAfterCreateList.docs, hasLength(2));
      expect(listOfShoppingLists.any((list) => list.name == newListName), true);
    });

    test('Tests if Error is thrown, when list is added to users own lists',
        () async {
      when(mockitoDocumentReference.id).thenAnswer((_) => listId);
      when(mockitoDocumentReference.update(any)).thenThrow(firestoreException);

      final result = await mockitoListRepository.createList(
        user: userDataModel,
        listName: newListName,
      );

      expect(result.isErr(), true);
    });

    test('Tests if Error is thrown, when list is added to lists collection',
        () async {
      when(mockitoDocumentReference.id).thenAnswer((_) => listId);
      when(mockitoDocumentReference.set(any)).thenThrow(firestoreException);

      final result = await mockitoListRepository.createList(
        user: userDataModel,
        listName: newListName,
      );

      expect(result.isErr(), true);
    });
  });

  group('joinList', () {
    test('Tests if a user can successfully join a list', () async {
      final result = await fakeListRepository.joinList(
        userId: userId,
        listId: listId,
      );

      expect(result.isOk(), true);
    });

    test('Tests if a user can successfully add a list to users invited lists',
        () async {
      final docSnapshotBeforeJoinList =
          await fakeUserCollectionReference.doc(userId).get();
      final userDataBeforeJoinList =
          model.User.fromJson(docSnapshotBeforeJoinList.data()!);

      expect(userDataBeforeJoinList.invitedLists, hasLength(1));

      await fakeListRepository.joinList(
        userId: userId,
        listId: listId,
      );
      final docSnapshotAfterJoinList =
          await fakeUserCollectionReference.doc(userId).get();
      final userDataAfterJoinList =
          model.User.fromJson(docSnapshotAfterJoinList.data()!);

      expect(userDataAfterJoinList.invitedLists, hasLength(2));
      expect(
        userDataAfterJoinList.invitedLists
            .any((listData) => listData.id == listId),
        true,
      );
    });

    test('Tests if Error is thrown, when list is added to invitedLists',
        () async {
      when(mockitoDocumentReference.get())
          .thenAnswer((_) async => mockitoDocumentSnapshot);
      when(mockitoDocumentSnapshot.data()).thenReturn(listData);
      when(mockitoDocumentReference.update(any)).thenThrow(firestoreException);

      final result = await mockitoListRepository.joinList(
        userId: userId,
        listId: listId,
      );

      expect(result.isErr(), true);
    });

    test('Tests if Error is thrown, when list dose not exists', () async {
      when(mockitoDocumentReference.get())
          .thenAnswer((_) async => mockitoDocumentSnapshot);
      when(mockitoDocumentSnapshot.data()).thenReturn(null);

      final result = await mockitoListRepository.joinList(
        userId: userId,
        listId: listId,
      );

      expect(result.isErr(), true);
    });
  });

  group('deleteList', () {
    test('Tests if a user can successfully delete a list', () async {
      final result = await fakeListRepository.deleteList(listId: listId);

      expect(result.isOk(), true);
    });

    test('Tests if a user can successfully delete a list from lists collection',
        () async {
      final snapshotBeforeDeleteList = await fakeListCollectionReference.get();
      expect(snapshotBeforeDeleteList.docs, hasLength(1));

      await fakeListRepository.deleteList(listId: listId);

      final snapshotAfterDeleteList = await fakeListCollectionReference.get();
      expect(snapshotAfterDeleteList.docs, hasLength(0));
    });

    test('Tests if Error is thrown, when list can not be deleted', () async {
      when(mockitoDocumentReference.delete()).thenThrow(firestoreException);

      final result = await mockitoListRepository.deleteList(listId: listId);

      expect(result.isErr(), true);
    });
  });

  group('exitList', () {
    test('Tests if a user can successfully exit a list', () async {
      final result = await fakeListRepository.exitList(
        userId: userId,
        listData: listDataModel,
      );

      expect(result.isOk(), true);
    });

    ///TODO: There might be a problem with FieldValue.arrayRemove() in
    ///fake_cloud_firestore package for objects, so that invitedListDataModel
    ///won't be remove from fake firestore. This was already fixed in version
    ///1.3.2 but seems to occur again.
    // test(
    //     'Tests if a user can successfully remove a list from users invited lists',
    //     () async {
    //   final docSnapshotBeforeExitList =
    //       await fakeUserCollectionReference.doc(userId).get();
    //   final userDataBeforeExitList =
    //       model.User.fromJson(docSnapshotBeforeExitList.data()!);
    //
    //   expect(userDataBeforeExitList.invitedLists, hasLength(1));
    //
    //   await fakeListRepository.exitList(
    //     userId: userId,
    //     listData: invitedListDataModel,
    //   );
    //   final docSnapshotAfterExitList =
    //       await fakeUserCollectionReference.doc(userId).get();
    //   final userDataAfterExitList =
    //       model.User.fromJson(docSnapshotAfterExitList.data()!);
    //
    //   print(invitedListDataModel);
    //   print(userDataAfterExitList.invitedLists.firstOrNull);
    //
    //   expect(userDataAfterExitList.invitedLists, isEmpty);
    //   expect(
    //     userDataAfterExitList.invitedLists
    //         .any((listData) => listData.id == invitedListId),
    //     false,
    //   );
    // });

    test('Tests if Error is thrown, when user can not exit list', () async {
      when(mockitoDocumentReference.update(any)).thenThrow(firestoreException);

      final result = await mockitoListRepository.exitList(
        userId: userId,
        listData: listDataModel,
      );

      expect(result.isErr(), true);
    });
  });

  group('renameList', () {
    test('Tests if a user can successfully rename a list', () async {
      final result = await fakeListRepository.renameList(
        oldListId: listId,
        newName: invitedListName,
      );

      expect(result.isOk(), true);
    });

    test('Tests if a user can successfully rename a list in lists collection',
        () async {
      final docSnapshotBeforeRenameList =
          await fakeListCollectionReference.doc(listId).get();
      final listDataBeforeRenameList =
          ListWithEntries.fromJson(docSnapshotBeforeRenameList.data()!);

      expect(listDataBeforeRenameList.name, equals(listName));

      await fakeListRepository.renameList(
        oldListId: listId,
        newName: invitedListName,
      );
      final docSnapshotAfterRenameList =
          await fakeListCollectionReference.doc(listId).get();
      final listDataAfterRenameList =
          ListWithEntries.fromJson(docSnapshotAfterRenameList.data()!);

      expect(listDataAfterRenameList.name, equals(invitedListName));
    });

    test('Tests if Error is thrown, when user can not rename list', () async {
      when(mockitoDocumentReference.update(any)).thenThrow(firestoreException);

      final result = await mockitoListRepository.renameList(
        oldListId: listId,
        newName: invitedListName,
      );

      expect(result.isErr(), true);
    });
  });
}
