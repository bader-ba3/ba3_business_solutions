import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:ba3_business_solutions/view/products/widget/add_product.dart';
import 'package:ba3_business_solutions/view/products/widget/product_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/product_model.dart';

class AllProduct extends StatelessWidget {
  const AllProduct({super.key});

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
        body: GetBuilder<ProductViewModel>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView.builder(
                itemCount: controller.productDataMap.values.length,
                itemBuilder: (context, index) {
                  ProductModel model = controller.productDataMap.values.toList()[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      onTap: () {
                        logger(newData: model, transfersType: TransfersType.read);
                        Get.to(() => ProductDetails(
                              oldKey: model.prodId,
                            ));
                      },
                      child: Row(
                        children: [

                          Text(model.prodCode ?? "0",style: TextStyle(fontSize: 20),),
                          Text(" - ",style: TextStyle(fontSize: 20),),
                       //   Text(model.prodId ?? "not found"),
                          Text(model.prodName ?? "not found",style: TextStyle(fontSize: 20),),
                          SizedBox(width: 20,),
                          Text("الكمية: "),
                          Text(model.prodAllQuantity ?? "0",style: TextStyle(fontSize: 20),),
                        ],
                      ),
                    ),
                  );
                }),
          );
        }),
      ),
    );
  }
}
