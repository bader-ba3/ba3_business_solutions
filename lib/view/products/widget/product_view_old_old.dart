import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:ba3_business_solutions/core/utils/logger.dart';
import 'package:ba3_business_solutions/view/products/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/product/product_model.dart';

class AllProductOLDOLD extends StatelessWidget {
  const AllProductOLDOLD({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            //     actions: [
            //   ElevatedButton(
            //       onPressed: () {
            //         Get.to(() => AddProduct());
            //       },
            //       child: const Text("create"))
            // ]
            ),
        body: GetBuilder<ProductController>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: ListView.builder(
                itemCount: controller.productDataMap.values
                    .where((element) => !element.prodIsGroup! && (HiveDataBase.isFree.get("isFree")! ? element.prodIsLocal! : true))
                    .toList()
                    .length,
                itemBuilder: (context, index) {
                  ProductModel model = controller.productDataMap.values
                      .toList()
                      .where((element) => !element.prodIsGroup! && (HiveDataBase.isFree.get("isFree")! ? element.prodIsLocal! : true))
                      .toList()[index];
                  return _prodItemWidget(model, controller);
                }),
          );
        }),
      ),
    );
  }

  Widget _prodItemWidget(ProductModel model, controller) {
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
                width: 100,
                child: Text(
                  controller.getFullCodeOfProduct(model.prodId!),
                  style: const TextStyle(fontSize: 20),
                )),
            const Text(
              " - ",
              style: TextStyle(fontSize: 20),
            ),
            //   Text(model.prodId ?? "not found"),
            Text(
              model.prodName ?? "not found",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(
              width: 20,
            ),
            const Text("الكمية: "),
            Text(
              model.prodFullCode.toString(),
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
