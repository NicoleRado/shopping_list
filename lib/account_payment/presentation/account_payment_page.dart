import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/presentation/styled_scaffold.dart';
import '../application/payment_controller.dart';
import '../presentation/text_form_fields/country_form_field.dart';
import '../presentation/text_form_fields/credit_card_number_form_field.dart';
import '../presentation/text_form_fields/cvv_form_field.dart';
import '../presentation/text_form_fields/date_form_field.dart';
import 'text_form_fields/zip_form_field.dart';

class AccountPaymentPage extends ConsumerStatefulWidget {
  const AccountPaymentPage({super.key});

  @override
  ConsumerState<AccountPaymentPage> createState() => _AccountPaymentPageState();
}

class _AccountPaymentPageState extends ConsumerState<AccountPaymentPage> {
  final String convertedDateTime =
      '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
  final int orderNumber = Random().nextInt(99999);

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _numberController =
      TextEditingController(text: '');
  final TextEditingController _dateController = TextEditingController(text: '');
  final TextEditingController _cvvController = TextEditingController(text: '');
  final TextEditingController _countryController =
      TextEditingController(text: '');
  final TextEditingController _zipController = TextEditingController(text: '');

  @override
  void dispose() {
    _numberController.dispose();
    _dateController.dispose();
    _cvvController.dispose();
    _countryController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  Future<void> _onPay({required BuildContext context}) async {
    if (_formKey.currentState!.validate()) {
      final navContext = Navigator.of(context);
      await ref.read(paymentProvider.notifier).purchaseAccount();
      print('###############################################################');
      print('Card Number: ${_numberController.text.trim()}');
      print('Expiration Date: ${_dateController.text.trim()}');
      print('CVV: ${_cvvController.text.trim()}');
      print('Country: ${_countryController.text.trim()}');
      print('ZIP: ${_zipController.text.trim()}');
      print('###############################################################');
      navContext.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return StyledScaffold(
      title: tr('account_payment_page.account_payment_page_title'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'account_payment_page.form_title',
                style: TextStyle(fontSize: 25),
              ).tr(),
              Card(
                surfaceTintColor: Colors.white,
                elevation: 20.0,
                shape: const BeveledRectangleBorder(
                  side: BorderSide(width: 0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15.0),
                      Center(
                          child: Icon(
                        Icons.monetization_on_outlined,
                        size: 50.0,
                        color: Theme.of(context).hintColor,
                      )),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                                  'account_payment_page.order_field_titles.order_id')
                              .tr(),
                          const Text(
                                  'account_payment_page.order_field_titles.date')
                              .tr(),
                          const Text(
                                  'account_payment_page.order_field_titles.amount')
                              .tr(),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(orderNumber.toString()),
                          Text(convertedDateTime),
                          const Text('account_payment_page.price').tr(),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      const Divider(),
                      const SizedBox(height: 15.0),
                      const Text(
                        'account_payment_page.account_payment_info_text',
                        style: TextStyle(fontSize: 15),
                      ).tr(),
                      const SizedBox(height: 5.0),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15.0),
                            CreditCardNumberFormField(
                                controller: _numberController),
                            const SizedBox(height: 6.0),
                            Row(
                              children: [
                                Expanded(
                                    child: DateFormField(
                                        controller: _dateController)),
                                Expanded(
                                    child: CVVFormField(
                                        controller: _cvvController)),
                              ],
                            ),
                            const SizedBox(height: 6.0),
                            CountryFormField(controller: _countryController),
                            const SizedBox(height: 6.0),
                            ZipFormField(controller: _zipController),
                            const SizedBox(height: 6.0),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => _onPay(context: context),
                                    child: const Text(
                                            'account_payment_page.account_payment_button_title')
                                        .tr(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 6.0,
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child:
                                        const Text('common.cancel_button_title')
                                            .tr(),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
