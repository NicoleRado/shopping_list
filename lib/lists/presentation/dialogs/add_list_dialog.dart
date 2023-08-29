import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/presentation/styled_alert_dialog.dart';
import '../../application/list_controller.dart';

class AddListDialog extends ConsumerStatefulWidget {
  const AddListDialog({super.key, required this.isCreateList});

  final bool isCreateList;

  @override
  ConsumerState<AddListDialog> createState() => _AddListDialogState();
}

class _AddListDialogState extends ConsumerState<AddListDialog> {
  final _formKey = GlobalKey<FormState>();
  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StyledAlertDialog(
        title: widget.isCreateList
            ? tr('list_page.dialogs.add_list_dialog.create_list_dialog_title')
            : tr('list_page.dialogs.add_list_dialog.join_list_dialog_title'),
        content: Form(
          key: _formKey,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.isCreateList)
                  const Text(
                          'list_page.dialogs.add_list_dialog.create_list_dialog_instruction')
                      .tr(),
                if (!widget.isCreateList)
                  const Text(
                          'list_page.dialogs.add_list_dialog.join_list_dialog_instruction')
                      .tr(),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: widget.isCreateList
                        ? tr(
                            'list_page.dialogs.add_list_dialog.text_form_field_create_label')
                        : tr(
                            'list_page.dialogs.add_list_dialog.text_form_field_join_label'),
                  ),
                  controller: textController,
                  validator: (input) {
                    if (input == null || input.isEmpty) {
                      return widget.isCreateList
                          ? tr(
                              'list_page.dialogs.add_list_dialog.validator_create_failure')
                          : tr(
                              'list_page.dialogs.add_list_dialog.validator_join_failure');
                    }
                    return null;
                  },
                )
              ]),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref.watch(listControllerProvider).whenOrNull(
                      isSuccess: (user) => widget.isCreateList
                          ? ref
                              .read(listControllerProvider.notifier)
                              .createList(
                                user: user,
                                listName: textController.text.trim(),
                              )
                          : ref.read(listControllerProvider.notifier).joinList(
                                userId: user.uid,
                                listId: textController.text.trim(),
                              ),
                    );
                Navigator.of(context).pop();
              }
            },
            child: widget.isCreateList
                ? const Text(
                        'list_page.dialogs.add_list_dialog.create_button_title')
                    .tr()
                : const Text(
                        'list_page.dialogs.add_list_dialog.join_button_title')
                    .tr(),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('common.cancel_button_title').tr(),
          )
        ],
      );
}
