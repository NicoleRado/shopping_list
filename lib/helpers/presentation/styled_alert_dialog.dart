import 'package:flutter/material.dart';

class StyledAlertDialog extends StatelessWidget {
  const StyledAlertDialog(
      {super.key, required this.title, this.content, this.actions});

  final String title;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      title: Center(
        child: Text(title),
      ),
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      content: content,
      actions: actions,
    );
  }
}
