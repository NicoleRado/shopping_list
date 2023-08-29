import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../lists/domain/list_failure.dart';
import '../domain/list_data.dart';
import '../domain/user.dart' as modle;
import '../infrastructure/list_repository.dart';
import 'list_state.dart';

final listControllerProvider =
    StateNotifierProvider.autoDispose<ListController, ListState>(
  (ref) => ListController(ref.read(listRepositoryProvider)),
);

class ListController extends StateNotifier<ListState> {
  ListController(
    this.listRepository,
  ) : super(const ListState.isLoading()) {
    listChanges = listRepository.getUserData().listen((result) {
      state = result.when(
        ok: (user) => ListState.isSuccess(user: user),
        err: (_) =>
            const ListState.isFailure(failure: ListFailure.userDataFailure()),
      );
    });
  }

  final ListRepository listRepository;
  StreamSubscription? listChanges;

  @override
  void dispose() {
    listChanges?.cancel();
    super.dispose();
  }

  Future<void> createList({
    required modle.User user,
    required String listName,
  }) async {
    final result =
        await listRepository.createList(user: user, listName: listName);
    state = result.when(
      ok: (_) => state,
      err: (_) =>
          const ListState.isFailure(failure: ListFailure.createListFailure()),
    );
  }

  Future<void> joinList({
    required String userId,
    required String listId,
  }) async {
    final result =
        await listRepository.joinList(userId: userId, listId: listId);
    state = result.when(
      ok: (_) => state,
      err: (err) => const ListState.isFailure(
        failure: ListFailure.joinListFailure(),
      ),
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

  Future<void> exitList({
    required ListData listData,
    required String userId,
  }) async {
    final result =
        await listRepository.exitList(listData: listData, userId: userId);
    state = result.when(
      ok: (_) => state,
      err: (_) => const ListState.isFailure(
        failure: ListFailure.exitListFailure(),
      ),
    );
  }

  Future<void> renameList({
    required String oldListId,
    required String newName,
  }) async {
    final result =
        await listRepository.renameList(oldListId: oldListId, newName: newName);
    state = result.when(
      ok: (_) => state,
      err: (_) => const ListState.isFailure(
        failure: ListFailure.renameListFailure(),
      ),
    );
  }
}
