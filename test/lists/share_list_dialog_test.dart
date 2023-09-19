import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/helpers/presentation/styled_alert_dialog.dart';
import 'package:shopping_list/lists/presentation/dialogs/share_list_dialog.dart';

void main() {
  const listId = '5PC6gsxNO3els2x1ZziU';

  testWidgets('ShareListDialog renders correctly', (WidgetTester tester) async {
    await tester
        .pumpWidget(const MaterialApp(home: ShareListDialog(listId: listId)));
    await tester.pump();

    expect(find.byType(StyledAlertDialog), findsOneWidget);
    expect(find.text('common.close_button_title'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
    expect(find.text(listId), findsOneWidget);
    expect(find.byType(IconButton), findsOneWidget);
    expect(
        find.byTooltip(
            'list_page.dialogs.share_list_dialog.copy_to_clipboard_tooltip'),
        findsOneWidget);
  });

  testWidgets('Closes the dialog on close button press',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => const ShareListDialog(listId: listId),
          ),
          child: const Text('Show Dialog'),
        ),
      ),
    ));

    await tester.tap(find.text('Show Dialog'));
    await tester.pumpAndSettle();

    final closeButton =
        find.widgetWithText(ElevatedButton, 'common.close_button_title');
    expect(closeButton, findsOneWidget);

    await tester.tap(closeButton);
    await tester.pumpAndSettle();

    expect(find.byType(ShareListDialog), findsNothing);
  });
}
