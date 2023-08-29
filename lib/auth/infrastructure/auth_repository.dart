import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

import '../../helpers/domain/constants.dart';
import '../../lists/domain/user.dart' as model;

final isAuthenticatedStreamProvider =
    Provider<Stream<User?>>((ref) => FirebaseAuth.instance.authStateChanges());

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

class AuthRepository {
  AuthRepository();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<bool> isAuthenticated() {
    return FirebaseAuth.instance
        .authStateChanges()
        .map((user) => user == null ? false : true);
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

  Future<Result<Unit, FirebaseAuthException>> registerWithEmailAndPassword({
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
