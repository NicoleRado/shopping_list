import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShareListDialog extends StatelessWidget {
  const ShareListDialog({super.key, required this.listId});

  final String listId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: Center(
        child: const Text(
          'list_page.dialogs.share_list_dialog.share_list_dialog_title',
        ).tr(),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'list_page.dialogs.share_list_dialog.share_list_dialog_instruction',
          ).tr(),
          const SizedBox(height: 10),
          ListTile(
            enabled: false,
            tileColor: Colors.grey[200],
            title: Text(listId),
            trailing: IconButton(
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: listId));
              },
              tooltip: tr(
                'list_page.dialogs.share_list_dialog.copy_to_clipboard_tooltip',
              ),
              icon: const Icon(Icons.copy),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'list_page.dialogs.share_list_dialog.share_list_dialog_info_text',
          ).tr(args: [tr('list_page.expandable_fab.join_list_label')]),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('common.close_button_title').tr(),
        ),
      ],
    );
  }
}
