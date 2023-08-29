import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../helpers/presentation/styled_alert_dialog.dart';

class AccountPaymentDialog extends StatelessWidget {
  const AccountPaymentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return StyledAlertDialog(
      title: tr(
        'list_page.dialogs.account_payment_dialog.account_payment_dialog_title',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'list_page.dialogs.account_payment_dialog.account_payment_info_text',
          ).tr(),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'list_page.dialogs.account_payment_dialog.account_payment_question',
          ).tr(),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.go('/accountPayment');
          },
          child: const Text(
            'list_page.dialogs.account_payment_dialog.go_to_payment_button_title',
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
