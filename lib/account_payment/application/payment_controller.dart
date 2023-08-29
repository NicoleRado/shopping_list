import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../infrastructure/payment_repository.dart';
import 'payment_state.dart';

final paymentProvider = StateNotifierProvider<PaymentController, PaymentState>(
    (ref) => PaymentController(ref.read(paymentRepositoryProvider)));

class PaymentController extends StateNotifier<PaymentState> {
  PaymentController(this.paymentRepository)
      : super(const PaymentState.isLoading());

  final PaymentRepository paymentRepository;

  Future<void> purchaseAccount() async {
    state = await paymentRepository.updatePaidFlag().then(
          (result) => result.when(
            ok: (_) => const PaymentState.isSuccess(),
            err: (_) => const PaymentState.isFailure(),
          ),
        );
  }
}
