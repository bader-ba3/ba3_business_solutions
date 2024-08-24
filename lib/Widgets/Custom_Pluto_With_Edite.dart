import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'CustomPlutoGridStyleConfig.dart';


class CustomPlutoWithEdite extends StatelessWidget {
  const CustomPlutoWithEdite({Key? key,required this.controller, required this.shortCut, this.onChanged, required this.onRowSecondaryTap}) : super(key: key);

  final dynamic controller;
  final PlutoGridShortcut shortCut;
  final Function(PlutoGridOnChangedEvent)? onChanged;
  final Function(PlutoGridOnRowSecondaryTapEvent) onRowSecondaryTap;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: PlutoGrid(
        columns: controller.columns,
        rows: controller.rows,
        onRowSecondaryTap:onRowSecondaryTap,
        onChanged:onChanged,
        configuration: PlutoGridConfiguration(
          shortcut: shortCut,
          style:buildGridStyleConfig(),
          localeText: const PlutoGridLocaleText.arabic(),
        ),
        onLoaded: (PlutoGridOnLoadedEvent event) {
          controller.stateManager = event.stateManager;
          final newRows = controller.stateManager.getNewRows(count: 30);
          controller.stateManager.appendRows(newRows);
        },
      ),
    );
  }
}



