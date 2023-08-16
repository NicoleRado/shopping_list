import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopping_list/lists/domain/list_failure.dart';

import '../domain/list_data.dart';
import '../domain/user.dart' as modle;
import '../infrastructure/list_repository.dart';
import 'list_state.dart';

final listControllerProvider =
    StateNotifierProvider.autoDispose<ListController, ListState>(
  (ref) => ListController(
      ref.read(listRepositoryProvider), ref.read(listStreamProvider)),
);

class ListController extends StateNotifier<ListState> {
  ListController(
    this.listRepository,
    this.listStream,
  ) : super(const ListState.isLoading()) {
    listChanges = listStream.listen(
      (snapShot) {
        if (snapShot.data() != null) {
          final user = modle.User.fromJson(snapShot.data()!);
          print(
              '--------------------------- $user ----------------------------');
          state = ListState.isSuccess(user: user);
        }
      },
    );
  }

  final ListRepository listRepository;
  final Stream<DocumentSnapshot<Map<String, dynamic>>> listStream;
  StreamSubscription? listChanges;

  @override
  void dispose() {
    listChanges?.cancel();
    super.dispose();
  }

  Future<void> createList(
      {required modle.User user, required String listName}) async {
    final result =
        await listRepository.createList(user: user, listName: listName);
    state = result.when(
      ok: (_) => state,
      err: (_) =>
          const ListState.isFailure(failure: ListFailure.createListFailure()),
    );
  }

  Future<void> joinList(
      {required modle.User user, required String listId}) async {
    final result = await listRepository.joinList(user: user, listId: listId);
    state = result.when(
      ok: (_) => state,
      err: (_) =>
          const ListState.isFailure(failure: ListFailure.joinListFailure()),
    );
  }

  Future<void> deleteList({required ListData listData}) async {
    final result = await listRepository.deleteList(listData: listData);
    state = result.when(
      ok: (_) => state,
      err: (_) => const ListState.isFailure(
        failure: ListFailure.deleteListFailure(),
      ),
    );
  }

  Future<void> exitList(
      {required ListData listData, required String userId}) async {
    final result =
        await listRepository.exitList(listData: listData, userId: userId);
    state = result.when(
      ok: (_) => state,
      err: (_) => const ListState.isFailure(
        failure: ListFailure.exitListFailure(),
      ),
    );
  }
}
