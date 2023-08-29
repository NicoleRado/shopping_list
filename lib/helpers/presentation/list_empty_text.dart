import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ListEmptyText extends StatelessWidget {
  const ListEmptyText({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          child: Center(
            child: const Text('common.list_empty_text').tr(),
          ),
        ),
      ],
    );
  }
}
