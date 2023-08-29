import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_failure.freezed.dart';

@freezed
class ListFailure with _$ListFailure {
  const factory ListFailure.userDataFailure() = _UserDataFailure;
  const factory ListFailure.createListFailure() = _CreateListFailure;
  const factory ListFailure.joinListFailure() = _JoinListFailure;
  const factory ListFailure.deleteListFailure() = _DeleteListFailure;
  const factory ListFailure.exitListFailure() = _ExitListFailure;
  const factory ListFailure.renameListFailure() = _RenameListFailure;
}
