import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:oxidized/oxidized.dart';
import 'package:shopping_list/account_payment/application/payment_controller.dart';
import 'package:shopping_list/account_payment/application/payment_state.dart';
import 'package:shopping_list/account_payment/infrastructure/payment_repository.dart';

import 'payment_controller_test.mocks.dart';

@GenerateMocks([PaymentRepository])
void main() {
  final firestoreException = FirebaseException(plugin: 'ERROR');

  late MockPaymentRepository mockPaymentRepository;
  late ProviderContainer container;
  late PaymentController paymentController;

  setUp(() {
    mockPaymentRepository = MockPaymentRepository();
    container = ProviderContainer(overrides: [
      paymentRepositoryProvider.overrideWith((ref) => mockPaymentRepository)
    ]);
    paymentController = container.read(paymentProvider.notifier);
  });

  group('purchaseAccount', () {
    test('tests, if user can purchase Account successfully', () async {
      expect(paymentController.state, const PaymentState.isLoading());
      provideDummy<Result<Unit, FirebaseException>>(const Ok(unit));

      when(mockPaymentRepository.updatePaidFlag())
          .thenAnswer((_) => Future.value(const Ok(unit)));

      await paymentController.purchaseAccount();

      expect(paymentController.state, const PaymentState.isSuccess());
    });

    test('tests, if an Exception leads to an failure state during purchase',
        () async {
      expect(paymentController.state, const PaymentState.isLoading());
      provideDummy<Result<Unit, FirebaseException>>(Err(firestoreException));

      when(mockPaymentRepository.updatePaidFlag())
          .thenAnswer((_) => Future.value(Err(firestoreException)));

      await paymentController.purchaseAccount();

      expect(paymentController.state, const PaymentState.isFailure());
    });
  });
}
