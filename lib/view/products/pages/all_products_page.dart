import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:ba3_business_solutions/view/products/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/shared/Widgets/new_pluto.dart';

class AllProductsPage extends StatelessWidget {
  const AllProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ProductViewModel productViewModel = Get.find<ProductViewModel>();
    // RxMap<String, ProductModel> data = Map.fromEntries(productViewModel.productDataMap.entries.where((element) => !element.value.prodIsGroup!).toList()).obs;
    // RxMap<String, ProductModel> data = productViewModel.productDataMap;

    return GetBuilder<ProductController>(builder: (controller) {
      return CustomPlutoGridWithAppBar(
        title: "جميع المواد",
        type: '',
        onLoaded: (e) {},
        onSelected: (p0) {
          // Get.to(() => ProductDetails(
          //   oldKey: model.prodId,
          // ));
          Get.to(() => ProductDetailsPage(
                oldKey: p0.row?.cells["الرقم التسلسلي"]?.value,
              ));
        },
        modelList: controller.productDataMap.values.toList(),
      );
    });
/*    return Scaffold(
      body: FilteringDataGrid<ProductModel>(
        title: "مواد",
        constructor: ProductModel(),
        dataGridSource:data,
        onCellTap: (index,id,init) {
          ProductModel model = data[id]!;
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => ProductDetails(
            oldKey: model.prodId,
          ));
        },
        init: ()async {
          IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
          isolateViewModel.init();
          print("from product View");
          final a = await   compute<({IsolateViewModel isolateViewModel}),List<DataGridRow>>((message) {
            Get.put(message.isolateViewModel);
            List<DataGridRow> dataGridRow  = message.isolateViewModel.productDataMap.values.where((element) => !element.prodIsGroup!).toList()
                .map<DataGridRow>((order) => DataGridRow(cells: [
              DataGridCell(columnName: order.affectedKey()!, value: order.affectedId()),
              ...order
                  .toMap()
                  .entries
                  .map((mapEntry) {
                return DataGridCell<String>(columnName: mapEntry.key, value: mapEntry.value.toString());
              }).cast<DataGridCell<dynamic>>().toList()
            ])).toList();
            return dataGridRow;
          },(isolateViewModel:isolateViewModel));
          InfoDataGridSource  infoDataGridSource = InfoDataGridSource();
          infoDataGridSource.dataGridRows =a;
          return infoDataGridSource;

        },
      ),
    );*/
  }
}
