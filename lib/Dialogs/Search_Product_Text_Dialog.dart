import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Widgets/new_Pluto.dart';
import '../../controller/product_view_model.dart';
import '../view/invoices/widget/custom_TextField.dart';

Future<String> searchProductTextDialog(String productText)async {

  TextEditingController productTextController=TextEditingController()..text=productText;
  List<ProductModel> productsForSearch;
  await showDialog<String>(
      context: Get.context!,
      builder: (BuildContext context) => Dialog(
        child: GetBuilder<ProductViewModel>(builder: (productViewModel) {
          productsForSearch=productViewModel.searchOfProductByText(productTextController.text);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    height: Get.height / 1.5,
                    child: ClipRRect(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(15),
                      child: CustomPlutoGrid(
                        onSelected: (selected) {
                          productTextController.text=getProductNameFromId(selected.row?.cells["الرقم التسلسلي"]!.value);
                          Get.back();
                        },
                        title: "اختيار مادة",
                        modelList: productsForSearch,
                        onLoaded: (p0) {},
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: customTextFieldWithIcon(productTextController, (_) async {
                    productViewModel.update();
                  }, onIconPressed: () {}),
                ),
                const SizedBox(
                  height: 10,
                ),

              ],
            ),
          );
        }),
      )



  );

  return productTextController.text;
}
