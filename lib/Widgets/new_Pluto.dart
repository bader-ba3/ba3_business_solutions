import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import 'Pluto_View_Model.dart';



class CustomPlutoGrid extends StatelessWidget {
  const CustomPlutoGrid({
    super.key,
    required this.onLoaded,
    required this.onSelected,
    required this.modelList,
    this.onRowDoubleTap,
    required this.title

  });
  final Function(PlutoGridOnLoadedEvent) onLoaded;
   final List<dynamic> modelList;
   final Function(PlutoGridOnRowDoubleTapEvent)? onRowDoubleTap;
  final Function(PlutoGridOnSelectedEvent) onSelected;

  final String title;

  @override
  Widget build(BuildContext context) {
        return Column(
          children: [
            WindowTitleBarBox(child: Container(
              color: Colors.white,
                child: MoveWindow())),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: GetBuilder<PlutoViewModel>(
                  builder: (controller) {
                    return Scaffold(
                      appBar: AppBar(
                        centerTitle: true,
                        title: Text(title),
                        actions: [
                          Padding(
                              padding:const EdgeInsets.all(8),
                              child: Text("عدد العناصر المتأثرة: ${modelList.isEmpty ? modelList.length.toString() : modelList.length.toString()}")),

                        ],
                      ),
                      body:
                           PlutoGrid(
                            key: controller.plutoKey,
                          onLoaded: onLoaded,
                            onSelected: onSelected,
                            columns: controller.getColumns(modelList),
                            rows:controller.getRows(modelList),
                            mode: PlutoGridMode.selectWithOneTap,
                            configuration: PlutoGridConfiguration(
                              shortcut: const PlutoGridShortcut(),
                              style: PlutoGridStyleConfig(
                                enableRowColorAnimation: true,
                                evenRowColor: Colors.blue.withOpacity(0.5),
                                columnTextStyle:const TextStyle(color: Colors.black,fontSize: 24,fontWeight: FontWeight.bold),
                                activatedColor: Colors.grey.withOpacity(0.5),
                                // gridBackgroundColor: Colors.transparent,
                                cellTextStyle: const TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold),
                                gridPopupBorderRadius: const BorderRadius.all(Radius.circular(15)),
                                gridBorderRadius: const BorderRadius.all(Radius.circular(15)),
                                // gridBorderColor: Colors.transparent,
                              ),
                              localeText: const PlutoGridLocaleText.arabic(),
                            ),
                            createFooter: (stateManager) {
                              stateManager.setPageSize(100, notify: false); // default 40
                              return PlutoPagination(stateManager);
                            },
                          ),
                        );


                  }
                ),
              ),
            ),
          ],
        );

  }
}
