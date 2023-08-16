import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/list_controller.dart';
import 'list_views/default_list_page_view.dart';
import 'list_views/loaded_list_page_view.dart';

class ListPage extends ConsumerWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = tr('list_page.list_page_title');

    ref.listen(
      listControllerProvider.select(
        (currentState) => currentState.maybeWhen(
          isFailure: (failure) => failure,
          orElse: () => null,
        ),
      ),
      ((previous, next) {
        if (next != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                next.when(
                  createListFailure: () =>
                      tr('list_page.list_error.create_list_failure'),
                  joinListFailure: () =>
                      tr("list_page.list_error.join_list_failure"),
                  deleteListFailure: () =>
                      tr("list_page.list_error.delete_list_failure"),
                  exitListFailure: () =>
                      tr("list_page.list_error.exit_list_failure"),
                ),
              ),
            ),
          );
        }
      }),
    );

    return ref.watch(listControllerProvider).maybeWhen(
          isLoading: () => DefaultListPageView(
            title: title,
            child: const CircularProgressIndicator(),
          ),
          isSuccess: (user) => LoadedListPageView(
            user: user,
            title: title,
          ),
          orElse: () => DefaultListPageView(
            title: title,
            child: Container(),
          ),
        );
  }
}
