import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/list_controller.dart';

class DefaultListPageView extends ConsumerWidget {
  const DefaultListPageView({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        actions: [child],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(listControllerProvider),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}
