import 'dart:io';
import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/Pattern_model.dart';
import 'package:ba3_business_solutions/model/invoice_record_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/loading/loading_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../model/bond_record_model.dart';
import '../model/global_model.dart';
import '../utils/hive.dart';
import '../view/import/bond_list_view.dart';
import '../view/import/invoice_list_view.dart';
import '../view/import/preview_list_view.dart';

class ImportViewModel extends GetxController {
  // ImportViewModel(){
  //   MongoDB.productCollection.find({"a":"bb"}).listen((event) {
  //     print(event);
  //   });
  // //
  // }


  bool checkAllAccount(List<GlobalModel> bondList) {
    List<String> finalList = [];
    for (var e in bondList) {
      e.bondRecord?.forEach((element) {
        if (element.bondRecAccount == "") {
          finalList.add(element.bondRecAccount!);
        }
      });
    }

    if (finalList.isEmpty) {
      return true;
    } else {
      Get.defaultDialog(
          middleText: "some account is not defined",
          cancel: Column(
            children: [
              for (var i = 0; i < finalList.length; i++) Text(finalList[i]),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("ok"))
            ],
          ));
      return false;
    }
  }

  void addBond(List<GlobalModel> bondList) {
    BondViewModel bondController = Get.find<BondViewModel>();
    showLoadingDialog(total: bondList.length , fun: (index)async{
      GlobalModel element = bondList[index];
      await bondController.fastAddBondToFirebase(oldBondCode: element.bondCode, bondId: element.bondId, originId: null, total: double.parse("0.00"), record: element.bondRecord!, bondDate: element.bondDate, bondType: element.bondType);
    });
  }

  void addInvoice(List<GlobalModel> invList) {
    GlobalViewModel globalController = Get.find<GlobalViewModel>();
    for (var element in invList) {
      globalController.addGlobalInvoice(element);
    }
  }

  void pickBondFile(separator) async {
    List row = [];
    List row2 = [];
    var indexOfDate;
    var indexOfType;
    var indexOfAccount;
    var indexOfCredit;
    var indexOfDebit;
    var indexOfTotal;
    List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {
    } else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      row2 = file[2].split(separator);
      file.removeAt(0);
      // print(row);
      // print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator)).toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        indexOfType = row.indexOf("أصل السند");
        indexOfTotal = row.indexOf("مدين");
        // indexOfDetails = row.indexOf("البيان");
      });

      row2.forEach((element) {
        indexOfAccount = row2.indexOf("الحساب");
        indexOfCredit = row2.indexOf("دائن");
        indexOfDebit = row2.indexOf("مدين");
      });

      List<List<String>> accountList = [];
      List<List<String>> creditList = [];
      List<List<String>> debitList = [];
      List<String> dateList = [];
      List<String> codeList = [];
      List<String> typeList = [];
      List<String> totalList = [];
      List<String> accountTemp = [];
      List<String> creditTemp = [];
      List<String> debitTemp = [];
      dataList.forEach((element) {
        // print(element[indexOfAccount]);
        if (element[indexOfAccount] == "الحساب") {
          if (accountTemp.length != 0) {
            accountList.add(accountTemp.toList());
            creditList.add(creditTemp.toList());
            debitList.add(debitTemp.toList());
            accountTemp.clear();
            debitTemp.clear();
            creditTemp.clear();
          }
        } else if (element[indexOfAccount] == "") {
          dateList.add(element[indexOfDate]);
          totalList.add(element[indexOfTotal]);
          codeList.add(element[indexOfType].split(":")[1]);
          typeList.add(element[indexOfType].split(":")[0]);
        } else {
          accountTemp.add(element[indexOfAccount].split("-")[1]);
          creditTemp.add(element[indexOfCredit].toString());
          debitTemp.add(element[indexOfDebit].toString());
        }
        if (dataList.indexOf(element) + 1 == dataList.length) {
          accountList.add(accountTemp.toList());
          creditList.add(creditTemp.toList());
          debitList.add(debitTemp.toList());
          accountTemp.clear();
          debitTemp.clear();
          creditTemp.clear();
        }
      });
      for (var i = 0; i < accountList.length; i++) {
        List<BondRecordModel> recordTemp = [];
        for (var j = 0; j < accountList[i].length; j++) {
          if (accountList[i][j] != '') {
            recordTemp.add(BondRecordModel(j.toString().padLeft(2, '0'), double.parse(creditList[i][j]), double.parse(debitList[i][j]), getAccountIdFromText(accountList[i][j]), ''));
          }
        }
        // print(typeList[i].removeAllWhitespace);
        // print(typeList[i].removeAllWhitespace=="دفع");
        String type =
        typeList[i].removeAllWhitespace=="دفع"
            ?Const.bondTypeDebit
            : typeList[i].removeAllWhitespace=="قبض"
              ? Const.bondTypeCredit
              :typeList[i].removeAllWhitespace=="ق.إ"
                ?Const.bondTypeStart
                :Const.bondTypeDaily;
        // print(type);
        GlobalModel model = GlobalModel(bondRecord: recordTemp.toList(), bondId: generateId(RecordType.bond), bondDate: dateList[i], bondTotal: totalList[i], bondCode: int.parse(codeList[i]).toString(), bondDescription: "", bondType: type);
        // print(model.toFullJson());
        bondList.add(GlobalModel.fromJson(model.toFullJson()));
        recordTemp.clear();
      }
      print(bondList.map((e) => e.toFullJson()));
      correctDebitAndCredit(bondList);
      Get.to(() => BondListView(
            bondList: bondList,
          ));
      // Get.to(() => ProductListView(
      //   productList: dataList,
      //   rows: row as List<String>,
      // ));
    }
  }

  correctDebitAndCredit(List bondList) {
    for(var index = 0 ; index <bondList.length ; index++){
      GlobalModel model = bondList[index];
      if(model.bondType == Const.bondTypeDebit ||model.bondType == Const.bondTypeCredit){
        Map <String,double> allRec= {};
        for (var ji  = 0 ; ji< (model.bondRecord??[]).length;ji++) {
          BondRecordModel  element = model.bondRecord![ji];
          if(model.bondType == Const.bondTypeDebit &&element.bondRecCreditAmount!=0){
            if(allRec[element.bondRecAccount!]==null)allRec[element.bondRecAccount!]=0;
            allRec[element.bondRecAccount!] = allRec[element.bondRecAccount]! + element.bondRecCreditAmount!;
          }else if(model.bondType == Const.bondTypeCredit &&element.bondRecDebitAmount!=0){
            if(allRec[element.bondRecAccount!]==null)allRec[element.bondRecAccount!]=0;
            allRec[element.bondRecAccount!] = allRec[element.bondRecAccount]! + element.bondRecDebitAmount!;
          }
        }
        if(model.bondType == Const.bondTypeCredit){
          model.bondRecord?.removeWhere((e) => e.bondRecDebitAmount !=0 );
          model.bondRecord?.add(BondRecordModel("X", 0, allRec.entries.first.value, allRec.entries.first.key, ""));
        }else{
          model.bondRecord?.removeWhere((e) => e.bondRecCreditAmount !=0 );
          model.bondRecord?.add(BondRecordModel("X",allRec.entries.first.value ,0,   allRec.entries.first.key, ""));
        }
      }
    }
  }

  Future<void> pickInvoiceFile(separator) async {
    List row = [];
    List row2 = [];
    // var indexOfInvType;
    var indexOfPrimery;
    var indexOfSecoundry;
    var indexOfInvCode;
    var indexOfTotalWithVat;
    var indexOfTotalVat;
    var indexOfTotalWithoutVat;
    var indexOfSubTotal;
    var indexOfQuantity;
    var indexOfProductName;
    var indexOfDate;
    var indexOfStore;
    var indexOfSeller;
    List<GlobalModel> bondList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {
    } else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);

      file.removeAt(0);
      // print(row);
      // print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }

      List<List<String>> dataList = file.map((e) => e.split(separator)).toList();
      row.forEach((element) {
        indexOfDate = row.indexOf("التاريخ");
        // indexOfInvType = row.indexOf("نوع الفاتورة");
        indexOfPrimery = row.indexOf("اسم الزبون"); // BAD
        indexOfSecoundry = row.indexOf("حساب العميل في الفاتورة");
        indexOfInvCode = row.indexOf("الفاتورة");
        indexOfTotalWithVat = row.indexOf("صافي القيمة بعد الضريبة");
        indexOfTotalVat = row.indexOf("القيمة المضافة");
        indexOfTotalWithoutVat = row.indexOf("القيمة");
        indexOfSubTotal = row.indexOf("السعر");
        indexOfQuantity = row.indexOf("الكمية");
        indexOfProductName = row.indexOf("اسم المادة");
        indexOfStore = row.indexOf("المستودع");
        indexOfSeller = row.indexOf("مركز الكلفة");
      });

      //  List<String> dateList=[];
      Map<String, GlobalModel> invMap = {};
      List notFoundAccount = [];
      List notFoundProduct = [];
      List notFoundStore = [];
      List notFoundSeller = [];
      for (var element in dataList) {
        var store = getStoreIdFromText(element[indexOfStore]);
        if (store == '' && !notFoundStore.contains(element[indexOfStore])) {
          notFoundStore.add(element[indexOfStore]);
        }
        var seller = getSellerIdFromText(element[indexOfSeller]);
        if (seller == '' && !notFoundSeller.contains(element[indexOfSeller])) {
          notFoundSeller.add(element[indexOfSeller]);
        }
        var primery = getAccountIdFromText(element[indexOfPrimery]);
        if (primery == '' && !notFoundAccount.contains(element[indexOfPrimery])) {
          notFoundAccount.add(element[indexOfPrimery]);
        }
        var secoundry = getAccountIdFromText(element[indexOfSecoundry]);
        if (secoundry == '' && !notFoundAccount.contains(element[indexOfSecoundry])) {
          notFoundAccount.add(element[indexOfSecoundry]);
        }
        var product = getProductIdFromName(element[indexOfProductName]);
        if (product == '' && !notFoundProduct.contains(element[indexOfProductName])) {
          notFoundProduct.add(element[indexOfProductName]);
        }
        if (invMap[element[indexOfInvCode]] == null) {
          var invId = generateId(RecordType.invoice);
          PatternModel patternModel = Get.find<PatternViewModel>().patternModel.values.firstWhere((e) => e.patName?.replaceAll(" ", "") == element[indexOfInvCode].toString().split(":")[0].replaceAll(" ", ""));
          invMap[element[indexOfInvCode]] = GlobalModel(
              invId: invId,
              bondId: generateId(RecordType.bond),
              originId: invId,
              bondType: Const.bondTypeDaily,
              //  bondCode: getNextBondCode(),
              invComment: "",

              ///aaaaaaa
              invMobileNumber: "",
              patternId: patternModel.patId,
              invSeller: getSellerIdFromText(element[indexOfSeller]),
              globalType: Const.globalTypeInvoice,
              invPrimaryAccount: primery,
              invSecondaryAccount: secoundry,
              invStorehouse: store,
              invDate: element[indexOfDate],
              bondDate: element[indexOfDate],
              invVatAccount: patternModel.patVatAccount,
              invTotal: double.parse(element[indexOfTotalWithVat].replaceAll("٬", "").replaceAll("٫", ".")),
              // invType:  element[indexOfInvCode].toString().split(":")[0].replaceAll(" ", "")=="مبيع"?Const.invoiceTypeSales:Const.invoiceTypeBuy,
              invType: patternModel.patType,
              invCode: element[indexOfInvCode].toString().split(":")[1].replaceAll(" ", ""),
              readFlags: [
                HiveDataBase.getMyReadFlag()
              ],
              invRecords: [
                InvoiceRecordModel(
                  prodChoosePriceMethod: Const.invoiceChoosePriceMethodeCustom,
                  invRecId: "1",
                  invRecQuantity: int.parse(element[indexOfQuantity]),
                  invRecProduct: product, //product id
                  invRecSubTotal: double.parse(element[indexOfSubTotal].replaceAll("٬", "").replaceAll("٫", ".")),
                  invRecTotal: double.parse(element[indexOfTotalWithVat].replaceAll("٬", "").replaceAll("٫", ".")),
                  invRecVat: double.parse(element[indexOfTotalVat].replaceAll("٬", "").replaceAll("٫", ".")) / int.parse(element[indexOfQuantity]),
                )
              ]);
        } else {
          var lastCode = int.parse(invMap[element[indexOfInvCode]]!.invRecords!.last.invRecId!) + 1;
          invMap[element[indexOfInvCode]]?.invTotal = double.parse(element[indexOfTotalWithVat].replaceAll("٬", "").replaceAll("٫", ".")) + invMap[element[indexOfInvCode]]!.invTotal!;
          invMap[element[indexOfInvCode]]?.invRecords?.add(InvoiceRecordModel(
                prodChoosePriceMethod: Const.invoiceChoosePriceMethodeCustom,
                invRecId: lastCode.toString(),
                invRecQuantity: int.parse(element[indexOfQuantity]),
                invRecProduct: getProductIdFromName(element[indexOfProductName]),
                invRecSubTotal: double.parse(element[indexOfSubTotal].replaceAll("٬", "").replaceAll("٫", ".")),
                invRecTotal: double.parse(element[indexOfTotalWithVat].replaceAll("٬", "").replaceAll("٫", ".")),
                invRecVat: double.parse(element[indexOfTotalVat].replaceAll("٬", "").replaceAll("٫", ".")) / int.parse(element[indexOfQuantity]),
              ));
        }
        //  dateList.add(element[indexOfDate]);
      }

      if (notFoundProduct.isNotEmpty || notFoundStore.isNotEmpty || notFoundAccount.isNotEmpty) {
        Get.defaultDialog(
            title: "بعض الحسابات غير موجودة",
            content: SizedBox(
              height: MediaQuery.sizeOf(Get.context!).height - 150,
              width: MediaQuery.sizeOf(Get.context!).width / 2,
              child: ListView(
                shrinkWrap: true,
                children: [
                  if (notFoundAccount.isNotEmpty) Center(child: Text("الحسابات")),
                  for (var e in notFoundAccount) Text(e),
                  SizedBox(
                    height: 30,
                  ),
                  if (notFoundStore.isNotEmpty) Center(child: Text("المستودعات")),
                  for (var e in notFoundStore) Text(e),
                  SizedBox(
                    height: 30,
                  ),
                  if (notFoundSeller.isNotEmpty) Center(child: Text("البائعون")),
                  for (var e in notFoundSeller) Text(e),
                  SizedBox(
                    height: 30,
                  ),
                  if (notFoundProduct.isNotEmpty) Center(child: Text("المواد")),
                  for (var e in notFoundProduct) Text(e),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ));
        return;
      }
      Get.to(() => InvoiceListView(
            invoiceList: invMap.values.toList(),
          ));
      // print(notFoundProduct);
      // print(notFoundStore);
      // print(notFoundAccount);
      // print(invMap.map((key, value) => MapEntry(key, value.toFullJson())));

      // print(dateList);
      // for(var i =0;i<accountList.length;i++){
      //   List<BondRecordModel> recordTemp=[];
      //   for(var j =0;j<accountList[i].length;j++){
      //     if(accountList[i][j]!=''){
      //       recordTemp.add(BondRecordModel(j.toString().padLeft(2, '0'), double.parse(creditList[i][j]), double.parse(debitList[i][j]), getAccountIdFromText(accountList[i][j]), ''));
      //     }
      //   }
      //   GlobalModel model = GlobalModel(bondRecord: recordTemp.toList(),bondId: generateId(RecordType.bond),bondDate:dateList[i] ,bondTotal: totalList[i],bondCode: int.parse(codeList[i]).toString(),bondDescription: "",bondType: Const.bondTypeDaily);
      //   // print(model.toFullJson());
      //   bondList.add(GlobalModel.fromJson(model.toFullJson()));
      //   recordTemp.clear();
      // }
      // print(bondList.map((e) => e.toFullJson()));
      // Get.to(()=>BondListView(
      //   bondList: bondList,
      // ));
      // Get.to(() => ProductListView(
      //   productList: dataList,
      //   rows: row as List<String>,
      // ));
    }
  }

  void pickFile(separator) async {
    var row = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {
    } else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(separator);
      file.removeAt(0);
      print(row);
      print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(separator)).toList();
      Get.to(() => PreviewView(
            productList: dataList,
            rows: row as List<String>,
          ));
    }
  }
}
