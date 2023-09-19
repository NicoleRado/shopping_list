import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/helpers/presentation/styled_alert_dialog.dart';
import 'package:shopping_list/lists/presentation/dialogs/account_payment_dialog.dart';

void main() {
  testWidgets('AccountPaymentDialog renders correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AccountPaymentDialog(),
    ));

    expect(find.byType(StyledAlertDialog), findsOneWidget);

    expect(
        find.text(
            'list_page.dialogs.account_payment_dialog.account_payment_dialog_title'),
        findsOneWidget);
    expect(
        find.text(
            'list_page.dialogs.account_payment_dialog.account_payment_info_text'),
        findsOneWidget);
    expect(
        find.text(
            'list_page.dialogs.account_payment_dialog.account_payment_question'),
        findsOneWidget);

    expect(
        find.text(
            'list_page.dialogs.account_payment_dialog.go_to_payment_button_title'),
        findsOneWidget);
    expect(find.text('common.cancel_button_title'), findsOneWidget);
  });

  testWidgets('Closes the dialog on close button press',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => const AccountPaymentDialog(),
          ),
          child: const Text('Show Dialog'),
        ),
      ),
    ));

    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    final closeButton =
        find.widgetWithText(ElevatedButton, 'common.cancel_button_title');
    expect(closeButton, findsOneWidget);

    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    expect(find.byType(AccountPaymentDialog), findsNothing);
  });
}
