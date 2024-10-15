import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'custom_product_view.dart';

class ProductManagementPage extends StatelessWidget {
  const ProductManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<ProductController>(initState: (state) {
        Get.find<ProductController>().initAllProduct();
        print("object");
      }, builder: (logic) {
        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              item("المباع خلال شهر", () {}),
              item("المباع خلال ٦ اشهر", () {}),
              item("المباع خلال سنة", () {}),
              item("لم يباع ابدا", () {
                Get.to(() => const CustomProductView(nunSell: true));
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.all(30.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            )),
      ),
    );
  }
}
