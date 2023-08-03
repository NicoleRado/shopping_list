import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/auth_failure.dart';
import '../domain/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.isUnauthenticated() = _IsUnauthenticated;
  const factory AuthState.isLoading() = _IsLoading;
  const factory AuthState.isAuthenticated({required User user}) =
      _IsAuthenticated;
  const factory AuthState.isFailure({required AuthFailure authFailure}) =
      _IsFailure;
}
