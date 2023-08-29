import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/list_with_entries.dart';
import '../domain/list_with_entries_failure.dart';

part 'list_entries_state.freezed.dart';

@freezed
class ListEntriesState with _$ListEntriesState {
  const factory ListEntriesState.isLoading() = _ListEntriesLoading;
  const factory ListEntriesState.isSuccess({
    required ListWithEntries listWithEntries,
  }) = _ListEntriesLoaded;
  const factory ListEntriesState.isFailure({
    required ListWithEntriesFailure failure,
  }) = _ListEntriesError;
}
