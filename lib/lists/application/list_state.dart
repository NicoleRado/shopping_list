import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/list_failure.dart';
import '../domain/user.dart';

part 'list_state.freezed.dart';

@freezed
class ListState with _$ListState {
  const factory ListState.isLoading() = _IsLoadingList;
  const factory ListState.isSuccess({required User user}) = _IsSuccessUser;
  const factory ListState.isFailure({required ListFailure failure}) =
      _IsFailureList;
}
