import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class DateFormField extends StatelessWidget {
  const DateFormField({super.key, required this.controller});

  final TextEditingController controller;

  MaskTextInputFormatter _createDateMask() => MaskTextInputFormatter(
        mask: '##/##',
        filter: {'#': RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy,
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [_createDateMask()],
      decoration: InputDecoration(
        label: const Text(
                'account_payment_page.text_form_fields.date_form_field_title')
            .tr(),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
