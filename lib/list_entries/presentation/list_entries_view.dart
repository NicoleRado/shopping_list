import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/list_entries_controller.dart';

class ListEntriesView extends ConsumerWidget {
  const ListEntriesView({
    super.key,
    required this.listId,
    required this.listEntries,
    required this.isCompleted,
  });

  final String listId;
  final List<String> listEntries;
  final bool isCompleted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listEntries.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 4.0),
          child: CheckboxListTile(
            title: Text(listEntries[index]),
            tileColor: Colors.grey[200],
            controlAffinity: ListTileControlAffinity.leading,
            value: isCompleted,
            onChanged: (value) => ref
                .read(listEntriesControllerProvider(listId).notifier)
                .toggleEntry(
                  entryName: listEntries[index],
                  isCompleted: isCompleted,
                ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
