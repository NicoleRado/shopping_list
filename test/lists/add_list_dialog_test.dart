import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/lists/presentation/dialogs/add_list_dialog.dart';

void main() {
  testWidgets('AddListDialog renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AddListDialog(isCreateList: true),
    ));

    expect(find.byType(AddListDialog), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
    expect(find.text('common.cancel_button_title'), findsOneWidget);
  });

  testWidgets('displays correct title and instruction for create list',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AddListDialog(isCreateList: true),
    ));

    expect(
        find.text('list_page.dialogs.add_list_dialog.create_list_dialog_title'),
        findsOneWidget);
    expect(
        find.text(
            'list_page.dialogs.add_list_dialog.create_list_dialog_instruction'),
        findsOneWidget);
    expect(
        find.text(
            'list_page.dialogs.add_list_dialog.text_form_field_create_label'),
        findsOneWidget);
    expect(find.text('list_page.dialogs.add_list_dialog.create_button_title'),
        findsOneWidget);

    final button = find.byType(ElevatedButton).first;
    await tester.tap(button);
    await tester.pump();

    expect(
        find.text('list_page.dialogs.add_list_dialog.validator_create_failure'),
        findsOneWidget);
  });

  testWidgets(
      'AddListDialog displays correct title and instruction for join list',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: AddListDialog(isCreateList: false),
    ));

    expect(
        find.text('list_page.dialogs.add_list_dialog.join_list_dialog_title'),
        findsOneWidget);
    expect(
        find.text(
            'list_page.dialogs.add_list_dialog.join_list_dialog_instruction'),
        findsOneWidget);
    expect(
        find.text(
            'list_page.dialogs.add_list_dialog.text_form_field_join_label'),
        findsOneWidget);
    expect(find.text('list_page.dialogs.add_list_dialog.join_button_title'),
        findsOneWidget);

    final button = find.byType(ElevatedButton).first;
    await tester.tap(button);
    await tester.pump();

    expect(
        find.text('list_page.dialogs.add_list_dialog.validator_join_failure'),
        findsOneWidget);
  });

  testWidgets('Closes the dialog on close button press',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () => showDialog<void>(
            context: context,
            builder: (_) => const AddListDialog(isCreateList: true),
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

    expect(find.byType(AddListDialog), findsNothing);
  });
}
