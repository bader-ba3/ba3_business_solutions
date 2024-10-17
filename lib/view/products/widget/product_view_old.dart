import 'package:ba3_business_solutions/core/utils/logger.dart';
import 'package:ba3_business_solutions/view/products/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/product/product_controller.dart';
import '../../../core/shared/widgets/sliver_list_widget.dart';
import '../../../data/model/product/product_model.dart';

class AllProductOLD extends StatelessWidget {
  const AllProductOLD({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<ProductController>(builder: (controller) {
          return SliverListWidget<ProductModel>(
            header: "المواد",
            hintText: "البحث عن منتج",
            allElement: controller.productDataMap.values.toList().where((element) => !element.prodIsGroup!).toList(),
            childBuilder: (BuildContext context, item, int index) {
              return _prodItemWidget(item, controller);
            },
            where: (item, String search) {
              return item.prodName!.toLowerCase().contains(search.toLowerCase()) || item.prodFullCode!.toLowerCase().contains(search.toLowerCase());
            },
          );
        }),
      ),
    );
  }

  Widget _prodItemWidget(ProductModel model, controller) {
    // PrintViewModel printViewModel = Get.find<PrintViewModel>();
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => ProductDetailsPage(
                oldKey: model.prodId,
              ));
        },
        child: Row(
          children: [
            SizedBox(
                width: 150,
                child: Text(
                  model.prodFullCode.toString(),
                  style: const TextStyle(fontSize: 20),
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Text(
              model.prodName!,
              style: const TextStyle(fontSize: 20),
            )),
            const SizedBox(
              width: 30,
            ),
            const Text("النوع: "),
            Text(
              model.prodIsLocal! ? "LOCAL" : "FREE",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
