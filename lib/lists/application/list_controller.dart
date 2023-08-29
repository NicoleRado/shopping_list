import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../lists/domain/list_failure.dart';
import '../domain/list_data.dart';
import '../domain/user.dart' as model;
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
  late final StreamSubscription listChanges;

  @override
  void dispose() {
    listChanges.cancel();
    super.dispose();
  }

  Future<void> createList({
    required model.User user,
    required String listName,
  }) async {
    state =
        await listRepository.createList(user: user, listName: listName).then(
              (result) => result.when(
                ok: (_) => state,
                err: (_) => const ListState.isFailure(
                  failure: ListFailure.createListFailure(),
                ),
              ),
            );
  }

  Future<void> joinList({
    required String userId,
    required String listId,
  }) async {
    state = await listRepository.joinList(userId: userId, listId: listId).then(
          (result) => result.when(
            ok: (_) => state,
            err: (err) => const ListState.isFailure(
              failure: ListFailure.joinListFailure(),
            ),
          ),
        );
  }

  Future<void> deleteList({required ListData listData}) async {
    state = await listRepository.deleteList(listData: listData).then(
          (result) => result.when(
            ok: (_) => state,
            err: (_) => const ListState.isFailure(
              failure: ListFailure.deleteListFailure(),
            ),
          ),
        );
  }

  Future<void> exitList({
    required ListData listData,
    required String userId,
  }) async {
    state = await listRepository
        .exitList(
          listData: listData,
          userId: userId,
        )
        .then(
          (result) => result.when(
            ok: (_) => state,
            err: (_) => const ListState.isFailure(
              failure: ListFailure.exitListFailure(),
            ),
          ),
        );
  }

  Future<void> renameList({
    required String oldListId,
    required String newName,
  }) async {
    state = await listRepository
        .renameList(
          oldListId: oldListId,
          newName: newName,
        )
        .then(
          (result) => result.when(
            ok: (_) => state,
            err: (_) => const ListState.isFailure(
              failure: ListFailure.renameListFailure(),
            ),
          ),
        );
  }
}
