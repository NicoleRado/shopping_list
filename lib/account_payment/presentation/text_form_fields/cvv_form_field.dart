import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CVVFormField extends StatelessWidget {
  const CVVFormField({super.key, required this.controller});

  final TextEditingController controller;

  MaskTextInputFormatter _createCVVMask() => MaskTextInputFormatter(
        mask: '####',
        filter: {'#': RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy,
      );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [_createCVVMask()],
      decoration: InputDecoration(
        label: const Text(
                'account_payment_page.text_form_fields.cvv_form_field_title')
            .tr(),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
