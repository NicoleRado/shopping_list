import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/list_data.dart';
import 'dialogs/delete_list_dialog.dart';
import 'dialogs/edit_list_dialog.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              isOwnList
                  ? tr('list_page.own_lists_title')
                  : tr('list_page.invited_lists_title'),
              style: const TextStyle(fontSize: 25.0),
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: listData.length,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: ListTile(
                tileColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                title: Text(listData[index].name),
                onTap: () => context.goNamed(
                  'list_entries_page',
                  pathParameters: {
                    'id': listData[index].id,
                  },
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isOwnList && isPaidAccount)
                      IconButton(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              EditListDialog(listData: listData[index]),
                        ),
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
            ),
          ),
        ],
      ),
    );
  }
}
