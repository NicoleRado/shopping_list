import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_with_entries.freezed.dart';
part 'list_with_entries.g.dart';

@freezed
class ListWithEntries with _$ListWithEntries {
  const factory ListWithEntries({
    required String id,
    required String name,
    required List<String> listEntries,
    required List<String> completedEntries,
  }) = _ListWithEntries;

  factory ListWithEntries.fromJson(Map<String, dynamic> json) =>
      _$ListWithEntriesFromJson(json);
}
