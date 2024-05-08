import 'dart:io';
import 'package:ba3_business_solutions/old_model/global_model.dart';
import 'package:ba3_business_solutions/utils/realm.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ba3_business_solutions/old_model/product_record_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fancy_tree_view/flutter_fancy_tree_view.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';
import '../Const/const.dart';
import '../model/products_model.dart';
import '../old_model/invoice_record_model.dart';
import '../old_model/product_model.dart';
import '../old_model/product_tree.dart';
import '../utils/logger.dart';
import '../view/products/widget/product_record_data_source.dart';

class ProductViewModel extends GetxController {
  // RxMap<String, List<ProductRecordModel>> productRecordMap = <String, List<ProductRecordModel>>{}.obs;
  RxMap<String, ProductModel> productDataMap = <String, ProductModel>{}.obs;
  late ProductRecordDataSource recordDataSource;

  ProductModel? productModel;

  ProductViewModel() {
    getAllProduct();
  }



  void initGlobalProduct(GlobalModel globalModel) {
   // Future<void> saveInvInProduct(List<InvoiceRecordModel> record, invId, type,date) async {
      Map<String, List> allRecTotal = {};
      bool isPay = globalModel.invType == "pay";
      int correctQuantity = isPay ? 1 : -1;
      for (int i = 0; i < globalModel.invRecords!.length; i++) {
        if (globalModel.invRecords![i].invRecId != null) {
          if (allRecTotal[globalModel.invRecords![i].invRecProduct] == null) {
            allRecTotal[globalModel.invRecords![i].invRecProduct!] = [(correctQuantity * globalModel.invRecords![i].invRecQuantity!)];
          } else {
            allRecTotal[globalModel.invRecords![i].invRecProduct]!.add((correctQuantity * globalModel.invRecords![i].invRecQuantity!));
          }
        }
      }
      allRecTotal.forEach((key, value) {
        var recCredit = value.reduce((value, element) => value + element);
        bool isStoreProduct = productDataMap[key]!.prodType == Const.productTypeStore;
        InvoiceRecordModel element = globalModel.invRecords!.firstWhere((element) => element.invRecProduct == key);
        // FirebaseFirestore.instance.collection(Const.productsCollection).doc(key).collection(Const.recordCollection).doc(globalModel.invId).set(); //prodRecSubVat
        if(productDataMap[key]?.prodRecord==null){
          productDataMap[key]?.prodRecord=[ProductRecordModel(
              globalModel.invId,
              globalModel.invType,
              key,
              (isStoreProduct ? recCredit : "0").toString(),
              element.invRecId,
              element.invRecTotal.toString(),
              element.invRecSubTotal.toString(),
              globalModel.invDate,
              element.invRecVat.toString()
          )];
        }else{
          productDataMap[key]?.prodRecord?.removeWhere((element) => element.invId==globalModel.invId);
          productDataMap[key]?.prodRecord?.add(ProductRecordModel(
              globalModel.invId,
              globalModel.invType,
              key,
              (isStoreProduct ? recCredit : "0").toString(),
              element.invRecId,
              element.invRecTotal.toString(),
              element.invRecSubTotal.toString(),
              globalModel.invDate,
              element.invRecVat.toString()
          ));
        }
        WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
          update();
          initModel();
          initPage();
          go(lastIndex);
        });
      });
  }

  void deleteGlobalProduct(GlobalModel globalModel){
    globalModel.invRecords?.forEach((element) {
      productDataMap[element.invRecProduct]?.prodRecord?.removeWhere((element) => element.invId==globalModel.invId);
    });
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      update();
      initModel();
      initPage();
      go(lastIndex);
    });
  }

  void getAllProduct() async {
    FirebaseFirestore.instance.collection(Const.productsCollection).snapshots().listen((value) async {
      RxMap<String, ProductModel> oldProductDataMap = <String, ProductModel>{}.obs;
      productDataMap.forEach((key, value) {
        oldProductDataMap[key]=ProductModel.fromJson(value.toFullJson());
      });
      productDataMap.clear();
      for (var element in value.docs) {
        productDataMap[element.id] = ProductModel.fromJson(element.data());
        productDataMap[element.id]?.prodRecord=oldProductDataMap[element.id]?.prodRecord??[];
      }

      WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
        update();
        initModel();
        initPage();
        go(lastIndex);
      });
    });
  }

  String getNextProductCode() {
    int code = 0;
    if(productDataMap.isEmpty){
      return "00";
    }
    return code.toString();
  }

  int padNumber = 1;

 String getFullCodeOfProduct(String accID){
   if(productDataMap[accID]!.prodIsParent!){

     String code = productDataMap[accID]!.prodCode!.padLeft(padNumber,"0");
     return code;
   }else{
    int? pad =  productDataMap[productDataMap[accID]!.prodParentId!]!.prodGroupPad;
     String code = productDataMap[accID]!.prodCode!.padLeft(pad??padNumber,"0");
     var perCode= getFullCodeOfProduct(productDataMap[accID]!.prodParentId!);
     return perCode+code;
   }
  }

  void createProduct(ProductModel editProductModel, {withLogger = false}) async{
   print(editProductModel.prodCode);
   var fullCode='';
   if(editProductModel.prodParentId==null){
     fullCode=editProductModel.prodCode!;
   }else{
     fullCode=productDataMap[editProductModel.prodParentId]!.prodFullCode!+editProductModel.prodCode!.padLeft(productDataMap[editProductModel.prodParentId]!.prodGroupPad??padNumber,"0");
   }
   ProductModel? productModel = productDataMap.values.toList().firstWhereOrNull((element) => element.prodFullCode == fullCode);
   if(productModel!=null){
     Get.snackbar("فحص المطاييح", "هذا المطيح مستخدم من قبل");
     return;
   }
     print(fullCode);
      editProductModel.prodFullCode = fullCode;
      editProductModel.prodId = generateId(RecordType.product);
      editProductModel.prodIsGroup ??= false;
      if(editProductModel.prodParentId==null){
        editProductModel.prodIsParent=true;
      }else{
        FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodParentId).update({
          'prodChild': FieldValue.arrayUnion([editProductModel.prodId]),
        });
        editProductModel.prodIsParent=false;
      }
      if (withLogger) logger(newData: editProductModel);
      await FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodId).set(editProductModel.toJson());
      Get.snackbar("فحص المطاييح", ' تم اضافة المطيح');

  }

  void updateProduct(ProductModel editProductModel, {withLogger = false}) {
    print(editProductModel.prodCode);
    var fullCode='';
    if(editProductModel.prodParentId==null){
      fullCode=editProductModel.prodCode!;
    }else{
      fullCode=productDataMap[editProductModel.prodParentId]!.prodFullCode!+editProductModel.prodCode!.padLeft(productDataMap[editProductModel.prodParentId]!.prodGroupPad??padNumber,"0");
    }
    ProductModel? productModel = productDataMap.values.toList().firstWhereOrNull((element) => element.prodFullCode == fullCode);
    if(productModel!=null){
      Get.snackbar("فحص المطاييح", "هذا المطيح مستخدم من قبل");
      return;
    }
    print(fullCode);
    editProductModel.prodFullCode = fullCode;
    if (withLogger) logger(oldData: productDataMap[editProductModel.prodId], newData: editProductModel);
    editProductModel.prodIsGroup ??= false;
    if(editProductModel.prodParentId==null){
      editProductModel.prodIsParent=true;
    }else{
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodParentId).update({
        'prodChild': FieldValue.arrayUnion([editProductModel.prodId]),
      });
      editProductModel.prodIsParent=false;
    }
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(editProductModel.prodId).update(editProductModel.toJson());
    update();
  }

  int getCountOfProduct(ProductModel productModel){
    List<ProductRecordModel> allRec=[];

    allRec.addAll(productModel.prodRecord??[]);
    productModel.prodChild?.forEach((element) {
      allRec.addAll(productDataMap[element]?.prodRecord??[]);
    });
    if(allRec.isEmpty)return 0;
    int _ = allRec.map((e) => int.parse(e.prodRecQuantity!)).toList().reduce((value, element) => value+element);
    return _;
  }

  Future<void> deleteProduct({withLogger = false}) async {
    if (withLogger) logger(oldData: productModel);
    if (productModel?.prodParentId != null) {
      await FirebaseFirestore.instance.collection(Const.productsCollection).doc(productModel!.prodParentId).update({
        'prodChild': FieldValue.arrayRemove([productModel!.prodId]),
      });
    }
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(productModel?.prodId).delete();
    productModel == null;

    update();
  }


  void initProductPage(ProductModel editedProduct) {
    recordDataSource = ProductRecordDataSource(productModel: editedProduct);
  }

  String searchProductIdByName(name) {
    return productDataMap.values.toList().firstWhere((element) => element.prodName == name).prodId!;
  }



  //--=-=-==-==--=-=-=-==-==-=-=-=-=-=-=-=-=-=-=-=-=--=-=-==-=-=--=-

  String? editItem;
  TextEditingController? editCon;

  String? lastIndex;

  List<ProductTree> allProductTree = [];

  TreeController<ProductTree>? treeController;

  void initModel() {
    allProductTree.clear();
    List<ProductModel> rootList = productDataMap.values.toList().where((element) => element.prodIsParent ?? false).toList();
    for (var element in rootList) {
      allProductTree.add(addToModel(element));
    }
  }

  ProductTree addToModel(ProductModel element) {
    var list = element.prodChild?.map((e) => addToModel(productDataMap[e]!)).toList();
    // if(list!.length>99){
    //   padNumber=2;
    // }
    productDataMap[element.prodId]?.prodFullCode=getFullCodeOfProduct(element.prodId!);
    ProductTree model = ProductTree.fromJson({"name": element.prodName}, element.prodId, list??[]);
    return model;
  }

  initPage() {
    treeController = TreeController<ProductTree>(
      roots: allProductTree,
      childrenProvider: (ProductTree node) => node.list,
    );
    update();
  }

  void setupParentList(String parent) {
    allPer.add(productDataMap[parent]!.prodId);
    if (productDataMap[parent]!.prodParentId != null) {
      setupParentList(productDataMap[parent]!.prodParentId!);
    }
  }


  var allPer = [];
  void go(String? parent) {
    if (parent != null) {
      allPer.clear();
      setupParentList(parent);
      var allper = allPer.reversed.toList();
      List<ProductTree> _ = treeController!.roots.toList();
      for (var i = 0; i < allper.length; i++) {
        if (_.isNotEmpty) {
          treeController?.expand(_.firstWhere((element) => element.id == allper[i]));
          _ = _.firstWhereOrNull((element) => element.id == allper[i])?.list ?? [];
        }
      }
    }
  }
  void startRenameChild(String? id) {
    editItem = id;
    editCon = TextEditingController(text: productDataMap[id]!.prodName!);
    update();
  }

  void endRenameChild() {
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(editItem).update({
      "prodName": editCon?.text,
    });
    editItem = null;
    update();
  }
  
  Future<void> exportProduct(String? oldKey) async {
    List<List> data=[["اسم المادة","الفاتورة","العدد","التاريخ"]];
    List<ProductRecordModel> allRec=[];
    ProductModel _= productDataMap[oldKey]!;
    allRec.addAll(_.prodRecord??[]);
    _.prodChild?.forEach((element) {
      allRec.addAll(productDataMap[element]?.prodRecord??[]);
    });
    allRec.forEach((ProductRecordModel value) {
      data.add([getProductNameFromId(value.prodRecProduct),value.prodType,value.prodRecQuantity,value.prodRecDate]);
    });
    String csv = const ListToCsvConverter().convert(data);
    String? saveData;
    if(defaultTargetPlatform!=TargetPlatform.iOS){
      saveData= await FilePicker.platform.saveFile(
          fileName:getProductNameFromId(oldKey)+" "+DateTime.now().toString().split(" ")[0]+".csv"
      );
    }else{
      Directory documents = await getApplicationDocumentsDirectory();
      saveData = (documents.path+"/"+getProductNameFromId(oldKey)+" "+DateTime.now().toString().split(" ")[0]+".csv");
    }

    if(saveData!=null){
      File file = File(saveData);
      file.writeAsString(csv).then((File file) {
        print('CSV file created: ${file.absolute.path}');
      }).catchError((e) {
        print('Error: $e');
      });
    }

  }

  void createFolderDialog() {
    var nameCon =TextEditingController();
    String? prodParentId ;
    String? rootName ;
    List<String> rootFolder = productDataMap.values.toList().where((element) => element.prodIsParent!&&element.prodIsGroup!).map((e) => e.prodId!).toList();
    Map<String ,List<String>> allParent = {};
    Map<String ,String> dropDownList = {};
    Get.defaultDialog(
      title: "اختر الطريق",
      content: SizedBox(
        height: Get.height/2,
        width:Get.height/2,
        child: StatefulBuilder(
          builder: (context,setstate) {
            return ListView(
              children: [
                SizedBox(
                  height: 35,
                  width: double.infinity,
                  child: TextFormField(controller: nameCon,),
                ),
                SizedBox(height: 10,),
                DropdownButton(
                    value: rootName,
                    items: rootFolder.map((e) => DropdownMenuItem(value: e,child: Text(getProductNameFromId(e)))).toList(), onChanged: (_){
                  prodParentId=_;
                  rootName = _;
                  Iterable<ProductModel> a = productDataMap.values.toList().where((element) => element.prodParentId==_&&element.prodIsGroup!);
                  if(a.isNotEmpty){
                    allParent[_!] = a.toList().map((e) => e.prodId!).toList();
                  }
                  setstate((){});
                }),
                for(List<String> element in allParent.values)
                  DropdownButton(
                    value: dropDownList[element.toString()],
                      items: element.map((e) => DropdownMenuItem(value: e,child: Text(getProductNameFromId(e)))).toList(), onChanged: (_){
                    prodParentId=_;
                    dropDownList[element.toString()]=_!;
                    Iterable<ProductModel> a = productDataMap.values.toList().where((element) => element.prodParentId==_&&element.prodIsGroup!);
                    if(a.isNotEmpty){
                      allParent[_!] = a.toList().map((e) => e.prodId!).toList();
                    }
                    setstate((){});
                  }),
              ],
            );
          }
        ),
      ),actions: [
      ElevatedButton(onPressed: (){
        addFolder(nameCon.text,prodParentId: prodParentId);
        Get.back();}, child: Text("إضافة")),
      ElevatedButton(onPressed: (){Get.back();}, child: Text("إلغاء")),
    ]
    );
  }

  void addFolder(name,{String? prodParentId}) {
    int code = 0;
    if(prodParentId==null){
      code = productDataMap.values.toList().where((element) => element.prodIsParent!).map((e) => int.parse(e.prodCode!)).toList().last+1;
    }else{
      Iterable<ProductModel> a = productDataMap.values.toList().where((element) => element.prodParentId==prodParentId);
      if(a.isNotEmpty){
        code = a.map((e) => int.parse(e.prodCode!)).toList().last+1;
      }
    }
    var prodModel = ProductModel(
      prodIsGroup: true,
      prodIsParent: prodParentId==null,
      prodParentId: prodParentId,
      prodName: name,
      prodCode: code.toString(),
      prodId: generateId(RecordType.product)
    );
    if(prodParentId!=null){
      FirebaseFirestore.instance.collection(Const.productsCollection).doc(prodParentId).update({
        'prodChild': FieldValue.arrayUnion([prodModel.prodId]),
      });
    }
    FirebaseFirestore.instance.collection(Const.productsCollection).doc(prodModel.prodId).set(prodModel.toJson());

  }

}

String getProductIdFromFullName(name) {
  if (name != null && name != " " && name != "") {
    return Get.find<ProductViewModel>().productDataMap.values.toList().cast<ProductModel?>().firstWhereOrNull((element) =>element?.prodFullCode==name)?.prodId??"";
  } else {
    return "";
  }}
String getProductIdFromName(name) {
  if (name != null && name != " " && name != "") {
    return Get.find<ProductViewModel>().productDataMap.values.toList().cast<ProductModel?>().firstWhereOrNull((element) => element?.prodName==name||element?.prodCode==name)?.prodId??"";
  } else {
    return "";
  }}
String getProductNameFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<ProductViewModel>().productDataMap[id]!.prodName!;
  } else {
    return "";
  }}
ProductModel? getProductModelFromId(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<ProductViewModel>().productDataMap[id]!;
  } else {
    return null;
  }}
