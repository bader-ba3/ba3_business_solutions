import 'package:ba3_business_solutions/view/import/pages/import_configuration_view.dart';
import 'package:ba3_business_solutions/view/import/widget/preview_view_data_grid_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../core/shared/widgets/grid_column_item.dart';

class PreviewView extends StatefulWidget {
  final List<List<String>> productList;
  final List<String> rows;

  const PreviewView({super.key, required this.productList, required this.rows});

  @override
  State<PreviewView> createState() => _PreviewViewState();
}

class _PreviewViewState extends State<PreviewView> {
  List<DateTime>? dateRange;
  PreViewViewDataGridSource? recordViewDataSource;

  @override
  void initState() {
    super.initState();
    recordViewDataSource = PreViewViewDataGridSource(productList: widget.productList, rows: widget.rows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            ElevatedButton(
                onPressed: () {
                  List<List<String>> data =
                      recordViewDataSource!.dataGridRows.map((e) => e.getCells().map((e) => e.value.toString()).toList()).toList();
                  Get.to(() => ImportConfigurationView(
                        rows: widget.rows,
                        productList: data,
                      ));
                },
                child: const Text("next"))
          ],
        ),
        body: widget.productList.isEmpty
            ? const Center(
                child: Text("no data"),
              )
            : SfDataGrid(
                columns: List.generate(
                  widget.rows.length,
                  (index) => gridColumnItem(
                    label: widget.rows[index],
                    name: widget.rows[index],
                  ),
                ),
                source: recordViewDataSource!,
                allowEditing: true,
                rowHeight: 75,
                headerRowHeight: 60,
                selectionMode: SelectionMode.single,
                editingGestureType: EditingGestureType.tap,
                navigationMode: GridNavigationMode.cell,
                columnWidthMode: ColumnWidthMode.fill,
              ));
  }
}
