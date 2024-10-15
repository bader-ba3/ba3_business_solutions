import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_controller.dart';
import 'package:ba3_business_solutions/controller/store/store_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/databsae/import_controller.dart';
import '../../../model/global/global_model.dart';
import '../../../model/invoice/invoice_record_model.dart';

class InvoiceListView extends StatelessWidget {
  final List<GlobalModel> invoiceList;

  InvoiceListView({super.key, required this.invoiceList});

  final ImportController importViewModel = Get.find<ImportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                // if( importViewModel.checkAllAccount(invoiceList)){
                importViewModel.addInvoice(invoiceList);
                // }
              },
              child: const Text("add"))
        ],
      ),
      body: ListView.builder(
          itemCount: invoiceList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(invoiceList[index].bondId.toString()),
                      Text(invoiceList[index].invId.toString()),
                      Text("المجموع: ${invoiceList[index].invTotal}"),
                      Text("الوقت: ${invoiceList[index].invDate}"),
                      Text("البائع:  ${getSellerNameFromId(invoiceList[index].invSeller.toString())}"),
                      Text("المستودع: ${getStoreNameFromId(invoiceList[index].invStorehouse.toString())}"),
                      Text(
                          "من: ${invoiceList[index].invPrimaryAccount == null ? "لا يوجد" : getAccountNameFromId(invoiceList[index].invPrimaryAccount.toString())}"),
                      Text(
                          "الى: ${invoiceList[index].invSecondaryAccount == null ? "لا يوجد" : getAccountNameFromId(invoiceList[index].invSecondaryAccount.toString())}"),
                      Text(invoiceList[index].invType.toString()),
                      Text("الرمز: ${invoiceList[index].invCode}"),
                      Text("رقم السند: ${invoiceList[index].bondCode}"),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Container(height: 2,width: double.infinity,color: Colors.grey.shade300,),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                            width: 100,
                            child: Center(
                                child: Text(
                              "المجموع",
                              style: TextStyle(fontSize: 18),
                            ))),
                        SizedBox(
                          width: 52,
                        ),
                        SizedBox(
                            width: 120,
                            child: Center(
                                child: Text(
                              "اجمالي الضريبة",
                              style: TextStyle(fontSize: 18),
                            ))),
                        SizedBox(
                          width: 52,
                        ),
                        SizedBox(
                            width: 100,
                            child: Center(
                                child: Text(
                              "السعر الإفرادي",
                              style: TextStyle(fontSize: 18),
                            ))),
                        SizedBox(
                          width: 52,
                        ),
                        SizedBox(
                            width: 100,
                            child: Center(
                                child: Text(
                              "الكمية",
                              style: TextStyle(fontSize: 18),
                            ))),
                        SizedBox(
                          width: 52,
                        ),
                        Expanded(
                            child: Text(
                          "المادة",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 18),
                        )),
                        SizedBox(
                          width: 52,
                        ),
                        SizedBox(
                            width: 50,
                            child: Center(
                                child: Text(
                              "الرمز",
                              style: TextStyle(fontSize: 18),
                            ))),
                      ],
                    ),
                  ),
                  for (InvoiceRecordModel e in invoiceList[index].invRecords ?? [])
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 100, child: Center(child: Text(e.invRecTotal!.toStringAsFixed(2)))),
                          const SizedBox(
                            width: 25,
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(width: 120, child: Center(child: Text(e.invRecVat!.toStringAsFixed(2)))),
                          const SizedBox(
                            width: 25,
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(width: 100, child: Center(child: Text(e.invRecSubTotal!.toStringAsFixed(2)))),
                          const SizedBox(
                            width: 25,
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(width: 100, child: Center(child: Text("${e.invRecQuantity} "))),
                          const SizedBox(
                            width: 25,
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          Expanded(
                              child: Text(
                            getProductNameFromId(e.invRecProduct.toString()) + e.invRecProduct.toString(),
                            textDirection: TextDirection.rtl,
                          )),
                          const SizedBox(
                            width: 25,
                          ),
                          Container(
                            height: 30,
                            width: 2,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(
                            width: 25,
                          ),
                          SizedBox(width: 50, child: Center(child: Text(e.invRecId.toString()))),
                        ],
                      ),
                    ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
