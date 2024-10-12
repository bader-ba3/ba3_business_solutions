import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/product/product_model.dart';
import 'custom_product_view.dart';

class ProductManagementView extends StatelessWidget {
  const ProductManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    ProductViewModel productViewModel = Get.find<ProductViewModel>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<ProductViewModel>(

          initState: (state) {

            Get.find<ProductViewModel>().initAllProduct();
            print("object");
          },
          builder: (logic) {

        return Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Item("المباع خلال شهر", () {}),
              Item("المباع خلال ٦ اشهر", () {}),
              Item("المباع خلال سنة", () {}),
              Item("لم يباع ابدا", () {



                Get.to(()=>const CustomProductView(nunSell: true,));
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget Item(text, onTap) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20)),
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
