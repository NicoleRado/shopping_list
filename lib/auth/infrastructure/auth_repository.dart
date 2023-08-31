import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

import '../../helpers/domain/constants.dart';
import '../../lists/domain/user.dart' as model;

final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ));

class AuthRepository {
  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _firestore = firestore,
        _auth = auth;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Stream<bool> isAuthenticated() {
    return _auth.authStateChanges().map(
          (user) => user == null ? false : true,
        );
  }

  Future<Result<Unit, FirebaseAuthException>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return Result.asyncOf(
      () async {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return unit;
      },
    );
  }

  Future<Result<Unit, Exception>> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return Result.asyncOf(
      () async {
        final cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = model.User(uid: cred.user!.uid);

        await _firestore
            .collection(JsonParams.usersCollection)
            .doc(cred.user!.uid)
            .set(user.toJson());

        return unit;
      },
    );
  }

  Future<Result<Unit, FirebaseAuthException>> signOut() async {
    return Result.asyncOf(
      () async {
        await _auth.signOut();
        return unit;
      },
    );
  }
}
