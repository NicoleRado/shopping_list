import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
import 'package:shopping_list/helpers/domain/constants.dart';
import 'package:shopping_list/lists/application/list_controller.dart';
import 'package:shopping_list/lists/application/list_state.dart';
import 'package:shopping_list/lists/domain/list_data.dart';
import 'package:shopping_list/lists/domain/list_failure.dart';
import 'package:shopping_list/lists/domain/user.dart';
import 'package:shopping_list/lists/infrastructure/list_repository.dart';

import 'list_controller_test.mocks.dart';

@GenerateMocks([ListRepository])
void main() {
  const initialUserId = '7HJv7vzbPc6EY7VxBx1MdSkp6gfv';
  final initialUserData = {
    JsonParams.userId: initialUserId,
    JsonParams.ownLists: [],
    JsonParams.invitedLists: [],
    JsonParams.isPaidAccount: false,
  };
  final initialUserDataModel = User.fromJson(initialUserData);
  const userId = 'tdndMRejiW4l8owo5SiCEBoRsUmC';
  final userData = {
    JsonParams.userId: userId,
    JsonParams.ownLists: [],
    JsonParams.invitedLists: [],
    JsonParams.isPaidAccount: false,
  };
  final userDataModel = User.fromJson(userData);
  final listData = {
    JsonParams.listId: 'any',
    JsonParams.listName: 'any',
  };
  final listDataModel = ListData.fromJson(listData);
  final firestoreException = FirebaseException(plugin: 'ERROR');

  late MockListRepository mockListRepository;
  late ProviderContainer container;
  late StreamController<Result<User, Exception>> listStreamController;
  late ListController listController;

  setUp(() {
    mockListRepository = MockListRepository();
    container = ProviderContainer();

    final testListControllerProvider =
        StateNotifierProvider<ListController, ListState>(
            (ref) => ListController(mockListRepository));

    listStreamController = StreamController<Result<User, Exception>>();
    when(mockListRepository.getUserData())
        .thenAnswer((_) => listStreamController.stream);
    listStreamController.add(Ok(initialUserDataModel));

    listController = container.read(testListControllerProvider.notifier);
  });

  tearDown(() => listStreamController.close());

  group('listChanges', () {
    test(
        'Tests if listChanges set ListEntriesState to isSuccess when getEntries emits listWithEntries',
        () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );

      listStreamController.add(Ok(userDataModel));

      await Future.delayed(Duration.zero);

      expect(
        listController.state,
        ListState.isSuccess(
          user: userDataModel,
        ),
      );
    });

    test(
        'Tests if listChanges set ListEntriesState to isFailure when getEntries emits an Exception',
        () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );

      listStreamController.add(Err(firestoreException));

      await Future.delayed(Duration.zero);

      expect(
        listController.state,
        const ListState.isFailure(
          failure: ListFailure.userDataFailure(),
        ),
      );
    });
  });

  group('createList', () {
    test('tests, if a correct create List leads to a success state', () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
      provideDummy<Result<Unit, FirebaseException>>(const Ok(unit));

      when(mockListRepository.createList(
        user: anyNamed('user'),
        listName: anyNamed('listName'),
      )).thenAnswer((_) => Future.value(const Ok(unit)));

      await listController.createList(
        user: userDataModel,
        listName: 'any',
      );

      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
    });

    test(
        'tests, if an Exception leads to an failure state during List creation',
        () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
      provideDummy<Result<Unit, FirebaseException>>(Err(firestoreException));

      when(mockListRepository.createList(
        user: anyNamed('user'),
        listName: anyNamed('listName'),
      )).thenAnswer((_) => Future.value(Err(firestoreException)));

      await listController.createList(
        user: userDataModel,
        listName: 'any',
      );

      expect(
        listController.state,
        const ListState.isFailure(
          failure: ListFailure.createListFailure(),
        ),
      );
    });
  });

  group('joinList', () {
    test('tests, if a correct List join leads to a success state', () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
      provideDummy<Result<Unit, Exception>>(const Ok(unit));

      when(mockListRepository.joinList(
        userId: anyNamed('userId'),
        listId: anyNamed('listId'),
      )).thenAnswer((_) => Future.value(const Ok(unit)));

      await listController.joinList(
        userId: userId,
        listId: 'any',
      );

      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
    });

    test(
        'tests, if an Exception leads to an failure state during joining a List',
        () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
      provideDummy<Result<Unit, Exception>>(Err(firestoreException));

      when(mockListRepository.joinList(
        userId: anyNamed('userId'),
        listId: anyNamed('listId'),
      )).thenAnswer((_) => Future.value(Err(firestoreException)));

      await listController.joinList(
        userId: userId,
        listId: 'any',
      );

      expect(
        listController.state,
        const ListState.isFailure(
          failure: ListFailure.joinListFailure(),
        ),
      );
    });
  });

  group('deleteList', () {
    test('tests, if a correct List deletion leads to a success state',
        () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
      provideDummy<Result<Unit, FirebaseException>>(const Ok(unit));

      when(mockListRepository.deleteList(
        listId: anyNamed('listId'),
      )).thenAnswer((_) => Future.value(const Ok(unit)));

      await listController.deleteList(
        listId: 'any',
      );

      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
    });

    test(
        'tests, if an Exception leads to an failure state during deleting a List',
        () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
      provideDummy<Result<Unit, FirebaseException>>(Err(firestoreException));

      when(mockListRepository.deleteList(
        listId: anyNamed('listId'),
      )).thenAnswer((_) => Future.value(Err(firestoreException)));

      await listController.deleteList(
        listId: 'any',
      );

      expect(
        listController.state,
        const ListState.isFailure(
          failure: ListFailure.deleteListFailure(),
        ),
      );
    });
  });

  group('exitList', () {
    test('tests, if a correct exitList leads to a success state', () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
      provideDummy<Result<Unit, FirebaseException>>(const Ok(unit));

      when(mockListRepository.exitList(
        listData: anyNamed('listData'),
        userId: anyNamed('userId'),
      )).thenAnswer((_) => Future.value(const Ok(unit)));

      await listController.exitList(
        listData: listDataModel,
        userId: 'any',
      );

      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
    });

    test('tests, if an Exception leads to an failure state during exitList',
        () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
      provideDummy<Result<Unit, FirebaseException>>(Err(firestoreException));

      when(mockListRepository.exitList(
        listData: anyNamed('listData'),
        userId: anyNamed('userId'),
      )).thenAnswer((_) => Future.value(Err(firestoreException)));

      await listController.exitList(
        listData: listDataModel,
        userId: 'any',
      );

      expect(
        listController.state,
        const ListState.isFailure(
          failure: ListFailure.exitListFailure(),
        ),
      );
    });
  });

  group('renameList', () {
    test('tests, if a correct renameList leads to a success state', () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
      provideDummy<Result<Unit, FirebaseException>>(const Ok(unit));

      when(mockListRepository.renameList(
        oldListId: anyNamed('oldListId'),
        newName: anyNamed('newName'),
      )).thenAnswer((_) => Future.value(const Ok(unit)));

      await listController.renameList(
        oldListId: 'any',
        newName: 'any',
      );

      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
    });

    test('tests, if an Exception leads to an failure state during renameList',
        () async {
      expect(
        listController.state,
        ListState.isSuccess(
          user: initialUserDataModel,
        ),
      );
      provideDummy<Result<Unit, FirebaseException>>(Err(firestoreException));

      when(mockListRepository.renameList(
        oldListId: anyNamed('oldListId'),
        newName: anyNamed('newName'),
      )).thenAnswer((_) => Future.value(Err(firestoreException)));

      await listController.renameList(
        oldListId: 'any',
        newName: 'any',
      );

      expect(
        listController.state,
        const ListState.isFailure(
          failure: ListFailure.renameListFailure(),
        ),
      );
    });
  });
}
