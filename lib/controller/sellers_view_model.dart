import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/model/account_record_model.dart';
import 'package:ba3_business_solutions/model/seller_model.dart';
import 'package:ba3_business_solutions/utils/generate_id.dart';
import 'package:ba3_business_solutions/view/sellers/widget/all_seller_invoice_view_data_grid_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SellersViewModel extends GetxController {
  late DataGridController dataViewGridController;
  late AllSellerInvoiceViewDataGridSource recordViewDataSource;
  Map<String, SellerModel> allSellers = {};
  SellersViewModel() {
    getallSeller();
  }

  void getallSeller() {
    FirebaseFirestore.instance.collection(Const.sellersCollection).snapshots().listen((event) {
      allSellers.clear();
      event.docs.forEach((element) {
        FirebaseFirestore.instance.collection(Const.sellersCollection).doc(element.id).collection(Const.recordCollection).snapshots().listen((event) {
          List<SellerRecModel> _ = event.docs.map((e) => SellerRecModel.fromJson(e.data())).toList();
          allSellers[element.id] = SellerModel.fromJson(element.data(), element.id, _);
        });
      });
      update();
    });
  }

  addseller(SellerModel model) {
    var id = generateId(RecordType.sellers);
    model.sellerId ??= id;
    FirebaseFirestore.instance.collection(Const.sellersCollection).doc(model.sellerId).set(model.toJson());
  }

  deleteseller(SellerModel model) {
    FirebaseFirestore.instance.collection(Const.sellersCollection).doc(model.sellerId).delete();
  }

  void postRecord({userId, invId, amount, date}) {
    FirebaseFirestore.instance.collection(Const.sellersCollection).doc(userId).collection(Const.recordCollection).doc(invId).set(
          SellerRecModel(selleRecUserId: userId, selleRecInvId: invId, selleRecAmount: amount.toString(), selleRecInvDate: date).toJson(),
        );
  }

  void deleteRecord({userId, invId}) {
    FirebaseFirestore.instance.collection(Const.sellersCollection).doc(userId).collection(Const.recordCollection).doc(invId).delete();
  }

  initSellerPage(key) {
    dataViewGridController = DataGridController();
    recordViewDataSource = AllSellerInvoiceViewDataGridSource(sellerRecModel: allSellers[key]!.sellerRecord!);
    // update();
  }

  void filter(List<DateTime> list, key) {
    var startDate = DateTime.parse(list[0].toString().split(" ")[0]);
    var endDate = DateTime.parse(list[1].toString().split(" ")[0]);
    var _ = allSellers[key]?.sellerRecord?.where((e) => DateTime.parse(e.selleRecInvDate!).millisecondsSinceEpoch <= endDate.millisecondsSinceEpoch && DateTime.parse(e.selleRecInvDate!).millisecondsSinceEpoch >= startDate.millisecondsSinceEpoch).toList();
    print(_?.map((e) => e.toJson()));
    dataViewGridController = DataGridController();
    recordViewDataSource = AllSellerInvoiceViewDataGridSource(sellerRecModel: _!);
    update();
  }
}

List<String> _accountPickList = [];
Future<String> getSellerComplete(text) async {
  var sellerController = Get.find<SellersViewModel>();
  _accountPickList = [];
  var _;
  sellerController.allSellers.forEach((key, value) {
    _accountPickList.addIf((value.sellerCode!.toLowerCase().contains(text.toLowerCase()) || value.sellerName!.toLowerCase().contains(text.toLowerCase())), value.sellerName!);
  });
  if (_accountPickList.length > 1) {
    await Get.defaultDialog(
      title: "Chosse form dialog",
      content: SizedBox(
        width: 500,
        height: 500,
        child: ListView.builder(
          itemCount: _accountPickList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Get.back();
                _ = _accountPickList[index];
              },
              child: Container(
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(8),
                width: 500,
                child: Center(
                  child: Text(
                    _accountPickList[index],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
    return _;
  } else if (_accountPickList.length == 1) {
    return _accountPickList[0];
  } else {
    Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
    return "";
  }
}

String getSellerIdFromText(text) {
  var sellerController = Get.find<SellersViewModel>();
  if (text != null && text != " " && text != "") {
    return sellerController.allSellers.values.toList().firstWhere((element) => element.sellerName == text).sellerId!;
  } else {
    return "";
  }
}

String getSellerNameFromid(id) {
  if (id != null && id != " " && id != "") {
    print(id);
    return Get.find<SellersViewModel>().allSellers[id]!.sellerName!;
  } else {
    return "";
  }
}
