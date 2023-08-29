import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/presentation/styled_alert_dialog.dart';
import '../../application/list_entries_controller.dart';

class DeleteEntriesDialog extends ConsumerWidget {
  const DeleteEntriesDialog({super.key, required this.listId});

  final String listId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StyledAlertDialog(
      title: tr(
        'list_entries_page.dialogs.delete_entries_dialog.delete_entries_dialog_title',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'list_entries_page.dialogs.delete_entries_dialog.delete_entries_dialog_info_text',
          ).tr(),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            ref
                .read(listEntriesControllerProvider(listId).notifier)
                .deleteAllCompletedEntries();
            Navigator.of(context).pop();
          },
          child: const Text(
            'list_entries_page.dialogs.delete_entries_dialog.delete_all_entries_button_title',
          ).tr(),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('common.cancel_button_title').tr(),
        )
      ],
    );
  }
}
