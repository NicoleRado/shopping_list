import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shopping_list/helpers/domain/constants.dart';
import 'package:shopping_list/list_entries/domain/list_with_entries.dart';
import 'package:shopping_list/list_entries/infrastructure/list_entries_repository.dart';

import 'list_entries_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  DocumentReference,
  CollectionReference,
  DocumentSnapshot
])
void main() {
  const listId = 'tdndMRejiW4l8owo5SiCEBoRsUmC';
  const openEntryName = 'openEntry';
  const completedEntryName = 'completedEntryName';
  const newEntryName = 'newEntryName';
  final listData = {
    JsonParams.listId: listId,
    JsonParams.listName: 'testList',
    JsonParams.listEntries: [openEntryName],
    JsonParams.completedEntries: [completedEntryName],
  };
  final listDataModel = ListWithEntries.fromJson(listData);
  final firestoreException = FirebaseException(plugin: 'ERROR');

  late MockFirebaseFirestore mockitoFirestore;
  late FakeFirebaseFirestore fakeFirestore;

  late CollectionReference<Map<String, dynamic>> listCollectionRef;
  late MockDocumentReference<Map<String, dynamic>> mockitoDocumentReference;
  late MockCollectionReference<Map<String, dynamic>> mockitoCollectionReference;

  late MockDocumentSnapshot<Map<String, dynamic>> mockitoDocumentSnapshot;

  late ListEntriesRepository mockitoListEntriesRepository;
  late ListEntriesRepository fakeListEntriesRepository;

  setUp(() {
    mockitoFirestore = MockFirebaseFirestore();
    fakeFirestore = FakeFirebaseFirestore();

    listCollectionRef = fakeFirestore.collection(JsonParams.listsCollection);
    mockitoDocumentReference = MockDocumentReference();
    mockitoCollectionReference = MockCollectionReference();

    mockitoDocumentSnapshot = MockDocumentSnapshot();

    mockitoListEntriesRepository =
        ListEntriesRepository(firestore: mockitoFirestore);
    fakeListEntriesRepository = ListEntriesRepository(firestore: fakeFirestore);

    listCollectionRef.doc(listId).set(listData);

    when(mockitoFirestore.collection(any))
        .thenReturn(mockitoCollectionReference);
    when(mockitoCollectionReference.doc(any))
        .thenReturn(mockitoDocumentReference);

    when(mockitoDocumentReference.snapshots())
        .thenAnswer((_) => Stream.value(mockitoDocumentSnapshot));
  });

  group('getEntries', () {
    test('Tests if getEntries returns stream with List with Entries', () async {
      when(mockitoDocumentSnapshot.data()).thenReturn(listData);

      final resultStream =
          mockitoListEntriesRepository.getEntries(listId: listId);

      final result = await resultStream.toList();
      final listWithEntries = result[0].when(
        ok: (list) => list,
        err: (_) => null,
      );
      expect(result[0].isOk(), true);
      expect(listWithEntries, equals(listDataModel));
    });

    test('Tests if getEntries returns stream with Error, when no list exists',
        () async {
      when(mockitoDocumentSnapshot.data()).thenReturn(null);

      final resultStream =
          mockitoListEntriesRepository.getEntries(listId: listId);

      final result = await resultStream.toList();
      final listWithEntries = result[0].when(
        ok: (list) => list,
        err: (_) => null,
      );

      expect(result[0].isErr(), true);
      expect(listWithEntries, equals(null));
    });
  });

  group('toggleEntry', () {
    test('Tests if a user can successfully completed an Entry', () async {
      final result = await fakeListEntriesRepository.toggleEntry(
        listId: listId,
        entryName: openEntryName,
        removeListName: JsonParams.listEntries,
        addListName: JsonParams.completedEntries,
      );
      final doc = await listCollectionRef.doc(listId).get();
      final data = doc.data()!;
      expect(result.isOk(), true);

      expect(data[JsonParams.listEntries], []);
      expect(data[JsonParams.completedEntries],
          [completedEntryName, openEntryName]);
    });

    test('Tests if a user can successfully open an Entry again', () async {
      final result = await fakeListEntriesRepository.toggleEntry(
        listId: listId,
        entryName: completedEntryName,
        removeListName: JsonParams.completedEntries,
        addListName: JsonParams.listEntries,
      );
      final doc = await listCollectionRef.doc(listId).get();
      final data = doc.data()!;
      expect(result.isOk(), true);
      expect(data[JsonParams.completedEntries], []);
      expect(
        data[JsonParams.listEntries],
        [openEntryName, completedEntryName],
      );
    });

    test('Tests if Error is thrown, when update returns Error', () async {
      when(mockitoDocumentReference.update(any)).thenThrow(firestoreException);

      final result = await mockitoListEntriesRepository.toggleEntry(
        listId: listId,
        entryName: openEntryName,
        removeListName: JsonParams.listEntries,
        addListName: JsonParams.completedEntries,
      );

      expect(result.isErr(), true);
    });
  });

  group('createEntry', () {
    test('Tests if a user can successfully create an Entry', () async {
      final result = await fakeListEntriesRepository.createEntry(
        listId: listId,
        entryName: newEntryName,
      );
      final doc = await listCollectionRef.doc(listId).get();
      final data = doc.data()!;

      expect(result.isOk(), true);
      expect(data[JsonParams.listEntries], [openEntryName, newEntryName]);
      expect(data[JsonParams.completedEntries], [completedEntryName]);
    });

    test('Tests if Error is thrown, when update returns Error', () async {
      when(mockitoDocumentReference.update(any)).thenThrow(firestoreException);

      final result = await mockitoListEntriesRepository.createEntry(
        listId: listId,
        entryName: newEntryName,
      );

      expect(result.isErr(), true);
    });
  });

  group('deleteAllCompletedEntries', () {
    test('Tests if a user can successfully delete all completed Entries',
        () async {
      final result = await fakeListEntriesRepository.deleteAllCompletedEntries(
        listId: listId,
      );
      final doc = await listCollectionRef.doc(listId).get();
      final data = doc.data()!;

      expect(result.isOk(), true);
      expect(data[JsonParams.listEntries], [openEntryName]);
      expect(data[JsonParams.completedEntries], []);
    });

    test('Tests if Error is thrown, when update returns Error', () async {
      when(mockitoDocumentReference.update(any)).thenThrow(firestoreException);

      final result =
          await mockitoListEntriesRepository.deleteAllCompletedEntries(
        listId: listId,
      );

      expect(result.isErr(), true);
    });
  });
}
