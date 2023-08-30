import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

import '../../helpers/domain/constants.dart';
import '../domain/list_with_entries.dart';

final listEntriesRepositoryProvider =
    Provider<ListEntriesRepository>((ref) => ListEntriesRepository());

class ListEntriesRepository {
  ListEntriesRepository();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Result<ListWithEntries, FirebaseException>> getEntries({
    required String listId,
  }) {
    final listRef = FirebaseFirestore.instance
        .collection(JsonParams.listsCollection)
        .doc(listId);

    return listRef.snapshots().map(
          (snapShot) => Result.of(() {
            if (snapShot.data() != null) {
              return ListWithEntries.fromJson(snapShot.data()!);
            }
            throw Exception('List of Entries is null');
          }),
        );
  }

  Future<Result<Unit, FirebaseException>> toggleEntry({
    required String listId,
    required String entryName,
    required String removeListName,
    required String addListName,
  }) async {
    return Result.asyncOf(() async {
      final listRef =
          _firestore.collection(JsonParams.listsCollection).doc(listId);

      await listRef.update({
        removeListName: FieldValue.arrayRemove([entryName]),
      });
      await listRef.update({
        addListName: FieldValue.arrayUnion([entryName]),
      });
      return unit;
    });
  }

  Future<Result<Unit, FirebaseException>> createEntry({
    required String listId,
    required String entryName,
  }) async {
    return Result.asyncOf(() async {
      final listRef =
          _firestore.collection(JsonParams.listsCollection).doc(listId);

      await listRef.update({
        JsonParams.listEntries: FieldValue.arrayUnion([entryName]),
      });
      return unit;
    });
  }

  Future<Result<Unit, FirebaseException>> deleteAllCompletedEntries({
    required String listId,
  }) async {
    return Result.asyncOf(() async {
      final listRef =
          _firestore.collection(JsonParams.listsCollection).doc(listId);

      await listRef.update({
        JsonParams.completedEntries: [],
      });
      return unit;
    });
  }
}
