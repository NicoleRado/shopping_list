import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

import '../../helpers/domain/constants.dart';

final paymentRepositoryProvider =
    Provider<PaymentRepository>((ref) => PaymentRepository(
          auth: FirebaseAuth.instance,
          firestore: FirebaseFirestore.instance,
        ));

class PaymentRepository {
  PaymentRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  Future<Result<Unit, FirebaseException>> updatePaidFlag() async {
    return Result.asyncOf(() async {
      final userId = _auth.currentUser?.uid;
      final userRef =
          _firestore.collection(JsonParams.usersCollection).doc(userId);

      await userRef.update({JsonParams.isPaidAccount: true});
      return unit;
    });
  }
}
