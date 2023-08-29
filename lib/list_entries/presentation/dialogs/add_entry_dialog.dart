import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/presentation/styled_alert_dialog.dart';
import '../../application/list_entries_controller.dart';

class AddEntryDialog extends ConsumerStatefulWidget {
  const AddEntryDialog({super.key, required this.listId});

  final String listId;

  @override
  ConsumerState<AddEntryDialog> createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends ConsumerState<AddEntryDialog> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StyledAlertDialog(
      title: tr(
        'list_entries_page.dialogs.add_entry_dialog.add_entries_dialog_title',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: tr(
                  'list_entries_page.dialogs.add_entry_dialog.text_form_field_add_label',
                ),
              ),
              controller: textController,
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return tr(
                    'list_entries_page.dialogs.add_entry_dialog.validator_add_failure',
                  );
                }
                return null;
              },
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ref
                  .read(listEntriesControllerProvider(widget.listId).notifier)
                  .createEntry(entryName: textController.text.trim());
              Navigator.of(context).pop();
            }
          },
          child: const Text(
            'list_entries_page.dialogs.add_entry_dialog.add_entries_button_title',
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
