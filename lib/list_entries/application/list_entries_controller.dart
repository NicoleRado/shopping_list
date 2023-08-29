import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/domain/constants.dart';
import '../domain/list_with_entries_failure.dart';
import '../infrastructure/list_entries_repository.dart';
import 'list_entries_state.dart';

final listEntriesControllerProvider = StateNotifierProvider.autoDispose
    .family<ListEntriesController, ListEntriesState, String>(
  (ref, listId) => ListEntriesController(
    listId,
    ref.read(listEntriesRepositoryProvider),
  ),
);

class ListEntriesController extends StateNotifier<ListEntriesState> {
  ListEntriesController(
    this.listId,
    this.listEntriesRepository,
  ) : super(const ListEntriesState.isLoading()) {
    listChanges =
        listEntriesRepository.getEntries(listId: listId).listen((result) {
      state = result.when(
        ok: (listWithEntries) => ListEntriesState.isSuccess(
          listWithEntries: listWithEntries,
        ),
        err: (_) => const ListEntriesState.isFailure(
          failure: ListWithEntriesFailure.noListEntriesAvailableFailure(),
        ),
      );
    });
  }

  final String listId;
  final ListEntriesRepository listEntriesRepository;
  StreamSubscription? listChanges;

  @override
  void dispose() {
    listChanges?.cancel();
    super.dispose();
  }

  Future<void> toggleEntry({
    required String entryName,
    required bool isCompleted,
  }) async {
    final removeListName =
        isCompleted ? JsonParams.completedEntries : JsonParams.listEntries;
    final addListName =
        isCompleted ? JsonParams.listEntries : JsonParams.completedEntries;
    final result = await listEntriesRepository.toggleEntry(
      listId: listId,
      entryName: entryName,
      removeListName: removeListName,
      addListName: addListName,
    );
    state = result.when(
      ok: (_) => state,
      err: (_) => const ListEntriesState.isFailure(
        failure: ListWithEntriesFailure.toggleListEntryFailure(),
      ),
    );
  }

  Future<void> createEntry({
    required String entryName,
  }) async {
    final result = await listEntriesRepository.createEntry(
      listId: listId,
      entryName: entryName,
    );
    state = result.when(
      ok: (_) => state,
      err: (_) => const ListEntriesState.isFailure(
        failure: ListWithEntriesFailure.createListEntryFailure(),
      ),
    );
  }

  Future<void> deleteAllCompletedEntries() async {
    final result = await listEntriesRepository.deleteAllCompletedEntries(
      listId: listId,
    );
    state = result.when(
      ok: (_) => state,
      err: (_) => const ListEntriesState.isFailure(
        failure: ListWithEntriesFailure.deleteAllCompletedEntriesFailure(),
      ),
    );
  }
}
