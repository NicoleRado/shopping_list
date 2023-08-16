import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/list_controller.dart';

class SwitchLanguageDialog extends ConsumerStatefulWidget {
  const SwitchLanguageDialog({super.key});

  @override
  ConsumerState<SwitchLanguageDialog> createState() =>
      _SwitchLanguageDialogState();
}

class _SwitchLanguageDialogState extends ConsumerState<SwitchLanguageDialog> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _locale = context.locale;
    });
  }

  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(
      value: 'de',
      child: const Text(
              'list_page.dialogs.switch_language_dialog.menu_option_german')
          .tr(),
    ),
    DropdownMenuItem(
      value: 'en',
      child: const Text(
              'list_page.dialogs.switch_language_dialog.menu_option_english')
          .tr(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: Center(
        child: const Text(
                'list_page.dialogs.switch_language_dialog.switch_language_dialog_title')
            .tr(),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
                  'list_page.dialogs.switch_language_dialog.switch_language_dialog_instruction')
              .tr(),
          const SizedBox(height: 8),
          DropdownButton(
            value: _locale?.languageCode ?? context.locale.languageCode,
            items: menuItems,
            onChanged: (value) {
              setState(() {
                _locale = Locale(value!);
              });
            },
            padding: const EdgeInsets.symmetric(horizontal: 8),
            isExpanded: true,
          )
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            context.setLocale(_locale!);
            ref.invalidate(listControllerProvider);
            Navigator.of(context).pop();
          },
          child: const Text(
            'list_page.dialogs.switch_language_dialog.change_language_button_title',
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
