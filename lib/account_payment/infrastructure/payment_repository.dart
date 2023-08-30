import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

import '../../helpers/domain/constants.dart';

final paymentRepositoryProvider =
    Provider<PaymentRepository>((ref) => PaymentRepository());

class PaymentRepository {
  PaymentRepository();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Result<Unit, FirebaseException>> updatePaidFlag() async {
    return Result.asyncOf(() async {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      final userRef =
          _firestore.collection(JsonParams.usersCollection).doc(userId);

      await userRef.update({JsonParams.isPaidAccount: true});
      return unit;
    });
  }
}
