import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/list_controller.dart';
import '../../domain/list_data.dart';

class DeleteListDialog extends ConsumerWidget {
  const DeleteListDialog(
      {super.key,
      required this.listData,
      required this.isOwnList,
      required this.userId});

  final ListData listData;
  final bool isOwnList;
  final String userId;

  Future<void> _onDelete(WidgetRef ref) async {
    if (isOwnList) {
      await ref
          .read(listControllerProvider.notifier)
          .deleteList(listData: listData);
    } else {
      await ref
          .read(listControllerProvider.notifier)
          .exitList(listData: listData, userId: userId);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: Center(
        child: const Text(
          'list_page.dialogs.delete_list_dialog.delete_list_dialog_title',
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
          if (isOwnList)
            const Text(
              'list_page.dialogs.delete_list_dialog.delete_info_text_own_list',
            ).tr(),
          if (!isOwnList)
            const Text(
              'list_page.dialogs.delete_list_dialog.delete_info_text_invited_list',
            ).tr(),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'list_page.dialogs.delete_list_dialog.delete_question',
          ).tr(),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            _onDelete(ref);
            Navigator.of(context).pop();
          },
          child: const Text(
            'list_page.dialogs.delete_list_dialog.delete_button_title',
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
