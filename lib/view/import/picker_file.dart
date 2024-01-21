import 'dart:io';
import 'package:ba3_business_solutions/model/bond_record_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/import/bond_list_view.dart';
import 'package:ba3_business_solutions/view/import/product_list_view.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../controller/user_management_model.dart';

class FilePickerWidget extends StatelessWidget {

   FilePickerWidget({super.key});

   List allSeperator=["Tab (  )","comma (,)","semicolon (;)"];
   List allSeperatorValue=["	",",",";"];
   var seperator;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StatefulBuilder(
                builder: (context,setstate) {
                  return DropdownButton(
                      value: seperator,
                      items: allSeperator.map((e) => DropdownMenuItem(value: allSeperatorValue[allSeperator.indexOf(e)],child: Text(e))).toList(), onChanged: (_){
                    setstate((){
                      seperator=_;
                    });
                  });
                }
            ),
            SizedBox(height: 50,),
            ElevatedButton(
              onPressed: () {
                if(seperator!=null){
                  checkPermissionForOperation(Const.roleUserAdmin,Const.roleViewImport).then((value) {
                    if(value)pickFile();
                  });
                }else{
                  Get.snackbar("error", "plz select seperator");
                }
              },
              child: Text("try"),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {
                if(seperator!=null){
                  pickBondFile();
                }else{
                  Get.snackbar("error", "plz select seperator");
                }

              },
              child: Text("bond"),
            ),

          ],
        ),
      ),
    );
  }

  Future<void> pickBondFile() async {
    var row = [];
    var row2 = [];
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
      row = file[0].split(seperator);
      row2 = file[2].split(seperator);
      file.removeAt(0);
      // print(row);
      // print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(seperator)).toList();
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
      print( indexOfDate);
      print( indexOfType);
      print( indexOfAccount);
      print( indexOfCredit);
      List<List<String>> accountList=[];
      List<List<String>> creditList=[];
      List<List<String>> debitList=[];
      List<String> dateList=[];
      List<String> codeList=[];
      List<String> typeList=[];
      List<String> totalList=[];
      List<String> accountTemp=[];
      List<String> creditTemp=[];
      List<String> debitTemp=[];
      dataList.forEach((element) {
        // print(element[indexOfAccount]);
          if(element[indexOfAccount] == "الحساب"){
            print(accountTemp.length!=0);
            print(accountTemp.length);
            if(accountTemp.length!=0){
              accountList.add(accountTemp.toList());
              creditList.add(creditTemp.toList());
              debitList.add(debitTemp.toList());
              accountTemp.clear();
              debitTemp.clear();
              creditTemp.clear();
            }
          }else if(element[indexOfAccount] == ""){
            dateList.add(element[indexOfDate]);
            totalList.add(element[indexOfTotal]);
            codeList.add(element[indexOfType].split(":")[1]);
          }else{
            accountTemp.add(element[indexOfAccount].split("-")[1]);
            creditTemp.add(element[indexOfCredit].toString());
            debitTemp.add(element[indexOfDebit].toString());
          }
          if(dataList.indexOf(element)+1==dataList.length){
            accountList.add(accountTemp.toList());
            creditList.add(creditTemp.toList());
            debitList.add(debitTemp.toList());
            accountTemp.clear();
            debitTemp.clear();
            creditTemp.clear();
          }
      });
       for(var i =0;i<accountList.length;i++){
        List<BondRecordModel> recordTemp=[];
        for(var j =0;j<accountList[i].length;j++){
          if(accountList[i][j]!=''){
            recordTemp.add(BondRecordModel(j.toString().padLeft(2, '0'), double.parse(creditList[i][j]), double.parse(debitList[i][j]), accountList[i][j], ''));
          }
        }
        GlobalModel model = GlobalModel(bondRecord: recordTemp.toList(),bondId: generateId(RecordType.bond),bondDate:dateList[i] ,bondTotal: totalList[i],bondCode: int.parse(codeList[i]).toString(),bondDescription: "",bondType: Const.bondTypeDaily);
        // print(model.toFullJson());
        bondList.add(GlobalModel.fromJson(model.toFullJson()));
        recordTemp.clear();
      }
      print(bondList.map((e) => e.toFullJson()));
      Get.to(()=>BondListView(
        bondList: bondList,
      ));
      // Get.to(() => ProductListView(
      //   productList: dataList,
      //   rows: row as List<String>,
      // ));
    }
  }



  Future<void> pickFile() async {
    var row = [];
    // var indexOfName;
    // var indexOfPrice;
    // var indexOfQuantity;
    // var indexOfBarcode;
    // var indexOfgroupCode;
    // var indexOfCode;
    List<ProductModel> productList = [];
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
    var result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', "tsv"],
    );
    if (result == null) {
    } else {
      File _ = File(result.files.single.path!);
      List<String> file = await _.readAsLines();
      row = file[0].split(seperator);
      file.removeAt(0);
      print(row);
      print(row.length);
      if (row.length == 1) {
        Get.snackbar("error", "plz check if the file separeted ");
        return;
      }
      List<List<String>> dataList = file.map((e) => e.split(seperator)).toList();
      // print(dataList);
      // row.forEach((element) {
      //   indexOfName = row.indexOf("اسم المادة");
      //   indexOfPrice = row.indexOf("السعر");
      //   indexOfQuantity = row.indexOf("الكمية");
      //   indexOfBarcode = row.indexOf("رمز الباركود");
      //   indexOfgroupCode = row.indexOf("رمز المجموعة");
      //   indexOfCode = row.indexOf("رمز المادة");
      // });
      // print(indexOfName);
      // print(indexOfPrice);
      // print(indexOfQuantity);
      // print(indexOfBarcode);
      // print(indexOfgroupCode);
      // print(indexOfCode);
      // for (var element in dataList) {
      //   // print("name: " + element[indexOfName]);
      //   // print("price: " + element[indexOfPrice]);
      //   // print("quantity: " + element[indexOfQuantity]);
      //   // print("barcode: " + element[indexOfBarcode]);
      //   // print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-");
      //   //productList.add(ProductModel(prodId: generateId(RecordType.product), prodName: element[indexOfName], prodBarcode: indexOfBarcode == -1 ? " " : element[indexOfBarcode], prodPrice: indexOfPrice == -1 ? "0" : element[indexOfPrice], prodCode: indexOfCode == -1 ? " " : element[indexOfCode], prodGroupCode: indexOfgroupCode == -1 ? " " : element[indexOfgroupCode], prodHasVat: true));
      // }
      //print(productList.map((e) => e.toJson()));

      Get.to(() => ProductListView(
            productList: dataList,
            rows: row as List<String>,
          ));
    }
  }
}
