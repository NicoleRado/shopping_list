import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/presentation/styled_alert_dialog.dart';
import '../../application/list_controller.dart';
import '../../domain/list_data.dart';

class EditListDialog extends ConsumerStatefulWidget {
  const EditListDialog({super.key, required this.listData});

  final ListData listData;

  @override
  ConsumerState<EditListDialog> createState() => _EditListDialogState();
}

class _EditListDialogState extends ConsumerState<EditListDialog> {
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.listData.name);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String? _onValidate(String? input) {
    if (input == null || input.trim().isEmpty) {
      return tr('list_page.dialogs.edit_list_dialog.validator_edit_failure');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return StyledAlertDialog(
      title: tr('list_page.dialogs.edit_list_dialog.edit_list_dialog_title'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('list_page.dialogs.edit_list_dialog.edit_list_info_text')
              .tr(),
          const SizedBox(height: 15),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: tr(
                    'list_page.dialogs.edit_list_dialog.text_form_field_edit_label'),
                errorMaxLines: 2,
              ),
              validator: _onValidate,
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              ref.read(listControllerProvider.notifier).renameList(
                    oldListId: widget.listData.id,
                    newName: _nameController.text.trim(),
                  );
              Navigator.of(context).pop();
            }
          },
          child: const Text(
                  'list_page.dialogs.edit_list_dialog.rename_list_button_title')
              .tr(),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('common.cancel_button_title').tr(),
        ),
      ],
    );
  }
}
