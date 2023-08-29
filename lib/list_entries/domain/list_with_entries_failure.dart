import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_with_entries_failure.freezed.dart';

@freezed
class ListWithEntriesFailure with _$ListWithEntriesFailure {
  const factory ListWithEntriesFailure.noListEntriesAvailableFailure() =
      _NoListEntriesAvailableFailure;
  const factory ListWithEntriesFailure.createListEntryFailure() =
      _AddListEntryFailure;
  const factory ListWithEntriesFailure.toggleListEntryFailure() =
      _DeleteListEntryFailure;
  const factory ListWithEntriesFailure.deleteAllCompletedEntriesFailure() =
      _DeleteAllCompletedEntriesFailure;
}
