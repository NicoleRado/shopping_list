import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/application/auth_controller.dart';
import '../../../helpers/domain/enums.dart';
import '../dialogs/account_payment_dialog.dart';
import '../dialogs/switch_language_dialog.dart';

class PopupMenu extends ConsumerStatefulWidget {
  const PopupMenu({
    super.key,
    required this.isPaidAccount,
  });

  final bool isPaidAccount;

  @override
  ConsumerState<PopupMenu> createState() => _PopupMenuState();
}

class _PopupMenuState extends ConsumerState<PopupMenu> {
  PopupMenuItem _buildPopupMenuItem({
    required PopupOptions value,
    required IconData iconData,
    required String title,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(iconData, color: Colors.black),
          const SizedBox(
            width: 5,
          ),
          Text(title),
        ],
      ),
    );
  }

  void _onMenuItemSelected(PopupOptions value) {
    switch (value) {
      case PopupOptions.paidAccount:
        showDialog(
          context: context,
          builder: (BuildContext context) => const AccountPaymentDialog(),
        );
        break;
      case PopupOptions.language:
        showDialog(
          context: context,
          builder: (BuildContext context) => const SwitchLanguageDialog(),
        );
        break;
      case PopupOptions.logout:
        ref.read(authControllerProvider.notifier).signOut();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) => _onMenuItemSelected(value),
      itemBuilder: (context) {
        return [
          if (!widget.isPaidAccount)
            _buildPopupMenuItem(
              value: PopupOptions.paidAccount,
              iconData: Icons.monetization_on_outlined,
              title: tr('list_page.popup_menu.paid_version_item_label'),
            ),
          _buildPopupMenuItem(
            value: PopupOptions.language,
            iconData: Icons.translate,
            title: tr('list_page.popup_menu.language_item_label'),
          ),
          _buildPopupMenuItem(
            value: PopupOptions.logout,
            iconData: Icons.logout,
            title: tr('list_page.popup_menu.logout_item_label'),
          ),
        ];
      },
    );
  }
}
