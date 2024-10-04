import 'package:ba3_business_solutions/controller/inventory/inventory_view_model.dart';
import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/store/store_view_model.dart';
import 'package:ba3_business_solutions/model/inventory/inventory_model.dart';
import 'package:ba3_business_solutions/model/product/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '../../../controller/seller/sellers_view_model.dart';

class AddInventoryView extends StatefulWidget {
  final InventoryModel inventoryModel;

  const AddInventoryView({super.key, required this.inventoryModel});

  @override
  State<AddInventoryView> createState() => _AddInventoryViewState();
}

class _AddInventoryViewState extends State<AddInventoryView> {
  List<ProductModel> prodList = [];
  TextEditingController searchController = TextEditingController();
  bool isNotFound = false;
  late InventoryModel inventoryModel;

  @override
  void initState() {
    inventoryModel = widget.inventoryModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<InventoryViewModel>(
      builder: (controller) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(),
            body: Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              child: Column(
                children: [
                  /*         SizedBox(
                    width: double.infinity,
                    height: 75,
                    child: TextFormField(
                      autofocus: true,
                      controller: searchController,
                      decoration: const InputDecoration(hintText: "أدخل اسم المنتج للبحث"),
                      onFieldSubmitted: (_) {
                        prodList = controller.getProduct(_,inventoryModel.inventoryTargetedProductList);
                        controller.update();
                        searchController.clear();
                        isNotFound = prodList.isEmpty;
                      },
                    ),
                  ),*/
                  // if (prodList.isNotEmpty)
                  Expanded(
                    child: GetBuilder<ProductViewModel>(
                      builder: (productController) {
                        return ListView.builder(
                            itemCount: inventoryModel
                                .inventoryTargetedProductList.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              ProductModel model = getProductModelFromId(
                                  inventoryModel
                                      .inventoryTargetedProductList.keys
                                      .toList()[index])!;

                              int count =
                                  productController.getCountOfProduct(model);
                              Map<String, int> storeMap = {};
                              model.prodRecord?.forEach((element) {
                                if (storeMap[element.prodRecStore] == null) {
                                  storeMap[element.prodRecStore!] = 0;
                                }
                                storeMap[element.prodRecStore!] =
                                    int.parse(element.prodRecQuantity!) +
                                        storeMap[element.prodRecStore!]!;
                              });
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Text("المسؤول عن جرد المادة:"),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: Text(
                                          getSellerNameFromId(inventoryModel
                                                  .inventoryTargetedProductList
                                                  .values
                                                  .toList()[index])
                                              .toString(),
                                          style: const TextStyle(fontSize: 18),
                                        )),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                      ],
                                    ),
                                    Container(
                                        color: Colors.grey.withOpacity(0.25),
                                        height: 75,
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const Text("الاسم:"),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Text(
                                              model.prodName.toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            )),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            const Text("الكمية الحقيقية:"),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              count.toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            const Text(
                                                "الكمية المدخلة في هذا الجرد:"),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              (inventoryModel.inventoryRecord[
                                                          model.prodId!] ??
                                                      "0")
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 18),
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  Get.defaultDialog(
                                                      title:
                                                          "رؤية التوزع في المستودعات",
                                                      content: SizedBox(
                                                        width:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width /
                                                                4,
                                                        height:
                                                            MediaQuery.sizeOf(
                                                                        context)
                                                                    .width /
                                                                4,
                                                        child: ListView.builder(
                                                          itemCount:
                                                              storeMap.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            MapEntry model =
                                                                storeMap.entries
                                                                        .toList()[
                                                                    index];
                                                            return Row(
                                                              children: [
                                                                Text(model.value
                                                                    .toString()),
                                                                const Spacer(),
                                                                Text(getStoreNameFromId(
                                                                    model.key)),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ));
                                                },
                                                child: const Text(
                                                    "رؤية التوزع في المستودعات")),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            ElevatedButton(
                                                onPressed: () async {
                                                  TextEditingController
                                                      textController =
                                                      TextEditingController();
                                                  String? a =
                                                      await Get.defaultDialog(
                                                          title: "ادخل العدد",
                                                          content: Column(
                                                            children: [
                                                              TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .digitsOnly
                                                                ],
                                                                controller:
                                                                    textController,
                                                              ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              ElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    return Get.back(
                                                                        result:
                                                                            textController.text);
                                                                  },
                                                                  child: const Text(
                                                                      "موافق"))
                                                            ],
                                                          ));
                                                  if (a != null &&
                                                      a.isNotEmpty) {
                                                    inventoryModel
                                                            .inventoryRecord[
                                                        model
                                                            .prodId!] = a
                                                        .toString();
                                                    inventoryModel
                                                            .inventoryRecord[
                                                        model
                                                            .prodId!] = a
                                                        .toString();
                                                    // setState(() {});
                                                    FirebaseFirestore.instance
                                                        .collection(AppStrings
                                                            .inventoryCollection)
                                                        .doc(inventoryModel
                                                            .inventoryId)
                                                        .set(
                                                            inventoryModel
                                                                .toJson(),
                                                            SetOptions(
                                                                merge: true));
                                                  }
                                                },
                                                child:
                                                    const Text("كتابة الكمية")),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            if (inventoryModel.inventoryRecord[
                                                    model.prodId!] !=
                                                null)
                                              const Icon(Icons.check)
                                            else
                                              const SizedBox(
                                                width: 25,
                                              ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  )
                  // else
                  //   Expanded(
                  //       child: Center(
                  //     child: Text(isNotFound ? "لم يتم العثور على المنتج" : "ابحث عن المنتج المطلوب "),
                  //   )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
