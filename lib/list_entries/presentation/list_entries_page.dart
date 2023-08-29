import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/presentation/list_empty_text.dart';
import '../../helpers/presentation/styled_scaffold.dart';
import '../application/list_entries_controller.dart';
import 'loaded_list_entries_page_view.dart';

class ListEntriesPage extends ConsumerWidget {
  const ListEntriesPage({
    super.key,
    required this.id,
  });

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(
      listEntriesControllerProvider(id).select(
        (currentState) => currentState.maybeWhen(
          isFailure: (failure) => failure,
          orElse: () => null,
        ),
      ),
      ((previous, next) {
        if (next != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                next.when(
                  noListEntriesAvailableFailure: () => tr(
                      'list_entries_page.list_entries_error.no_list_entries_available_failure'),
                  createListEntryFailure: () => tr(
                      'list_entries_page.list_entries_error.create_list_entry_failure'),
                  toggleListEntryFailure: () => tr(
                      'list_entries_page.list_entries_error.toggle_list_entry_failure'),
                  deleteAllCompletedEntriesFailure: () => tr(
                      'list_entries_page.list_entries_error.delete_all_completed_entries_failure'),
                ),
              ),
            ),
          );
        }
      }),
    );

    return ref.watch(listEntriesControllerProvider(id)).when(
          isLoading: () => const StyledScaffold(
            title: '',
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
          isSuccess: (listWithEntries) => LoadedListEntriesPageView(
            listId: id,
            listWithEntries: listWithEntries,
          ),
          isFailure: (_) => StyledScaffold(
            title: '',
            body: RefreshIndicator(
              onRefresh: () async =>
                  ref.invalidate(listEntriesControllerProvider(id)),
              child: const ListEmptyText(),
            ),
          ),
        );
  }
}
