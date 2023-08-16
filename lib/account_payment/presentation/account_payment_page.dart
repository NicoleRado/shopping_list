import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AccountPaymentPage extends StatefulWidget {
  const AccountPaymentPage({super.key});

  @override
  State<AccountPaymentPage> createState() => _AccountPaymentPageState();
}

class _AccountPaymentPageState extends State<AccountPaymentPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title:
            const Text('account_payment_page.account_payment_page_title').tr(),
      ),
      body: Container(),
    );
  }
}
