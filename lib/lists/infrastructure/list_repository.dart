import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

import '../domain/list_data.dart';
import '../domain/user.dart' as model;

final listStreamProvider =
    Provider.autoDispose<Stream<DocumentSnapshot<Map<String, dynamic>>>>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  return FirebaseFirestore.instance.collection('users').doc(userId).snapshots();
});

final listRepositoryProvider = Provider<ListRepository>((ref) {
  return ListRepository();
});

class ListRepository {
  ListRepository();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result<Unit, FirebaseException>> createList({
    required model.User user,
    required String listName,
  }) async {
    return Result.asyncOf(
      () async {
        final listRef = _firestore.collection('lists').doc();
        final ownList = [
          ...user.ownLists,
          ListData(id: listRef.id, name: listName)
        ];
        final listData = {
          'id': listRef.id,
          'name': listName,
          'listEntries': []
        };

        listRef.set(listData);

        await _firestore
            .collection('users')
            .doc(user.uid)
            .update({'ownLists': ownList.map((listData) => listData.toJson())});
        return unit;
      },
    );
  }

  Future<Result<Unit, FirebaseException>> joinList({
    required model.User user,
    required String listId,
  }) async {
    return Result.asyncOf(
      () async {
        final listSnapshot =
            await _firestore.collection('lists').doc(listId).get();

        if (listSnapshot.data() == null) {
          throw Exception('List dose not exists!');
        }
        final listData = ListData.fromJson(listSnapshot.data()!);
        final invitedLists = [
          ...user.invitedLists,
          listData,
        ];

        await _firestore.collection('users').doc(user.uid).update({
          'invitedLists': invitedLists.map((listData) => listData.toJson())
        });
        return unit;
      },
    );
  }

  // Since cloud funcs are chargeable and there is no possibility
  // to call update on a query call, the user data of other users
  // must be fetched and processed in the FE. This is a security
  // vulnerability that should be avoided in production code.
  Future<void> _removeListDataFromList(
    String listName,
    ListData listData,
  ) async {
    final user = await _firestore
        .collection('users')
        .where(listName, arrayContains: listData.toJson())
        .get();
    final userList =
        user.docs.map((e) => model.User.fromJson(e.data())).toList();

    for (var user in userList) {
      await _firestore.collection('users').doc(user.uid).update({
        listName: FieldValue.arrayRemove([listData.toJson()]),
      });
    }
  }

  Future<Result<Unit, FirebaseException>> deleteList({
    required ListData listData,
  }) async {
    return Result.asyncOf(() async {
      await _firestore.collection('lists').doc(listData.id).delete();
      await _removeListDataFromList('ownLists', listData);
      await _removeListDataFromList('invitedLists', listData);
      return unit;
    });
  }

  Future<Result<Unit, FirebaseException>> exitList({
    required String userId,
    required ListData listData,
  }) async {
    return Result.asyncOf(() async {
      await _firestore.collection('users').doc(userId).update({
        'invitedLists': FieldValue.arrayRemove([listData.toJson()]),
      });
      return unit;
    });
  }
}
