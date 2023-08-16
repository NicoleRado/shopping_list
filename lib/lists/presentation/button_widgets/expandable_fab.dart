import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../dialogs/add_list_dialog.dart';

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({super.key});

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  bool _isFabOpen = false;

  void _onOpen() {
    setState(() {
      _isFabOpen = true;
    });
  }

  void _onClose() {
    setState(() {
      _isFabOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: _isFabOpen ? Icons.close : Icons.format_list_bulleted_add,
      onOpen: _onOpen,
      onClose: _onClose,
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      spacing: 8,
      children: [
        SpeedDialChild(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: const Icon(Icons.add),
          label: tr('list_page.expandable_fab.add_list_label'),
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) =>
                const AddListDialog(isCreateList: true),
          ),
        ),
        SpeedDialChild(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: const Icon(Icons.join_inner_sharp),
          label: tr('list_page.expandable_fab.join_list_label'),
          onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) =>
                const AddListDialog(isCreateList: false),
          ),
        ),
      ],
    );
  }
}
