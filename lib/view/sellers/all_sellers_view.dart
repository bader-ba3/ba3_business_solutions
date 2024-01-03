import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/model/seller_model.dart';
import 'package:ba3_business_solutions/view/sellers/add_seller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'all_seller_invoice_view.dart';

class AllSellers extends StatelessWidget {
  const AllSellers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                Get.to(() => AddSeller());
              },
              child: Text("add New"))
        ],
      ),
      body: GetBuilder<SellersViewModel>(builder: (controller) {
        return controller.allSellers.isEmpty
            ? CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: controller.allSellers.values.length,
                    itemBuilder: (context, index) {
                      SellerModel model = controller.allSellers.values.toList()[index];
                      return InkWell(
                          onTap: () {
                            Get.to(() => AllSellerInvoice(oldKey: model.sellerId));
                            // Get.to(() => AddSeller(oldKey: model.sellerId));
                          },
                          child: Text(model.sellerName ?? "error"));
                    }),
              );
      }),
    );
  }
}
