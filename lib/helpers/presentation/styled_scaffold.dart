import 'package:flutter/material.dart';

class StyledScaffold extends StatelessWidget {
  const StyledScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.bottom,
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24.0),
        title: Text(title),
        bottom: bottom,
        actionsIconTheme: const IconThemeData(color: Colors.white),
        actions: actions,
      ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
