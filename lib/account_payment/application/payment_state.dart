import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_state.freezed.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.isLoading() = _PaymentIsLoading;
  const factory PaymentState.isSuccess() = _PaymentIsSuccess;
  const factory PaymentState.isFailure() = _PaymentIsFailure;
}
