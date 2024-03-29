import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

import '../../helpers/domain/constants.dart';
import '../domain/list_data.dart';
import '../domain/user.dart' as model;

final listRepositoryProvider = Provider<ListRepository>((ref) => ListRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ));

class ListRepository {
  ListRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<Result<model.User, Exception>> getUserData() {
    final userId = _auth.currentUser?.uid;
    final userRef =
        _firestore.collection(JsonParams.usersCollection).doc(userId);

    return userRef.snapshots().map(
          (snapShot) => Result.of(() {
            if (snapShot.data() != null) {
              return model.User.fromJson(snapShot.data()!);
            }
            throw Exception('Userdata is null');
          }),
        );
  }

  Future<Result<Unit, FirebaseException>> createList({
    required model.User user,
    required String listName,
  }) async =>
      Result.asyncOf(
        () async {
          final listRef =
              _firestore.collection(JsonParams.listsCollection).doc();
          final ownList = [
            ...user.ownLists,
            ListData(id: listRef.id, name: listName)
          ];
          final listData = {
            JsonParams.listId: listRef.id,
            JsonParams.listName: listName,
            JsonParams.listEntries: [],
            JsonParams.completedEntries: [],
          };

          await listRef.set(listData);

          await _firestore
              .collection(JsonParams.usersCollection)
              .doc(user.uid)
              .update({
            JsonParams.ownLists:
                ownList.map((listData) => listData.toJson()).toList()
          });
          return unit;
        },
      );

  Future<Result<Unit, Exception>> joinList({
    required String userId,
    required String listId,
  }) async =>
      Result.asyncOf(
        () async {
          final userRef =
              _firestore.collection(JsonParams.usersCollection).doc(userId);
          final listRef =
              _firestore.collection(JsonParams.listsCollection).doc(listId);

          final listData = await listRef.get().then((snapshot) {
            if (snapshot.data() == null) {
              throw Exception('List dose not exists!');
            }
            return ListData.fromJson(snapshot.data()!);
          });

          await userRef.update({
            JsonParams.invitedLists: FieldValue.arrayUnion([listData.toJson()]),
          });
          return unit;
        },
      );

  Future<Result<Unit, FirebaseException>> deleteList({
    required String listId,
  }) async =>
      Result.asyncOf(() async {
        await _firestore
            .collection(JsonParams.listsCollection)
            .doc(listId)
            .delete();
        return unit;
      });

  Future<Result<Unit, FirebaseException>> exitList({
    required String userId,
    required ListData listData,
  }) async =>
      Result.asyncOf(() async {
        await _firestore
            .collection(JsonParams.usersCollection)
            .doc(userId)
            .update({
          JsonParams.invitedLists: FieldValue.arrayRemove([listData.toJson()]),
        });
        return unit;
      });

  Future<Result<Unit, FirebaseException>> renameList({
    required String oldListId,
    required String newName,
  }) async =>
      Result.asyncOf(() async {
        await _firestore
            .collection(JsonParams.listsCollection)
            .doc(oldListId)
            .update({JsonParams.listName: newName});
        return unit;
      });
}
