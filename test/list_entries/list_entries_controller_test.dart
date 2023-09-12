import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
import 'package:shopping_list/helpers/domain/constants.dart';
import 'package:shopping_list/list_entries/application/list_entries_controller.dart';
import 'package:shopping_list/list_entries/application/list_entries_state.dart';
import 'package:shopping_list/list_entries/domain/list_with_entries.dart';
import 'package:shopping_list/list_entries/domain/list_with_entries_failure.dart';
import 'package:shopping_list/list_entries/infrastructure/list_entries_repository.dart';

import 'list_entries_controller_test.mocks.dart';

@GenerateMocks([ListEntriesRepository])
void main() {
  const initialListId = 'ODWR3DwdPBbB9K8wDh0g';
  const initialListName = 'initialListName';
  final initialListWithEntries = {
    JsonParams.listId: initialListId,
    JsonParams.listName: initialListName,
    JsonParams.listEntries: [],
    JsonParams.completedEntries: [],
  };
  final initialListWithEntriesModel =
      ListWithEntries.fromJson(initialListWithEntries);

  const listId = 'tdndMRejiW4l8owo5SiCEBoRsUmC';
  const listName = 'listName';
  final listWithEntries = {
    JsonParams.listId: listId,
    JsonParams.listName: listName,
    JsonParams.listEntries: [],
    JsonParams.completedEntries: [],
  };
  final listWithEntriesModel = ListWithEntries.fromJson(listWithEntries);
  final firestoreException = FirebaseException(plugin: 'ERROR');

  late MockListEntriesRepository mockListEntriesRepository;
  late ProviderContainer container;
  late StreamController<Result<ListWithEntries, Exception>>
      listEntriesStreamController;
  late ListEntriesController listEntriesController;

  setUp(() {
    mockListEntriesRepository = MockListEntriesRepository();
    container = ProviderContainer();

    // A new provider is created without an autodisposed. This is important
    // because a Future.delayed() is used in the test for the execution of
    // the listen-function. The delayed is important to get the evaluation
    // of the stream in the listen-function. However, this causes the provider
    // to be disposed.
    final testListEntriesControllerProvider = StateNotifierProvider.family<
        ListEntriesController, ListEntriesState, String>(
      (ref, listId) => ListEntriesController(
        listId,
        mockListEntriesRepository,
      ),
    );

    listEntriesStreamController =
        StreamController<Result<ListWithEntries, Exception>>();
    when(mockListEntriesRepository.getEntries(listId: listId)).thenAnswer(
      (_) => listEntriesStreamController.stream,
    );
    listEntriesStreamController.add(Ok(initialListWithEntriesModel));

    listEntriesController =
        container.read(testListEntriesControllerProvider(listId).notifier);
  });

  tearDown(() => listEntriesStreamController.close());

  group('listChanges', () {
    test(
        'Tests if listChanges set ListEntriesState to isSuccess when getEntries emits listWithEntries',
        () async {
      expect(
        listEntriesController.state,
        ListEntriesState.isSuccess(
          listWithEntries: initialListWithEntriesModel,
        ),
      );

      listEntriesStreamController.add(Ok(listWithEntriesModel));

      await Future.delayed(Duration.zero);

      expect(
        listEntriesController.state,
        ListEntriesState.isSuccess(
          listWithEntries: listWithEntriesModel,
        ),
      );
    });

    test(
        'Tests if listChanges set ListEntriesState to isFailure when getEntries emits an Exception',
        () async {
      expect(
        listEntriesController.state,
        ListEntriesState.isSuccess(
          listWithEntries: initialListWithEntriesModel,
        ),
      );

      listEntriesStreamController.add(Err(firestoreException));

      await Future.delayed(Duration.zero);

      expect(
        listEntriesController.state,
        const ListEntriesState.isFailure(
          failure: ListWithEntriesFailure.noListEntriesAvailableFailure(),
        ),
      );
    });
  });

  group('toggleEntry', () {
    test('tests, if a correct toggle leads to a success state', () async {
      expect(
          listEntriesController.state,
          ListEntriesState.isSuccess(
              listWithEntries: initialListWithEntriesModel));
      provideDummy<Result<Unit, FirebaseException>>(const Ok(unit));

      when(mockListEntriesRepository.toggleEntry(
        listId: anyNamed('listId'),
        entryName: anyNamed('entryName'),
        removeListName: anyNamed('removeListName'),
        addListName: anyNamed('addListName'),
      )).thenAnswer((_) => Future.value(const Ok(unit)));

      await listEntriesController.toggleEntry(
        entryName: 'any',
        isCompleted: true,
      );

      expect(
        listEntriesController.state,
        ListEntriesState.isSuccess(
            listWithEntries: initialListWithEntriesModel),
      );
    });

    test('tests, if an Exception leads to an failure state during toggle',
        () async {
      expect(
          listEntriesController.state,
          ListEntriesState.isSuccess(
              listWithEntries: initialListWithEntriesModel));
      provideDummy<Result<Unit, FirebaseException>>(Err(firestoreException));

      when(mockListEntriesRepository.toggleEntry(
        listId: anyNamed('listId'),
        entryName: anyNamed('entryName'),
        removeListName: anyNamed('removeListName'),
        addListName: anyNamed('addListName'),
      )).thenAnswer((_) => Future.value(Err(firestoreException)));

      await listEntriesController.toggleEntry(
        entryName: 'any',
        isCompleted: true,
      );

      expect(
        listEntriesController.state,
        const ListEntriesState.isFailure(
          failure: ListWithEntriesFailure.toggleListEntryFailure(),
        ),
      );
    });
  });

  group('createEntry', () {
    test('tests, if a correct createEntry leads to a success state', () async {
      expect(
          listEntriesController.state,
          ListEntriesState.isSuccess(
              listWithEntries: initialListWithEntriesModel));
      provideDummy<Result<Unit, FirebaseException>>(const Ok(unit));

      when(mockListEntriesRepository.createEntry(
        entryName: anyNamed('entryName'),
        listId: anyNamed('listId'),
      )).thenAnswer((_) => Future.value(const Ok(unit)));

      await listEntriesController.createEntry(
        entryName: 'any',
      );

      expect(
        listEntriesController.state,
        ListEntriesState.isSuccess(
            listWithEntries: initialListWithEntriesModel),
      );
    });

    test(
        'tests, if an Exception leads to an failure state during Entry creation',
        () async {
      expect(
          listEntriesController.state,
          ListEntriesState.isSuccess(
              listWithEntries: initialListWithEntriesModel));
      provideDummy<Result<Unit, FirebaseException>>(Err(firestoreException));

      when(mockListEntriesRepository.createEntry(
        entryName: anyNamed('entryName'),
        listId: anyNamed('listId'),
      )).thenAnswer((_) => Future.value(Err(firestoreException)));

      await listEntriesController.createEntry(
        entryName: 'any',
      );

      expect(
        listEntriesController.state,
        const ListEntriesState.isFailure(
          failure: ListWithEntriesFailure.createListEntryFailure(),
        ),
      );
    });
  });

  group('deleteAllCompletedEntries', () {
    test(
        'tests, if a correct deleteAllCompletedEntries leads to a success state',
        () async {
      expect(
          listEntriesController.state,
          ListEntriesState.isSuccess(
              listWithEntries: initialListWithEntriesModel));
      provideDummy<Result<Unit, FirebaseException>>(const Ok(unit));

      when(mockListEntriesRepository.deleteAllCompletedEntries(
        listId: anyNamed('listId'),
      )).thenAnswer((_) => Future.value(const Ok(unit)));

      await listEntriesController.deleteAllCompletedEntries();

      expect(
        listEntriesController.state,
        ListEntriesState.isSuccess(
            listWithEntries: initialListWithEntriesModel),
      );
    });

    test(
        'tests, if an Exception leads to an failure state during deleteAllCompletedEntries',
        () async {
      expect(
          listEntriesController.state,
          ListEntriesState.isSuccess(
              listWithEntries: initialListWithEntriesModel));
      provideDummy<Result<Unit, FirebaseException>>(const Ok(unit));

      when(mockListEntriesRepository.deleteAllCompletedEntries(
        listId: anyNamed('listId'),
      )).thenAnswer((_) => Future.value(Err(firestoreException)));

      await listEntriesController.deleteAllCompletedEntries();

      expect(
        listEntriesController.state,
        const ListEntriesState.isFailure(
          failure: ListWithEntriesFailure.deleteAllCompletedEntriesFailure(),
        ),
      );
    });
  });
}
