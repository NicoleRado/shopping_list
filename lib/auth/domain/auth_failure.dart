import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_failure.freezed.dart';

@freezed
class AuthFailure with _$AuthFailure {
  const factory AuthFailure.loginFailure() = _LoginFailure;
  const factory AuthFailure.registerFailure({String? message}) =
      _RegisterFailure;
  const factory AuthFailure.signOutFailure() = _SignOutFailure;
}
