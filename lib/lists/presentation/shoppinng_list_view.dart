import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/list_data.dart';
import 'dialogs/delete_list_dialog.dart';
import 'dialogs/share_list_dialog.dart';

class ShoppingListView extends ConsumerWidget {
  const ShoppingListView({
    super.key,
    required this.listData,
    required this.isOwnList,
    required this.isPaidAccount,
    required this.userId,
  });

  final List<ListData> listData;
  final bool isOwnList;
  final bool isPaidAccount;
  final String userId;

  Future<void> onDelete() async {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: listData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: ListTile(
              tileColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text(listData[index].name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isOwnList && isPaidAccount)
                    IconButton(
                      onPressed: () {},
                      tooltip: tr(
                          'list_page.list_entry_button.edit_icon_button_tooltip'),
                      icon: const Icon(Icons.edit),
                    ),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => DeleteListDialog(
                        listData: listData[index],
                        isOwnList: isOwnList,
                        userId: userId,
                      ),
                    ),
                    tooltip: tr(
                        'list_page.list_entry_button.delete_icon_button_tooltip'),
                    icon: const Icon(Icons.delete),
                  ),
                  if (isOwnList && isPaidAccount)
                    IconButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            ShareListDialog(listId: listData[index].id),
                      ),
                      tooltip: tr(
                          'list_page.list_entry_button.share_icon_button_tooltip'),
                      icon: const Icon(Icons.share),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
