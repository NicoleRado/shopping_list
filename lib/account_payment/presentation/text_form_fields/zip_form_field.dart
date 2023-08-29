import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ZipFormField extends StatelessWidget {
  const ZipFormField({super.key, required this.controller});

  final TextEditingController controller;

  MaskTextInputFormatter _createZIPMask() => MaskTextInputFormatter(
        mask: '#####',
        filter: {'#': RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy,
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      inputFormatters: [_createZIPMask()],
      decoration: InputDecoration(
        label: const Text(
                'account_payment_page.text_form_fields.zip_form_field_title')
            .tr(),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
