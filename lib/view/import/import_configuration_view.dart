import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/account_record_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/home/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportConfigurationView extends StatefulWidget {
  final List<List<String>> productList;
  final List<String> rows;
  ImportConfigurationView({super.key, required this.productList, required this.rows});

  @override
  State<ImportConfigurationView> createState() => _ImportConfigurationViewState();
}

//  return {
//       'accId': accId,
//       'accName': accName,
//       'accComment': accComment,
//       'accType': accType,
//       'accCode': accCode,
//       'accVat': accVat,
//     };
class _ImportConfigurationViewState extends State<ImportConfigurationView> {
  Map<String, RecordType> typeMap = {"حسابات": RecordType.account, "منتجات": RecordType.product};
  Map configProduct = {
    "الاسم": "prodName",
    "رمز المادة": "prodCode",
    "السعر": "prodPrice",
    "الباركود": "prodBarcode",
    "رمز المجموعة": "prodGroupCode",
  };

  Map configAccount = {
    "الاسم": "accName",
    "بيان الحساب": "accComment",
    "النوع": "accType",
    "رمز الحساب": "accCode",
  };

  Map config = {};
  Map setting = {};

  RecordType? type;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<RecordType>(
                  value: type,
                  items: typeMap.keys.map((e) => DropdownMenuItem(value: typeMap[e], child: Text(e.toString()))).toList(),
                  onChanged: (_) {
                    type = _;
                    if (_ == RecordType.product) {
                      config = configProduct;
                    } else if (_ == RecordType.account) {
                      config = configAccount;
                    }
                    setState(() {});
                  }),
              SizedBox(
                width: 20,
              ),
              Text("النوع"),
            ],
          ),
          if (type != null)
            SizedBox(
                height: 220,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: List.generate(
                      config.keys.toList().length,
                      (index) => SizedBox(
                            height: 120,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(config.keys.toList()[index]),
                                Text("||"),
                                Text("V"),
                                SizedBox(
                                  width: 100,
                                  height: 30,
                                  child: DropdownButton<int>(
                                      value: setting[config.values.toList()[index]],
                                      items: widget.rows
                                          .map((e) => DropdownMenuItem(
                                                value: widget.rows.indexOf(e!),
                                                child: Text(e.toString()),
                                              ))
                                          .toList(),
                                      onChanged: (_) {
                                        // print(widget.rows.indexOf(_!));
                                        setting[config.values.toList()[index]] = _;
                                        print(setting);
                                        setState(() {});
                                      }),
                                )
                              ],
                            ),
                          )),
                )),
          ElevatedButton(
              onPressed: () async {
                if (type == RecordType.product) {
                  await addProduct();
                } else if (type == RecordType.account) {
                  await addAccount();
                }
                Get.offAll(() => HomeView());
              },
              child: Text("ending")),
          SizedBox(
            height: 70,
          ),
          Text("مثال"),
          SizedBox(
            height: 70,
          ),
          SizedBox(
              height: 80,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(
                    widget.rows.length,
                    (index) => Column(
                          children: [Text(widget.rows[index]), Text(widget.productList[0][index])],
                        )),
              ))
        ],
      ),
    );
  }

  Future<void> addProduct() async {
    List<ProductModel> finalData = [];
    for (var element in widget.productList) {
      finalData.add(ProductModel(
        prodId: generateId(RecordType.product),
        prodName: element[setting["prodName"]],
        prodCode: element[setting["prodCode"]],
        prodBarcode: element[setting["prodBarcode"]],
        prodGroupCode: element[setting["prodGroupCode"]],
        prodPrice: element[setting["prodPrice"]],
        prodHasVat: true,
      ));
    }
    print(finalData.map((e) => e.toJson()));
    for (var element in finalData) {
      await FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).set(element.toJson());
    }
  }

  Future<void> addAccount() async {
    List<AccountModel> finalData = [];
    for (var element in widget.productList) {
      finalData.add(AccountModel(
        accId: generateId(RecordType.account),
        accName: element[setting["accName"]],
        accCode: element[setting["accCode"]],
        accComment: element[setting["accComment"]],
        accType: element[setting["accType"]],
        accVat: "GCC",
      ));
    }
    print(finalData.map((e) => e.toJson()));
    for (var element in finalData) {
      await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accId).set(element.toJson());
    }
  }
}
