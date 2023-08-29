import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CountryFormField extends StatelessWidget {
  const CountryFormField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: const Text(
                'account_payment_page.text_form_fields.country_form_field_title')
            .tr(),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
