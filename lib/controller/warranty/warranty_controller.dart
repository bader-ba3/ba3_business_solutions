import 'dart:developer';

import 'package:ba3_business_solutions/controller/warranty/warranty_pluto_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/generate_id.dart';
import '../../core/utils/hive.dart';
import '../../model/warranty/warranty_model.dart';
import '../global/changes_view_model.dart';
import '../user/user_management_model.dart';

class WarrantyController extends GetxController {
  Map<String, WarrantyModel> warrantyMap = {};

  WarrantyController() {
    for (var element in HiveDataBase.warrantyModelBox.values) {
      warrantyMap[element.invId!] = element;
      print(element.toJson());
    }
  }

  late String billId;

  @override
  void onInit() {
    log('WarrantyController onInit ${Get.arguments}');
    super.onInit();

    billId = Get.arguments as String;
    if (billId != "1") {
      buildInvInit(billId);
      Get.find<WarrantyPlutoViewModel>()
          .getRows(warrantyMap[billId]?.invRecords?.toList() ?? []);
    } else {
      getInit();
    }
  }

  TextEditingController invCodeController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  String dateController = DateTime.now().toString();
  bool isNew = true;

  WarrantyModel initModel = WarrantyModel();

  void getInvByInvCode(String text) {
    List<WarrantyModel> inv =
        warrantyMap.values.where((element) => element.invCode == text).toList();

    if (inv.isNotEmpty) {
      buildInvInit(inv.first.invId!);
    } else {
      Get.snackbar("خطأ رقم الفاتورة", "رقم الفاتورة غير موجود",
          icon: const Icon(
            Icons.error,
            color: Colors.red,
            textDirection: TextDirection.rtl,
          ));
      invCodeController.text = initModel.invCode ?? "";
    }

    update();
  }

  void buildInvInit(String billId) {
    initModel = warrantyMap[billId]!;
    mobileNumberController.text = initModel.customerPhone ?? "";
    noteController.text = initModel.invNots!;
    customerNameController.text = initModel.customerName!;
    invCodeController.text = initModel.invCode!;
    dateController = initModel.invDate ?? '';
    invCodeController.text = initModel.invCode ?? '';

    Get.find<WarrantyPlutoViewModel>().getRows(initModel.invRecords ?? []);
    isNew = false;
    WidgetsFlutterBinding.ensureInitialized()
        .waitUntilFirstFrameRasterized
        .then(
      (value) {
        update();
      },
    );
  }

  void getInit() {
    if (warrantyMap.keys.isNotEmpty) {
      invCodeController.text = (int.parse(warrantyMap.values
                      .map(
                        (e) => e.invCode,
                      )
                      .lastOrNull ??
                  "0") +
              1)
          .toString();
    } else {
      invCodeController.text = "1";
    }
    initModel = WarrantyModel();
    isNew = true;
    mobileNumberController = TextEditingController();
    customerNameController = TextEditingController();
    noteController = TextEditingController();
    dateController = DateTime.now().toString();
  }

  void invNextOrPrev(invCode, bool isPrev) {
    List<WarrantyModel> inv = warrantyMap.values.toList();
    int currentPosition = inv.indexOf(inv
            .where(
              (element) => element.invCode == invCode,
            )
            .firstOrNull ??
        inv.last);

    if (isPrev) {
      if (currentPosition != 0) {
        if (inv
            .where(
              (element) => element.invCode == invCode,
            )
            .isNotEmpty) {
          buildInvInit(inv[currentPosition - 1].invId!);
        } else {
          buildInvInit(inv.last.invId!);
        }
      }
    } else {
      print('inv ${inv.map((e) => e.toJson()).toList()}');
      if (currentPosition < inv.length - 1) {
        buildInvInit(inv[currentPosition + 1].invId!);
      }
    }
    update();
  }

  saveInvoice() async {
    UserManagementViewModel myUser = Get.find<UserManagementViewModel>();
    initModel.sellerId = myUser.myUserModel!.userSellerId!;
    warrantyMap[initModel.invId!] = initModel;

    await addInvoiceToFirebase();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(
        initModel.toJson(), AppConstants.warrantyCollection);
    isNew = false;
    update();
  }

  updateInvoice({required bool isAdd, required bool done}) async {
    /*   if (warrantyMap.values.where((element) => element.invCode == invCodeController.text).firstOrNull != null || invCodeController.text == '') {
      Get.snackbar("خطأ", "رقم الفاتورة موجود من قبل ");
      return;
    }*/
    if (isAdd) {
      initModel.invId = generateId(RecordType.warrantyInv);
    }

    initModel.invCode = invCodeController.text;
    initModel.invNots = noteController.text;
    initModel.customerPhone = mobileNumberController.text;
    initModel.customerName = customerNameController.text;
    initModel.done = done;
    initModel.invDate = dateController;
    initModel.invRecords = Get.find<WarrantyPlutoViewModel>().handleSaveAll();

    await saveInvoice();
  }

  void deleteInvoice({WarrantyModel? warrantyModel}) {
    if (warrantyModel != null) {
      HiveDataBase.globalModelBox.delete(warrantyModel.invId);
      warrantyMap.remove(warrantyModel.invId);
      update();
      return;
    }
    FirebaseFirestore.instance
        .collection(AppConstants.warrantyCollection)
        .doc(initModel.invId)
        .set({"isDeleted": true}, SetOptions(merge: true));
    HiveDataBase.globalModelBox.delete(initModel.invId);
    warrantyMap.remove(initModel.invId);

    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addRemoveChangeToChanges(
        initModel.toJson(), AppConstants.warrantyCollection);
    update();
  }

  addToLocal({required WarrantyModel warrantyModel}) async {
    await HiveDataBase.warrantyModelBox.put(warrantyModel.invId, warrantyModel);
    warrantyMap[warrantyModel.invId!] = warrantyModel;
  }

  addInvoiceToFirebase() async {
    await FirebaseFirestore.instance
        .collection(AppConstants.warrantyCollection)
        .doc(initModel.invId)
        .set(initModel.toJson(), SetOptions(merge: true));
/*    if (globalModel.invMobileNumber != null && globalModel.invMobileNumber != '') {
      await FirebaseFirestore.instance.collection(Const.ba3Invoice).doc(globalModel.invMobileNumber).set({
        "listUrl": FieldValue.arrayUnion(['https://ba3-business-solutions.firebaseapp.com/?id=${globalModel.invId}&year=${Const.dataName}'])
      });
    }*/

    await HiveDataBase.warrantyModelBox.put(initModel.invId, initModel);
    print("end add to Hive and firebase");
  }
}
