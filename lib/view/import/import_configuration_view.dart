import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImportConfigurationView extends StatefulWidget {
  final List<List<String>> productList;
  final List<String> rows;
  const ImportConfigurationView({super.key, required this.productList, required this.rows});

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
  'اسم المادة' :'prodName',
  'رمز المادة' :'prodCode',
  // 'اسم المجموعة' :'prodParentId',
  'سعر المستهلك' :'prodCustomerPrice',
  'سعر جملة' :'prodWholePrice',
  'سعر مفرق' :'prodRetailPrice',
  'سعر التكلفة' :'prodCostPrice',
  'اقل سعر مسموح' :'prodMinPrice',
  'باركود المادة' :'prodBarcode',
  'رمز المجموعة' :'prodParentId',
  'نوع المادة' :'prodType',
  };

  Map configAccount = {
    "الاسم": "accName",
    "رمز الحساب": "accCode",
  "اسم المجموعة" : 'accParentId',
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
          if (type == null)
            Expanded(child: SizedBox())
            else
              Expanded(
              child: SizedBox(
                  width: double.infinity,
                  child:Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // mainAxisSize: MainAxisSize.max,
                    children: List.generate(
                        config.keys.toList().length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                                height: 120,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(config.keys.toList()[index]),
                                    Text("| |"),
                                    Text(" V"),
                                    SizedBox(
                                      height: 30,
                                      width: 300,
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
                              ),
                        )),
                  )),
            ),
          ElevatedButton(
              onPressed: () async {
                if (type == RecordType.product) {
                  await addProduct();
                } else if (type == RecordType.account) {
                  await addAccount();
                }
                // Get.offAll(() => HomeView());
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
      //print(element[setting["prodName"]]);
      bool isGroup = !(element[setting['prodType']].removeAllWhitespace=="خدمية"||element[setting['prodType']].removeAllWhitespace=="مستودعية");
      var code = element[setting["prodCode"]].replaceAll(element[setting["prodParentId"]], "");
      var parentId = "F"+element[setting["prodParentId"]];
      var isRoot = element[setting["prodParentId"]].isBlank;
     // print("code "+code);
      String chechIsExist = isGroup ?getProductIdFromName("F-"+element[setting["prodName"]].replaceAll("- ", "")):getProductIdFromName("F-"+element[setting["prodName"]]);
      // print("parentId "+parentId);
      // print("FullCode "+element[setting["prodCode"]]);
      // print("isRoot "+isRoot.toString());
      // print(element[setting['prodType']].removeAllWhitespace);
      // print(element[setting['prodType']].removeAllWhitespace=="مستودعية");
      // print(!(element[setting['prodType']].removeAllWhitespace=="خدمية"||element[setting['prodType']].removeAllWhitespace=="مستودعية"));
      // print("===");
      if(chechIsExist=="") {
        finalData.add(ProductModel(
        prodId: generateId(RecordType.product),
        prodName: "F-"+element[setting["prodName"]],
        // prodCode: element[setting["prodCode"]],
          prodCode:  code,
        prodBarcode: element[setting["prodBarcode"]],
        // prodIsLocal: !element[setting["prodName"]].contains("مستعمل"),
        prodIsLocal: false,
        prodFullCode: "F"+element[setting["prodCode"]],
        // prodGroupCode: element[setting["prodGroupCode"]],
        //todo
        prodCustomerPrice : element[setting['prodCustomerPrice']],
        prodWholePrice : element[setting['prodWholePrice']],
        prodRetailPrice : element[setting['prodRetailPrice']],
        prodCostPrice : element[setting['prodCostPrice']],
        prodMinPrice : element[setting['prodMinPrice']],
       
        prodType : element[setting['prodType']].removeAllWhitespace=="خدمية"?Const.productTypeService:Const.productTypeStore,
        // prodParentId : element[setting['prodParentId']].isBlank!?null:parentId,
        // prodIsParent : element[setting['prodParentId']].isBlank,
        prodParentId :  parentId.isBlank!?null:parentId,
        prodIsParent :parentId.isBlank,
        prodIsGroup: isGroup
      ));
      }
    }
    var i = 0;

    print(finalData.length);
    print("--"*30);
    for(var i in finalData){
      if(i.prodIsGroup!){
      print(i.toFullJson());
      }
    }
    print("--"*30);
//  for(var i in finalData){
 
//       print(i.prodName!+"|  -  |"+i.prodFullCode!+"|  -  |"+i.prodId!+"|  |"+getProductIdFromFullName(i.prodParentId).toString());    
//     }

    /// FIX DUPLICATE ON PRODACT FULL CODE
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //  for(var a in finalData){
    //   if(getProductIdFromFullName(a.prodFullCode!)!=""){
    //    ProductModel _ = getProductModelFromId(getProductIdFromFullName(a.prodFullCode!))!;
    //  print(a.prodName!+"|  -  |"+a.prodFullCode!+"    "+_.prodName!);
    //   _.prodName  = a.prodName;
    //   print(a.prodName!+"|  -  |"+a.prodFullCode!+"    "+_.prodName!);
    //   await FirebaseFirestore.instance.collection(Const.productsCollection).doc(_.prodId).set(_.toJson());
    //   HiveDataBase.productModelBox.put(_.prodId, _);
    //   }
    // }
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    




    // ProductViewModel productViewModel = Get.find<ProductViewModel>();
    for (var element in finalData) {
     i++;
     print(i.toString() + " OF "+finalData.length.toString() );
     await FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).set(element.toJson());
     HiveDataBase.productModelBox.put(element.prodId, element);
    }
    // i = 0;
    // for (var index = 0 ;index < finalData.length; index ++ ) {
    //   ProductModel element = finalData[index];
    //   i++;
    //   print(i.toString() + " OF "+finalData.length.toString() );
    //   if(!element.prodIsParent!){
    //     FirebaseFirestore.instance.collection(Const.productsCollection).doc(getProductIdFromFullName(element.prodParentId)).update({
    //       'prodChild': FieldValue.arrayUnion([element.prodId]),
    //     });
    //    productViewModel.productDataMap[getProductIdFromFullName(element.prodParentId!)]!.prodChild?.add(element.prodId);
    //     HiveDataBase.productModelBox.put(getProductIdFromFullName(element.prodParentId!),  productViewModel.productDataMap[getProductIdFromFullName(element.prodParentId!)]!);
    //     FirebaseFirestore.instance.collection(Const.productsCollection).doc(element.prodId).update({
    //       "prodParentId":getProductIdFromFullName(element.prodParentId)
    //     });
    //     finalData[index].prodParentId = getProductIdFromFullName(element.prodParentId);
    //     HiveDataBase.productModelBox.put(index, finalData[index]);
    //    ProductModel prodParentId = getProductModelFromId(getProductIdFromFullName(element.prodParentId))!;
    //     // if(prodParentId.prodGroupPad==null){
    //     //   int pad= element.prodFullCode!.replaceAll(prodParentId.prodFullCode!, "").length;
    //     //   await FirebaseFirestore.instance.collection(Const.productsCollection).doc(prodParentId.prodId).update({
    //     //     "prodGroupPad":pad
    //     //   });
    //     // }
    //   }
    // }
  }

  Future<void> addAccount() async {
    AccountViewModel accountViewModel = Get.find<AccountViewModel>();
    List<AccountModel> finalData = [];
    for (var element in widget.productList) {
      bool accIsParent = element[setting['accParentId']].isEmpty;
        finalData.add(AccountModel(
        accId: generateId(RecordType.account),
        accName: "F-"+(element[setting["accName"]]).replaceAll("-",""),
        accCode: "F-"+element[setting["accCode"]].replaceAll("-",""),
        accComment: '',
        // accType: element[setting["accType"]]=="حساب تجميعي"?Const.accountTypeAggregateAccount:element[setting["accType"]]=="حساب ختامي"?Const.accountTypeFinalAccount:Const.accountTypeDefault,
        accType: Const.accountTypeDefault,
        accVat : 'GCC',
        accParentId : accIsParent?null:"F-"+element[setting['accParentId']],
         accIsParent: accIsParent,
      ));
    }
    int i =0;
    print(finalData.length);


  for (var element in finalData) {
       print("|"+element.accName!+"|" + element.accCode.toString());
    }
    for (var element in finalData) {
      i++;
      print(i.toString());
      // await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accId).set(element.toJson());
      // await accountViewModel.addNewAccount(element, withLogger: false);
       print(element.accId);
      element.accId = generateId(RecordType.account);
      print(element.accId);
      await FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accId).set(element.toJson());
      HiveDataBase.accountModelBox.put(element.accId, element);
    }
    // i=0;
    // for (var element in finalData) {
    //   i++;
    //   print(i.toString());
    //   if(!element.accIsParent! ||element.accParentId!=null){
    //     FirebaseFirestore.instance.collection(Const.accountsCollection).doc(getAccountIdFromText(element.accParentId)).update({
    //       'accChild': FieldValue.arrayUnion([element.accId]),
    //     });
    //     FirebaseFirestore.instance.collection(Const.accountsCollection).doc(element.accId).update({
    //       "accParentId":getAccountIdFromText(element.accParentId)
    //     });
    //   }
    // }
  }
}
