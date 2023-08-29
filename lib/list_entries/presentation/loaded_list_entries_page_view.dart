import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/presentation/list_empty_text.dart';
import '../../helpers/presentation/styled_scaffold.dart';
import '../application/list_entries_controller.dart';
import '../domain/list_with_entries.dart';
import 'dialogs/add_entry_dialog.dart';
import 'dialogs/delete_entries_dialog.dart';
import 'list_entries_view.dart';

class LoadedListEntriesPageView extends ConsumerStatefulWidget {
  const LoadedListEntriesPageView(
      {super.key, required this.listId, required this.listWithEntries});

  final String listId;
  final ListWithEntries listWithEntries;

  @override
  ConsumerState<LoadedListEntriesPageView> createState() =>
      _LoadedListEntriesPageViewState();
}

class _LoadedListEntriesPageViewState
    extends ConsumerState<LoadedListEntriesPageView> {
  int selectedIndex = 0;

  List<Widget> _createTabs({required ListWithEntries listWithEntries}) => [
        listWithEntries.listEntries.isEmpty
            ? const ListEmptyText()
            : ListEntriesView(
                listId: listWithEntries.id,
                listEntries: listWithEntries.listEntries,
                isCompleted: false,
              ),
        listWithEntries.completedEntries.isEmpty
            ? const ListEmptyText()
            : ListEntriesView(
                listId: listWithEntries.id,
                listEntries: listWithEntries.completedEntries,
                isCompleted: true,
              ),
      ];

  @override
  Widget build(BuildContext context) {
    return StyledScaffold(
      title: widget.listWithEntries.name,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white.withOpacity(0.7),
        selectedItemColor: Colors.white,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.fact_check_outlined),
            label: tr('list_entries_page.open_list_entries_bottom_tab'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.done),
            label: tr('list_entries_page.completed_list_entries_bottom_tab'),
          )
        ],
      ),
      floatingActionButton: selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => AddEntryDialog(
                  listId: widget.listId,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => DeleteEntriesDialog(
                  listId: widget.listId,
                ),
              ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: const Icon(Icons.delete),
            ),
      body: RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(listEntriesControllerProvider(widget.listId)),
          child: _createTabs(
              listWithEntries: widget.listWithEntries)[selectedIndex]),
    );
  }
}
