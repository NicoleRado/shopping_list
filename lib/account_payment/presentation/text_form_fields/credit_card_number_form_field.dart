import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CreditCardNumberFormField extends StatelessWidget {
  const CreditCardNumberFormField({super.key, required this.controller});

  final TextEditingController controller;

  MaskTextInputFormatter _createCardNumberMask() => MaskTextInputFormatter(
        mask: '#### #### #### ####',
        filter: {'#': RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy,
      );

  String? _onValidate(String? input) {
    if (input == null || input.length != 19) {
      return tr(
          'account_payment_page.text_form_fields.credit_card_number_validator_failure');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [_createCardNumberMask()],
      decoration: InputDecoration(
        label: const Text(
                'account_payment_page.text_form_fields.credit_card_number_form_field_title')
            .tr(),
        border: const OutlineInputBorder(),
      ),
      validator: _onValidate,
    );
  }
}
