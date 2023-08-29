import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../helpers/presentation/list_empty_text.dart';
import '../../../helpers/presentation/styled_scaffold.dart';
import '../../application/list_controller.dart';
import '../../domain/user.dart';
import '../button_widgets/expandable_fab.dart';
import '../button_widgets/popup_menu.dart';
import '../shoppinng_list_view.dart';

class LoadedListPageView extends ConsumerStatefulWidget {
  const LoadedListPageView(
      {super.key, required this.user, required this.title});

  final User user;
  final String title;

  @override
  ConsumerState<LoadedListPageView> createState() => _ListPageViewState();
}

class _ListPageViewState extends ConsumerState<LoadedListPageView> {
  @override
  Widget build(BuildContext context) {
    final ownLists = widget.user.ownLists;
    final invitedLists = widget.user.invitedLists;
    final isPaidAccount = widget.user.isPaidAccount;
    final userId = widget.user.uid;

    return StyledScaffold(
      title: widget.title,
      actions: [PopupMenu(isPaidAccount: isPaidAccount)],
      floatingActionButton: ExpandableFab(isPaidAccount: isPaidAccount),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(listControllerProvider),
        child: ownLists.isEmpty && invitedLists.isEmpty
            ? const ListEmptyText()
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (ownLists.isNotEmpty)
                    ShoppingListView(
                      listData: ownLists,
                      isOwnList: true,
                      isPaidAccount: isPaidAccount,
                      userId: userId,
                    ),
                  if (invitedLists.isNotEmpty)
                    ShoppingListView(
                      listData: invitedLists,
                      isOwnList: false,
                      isPaidAccount: isPaidAccount,
                      userId: userId,
                    ),
                ],
              ),
      ),
    );
  }
}
