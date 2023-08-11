import 'package:freezed_annotation/freezed_annotation.dart';

import 'list_data.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String uid,
    @Default([]) List<ListData> ownLists,
    @Default([]) List<ListData> invitedLists,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
