import 'package:freezed_annotation/freezed_annotation.dart';

part 'list_data.freezed.dart';
part 'list_data.g.dart';

@freezed
class ListData with _$ListData {
  const factory ListData({
    required String id,
    required String name,
  }) = _ListData;

  factory ListData.fromJson(Map<String, dynamic> json) =>
      _$ListDataFromJson(json);
}
