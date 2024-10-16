import 'package:ba3_business_solutions/controller/warranty/warranty_pluto_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/generate_id.dart';
import '../../core/utils/hive.dart';
import '../../data/model/warranty/warranty_model.dart';
import '../global/changes_controller.dart';
import '../user/user_management_controller.dart';

class WarrantyController extends GetxController {
  Map<String, WarrantyModel> warrantyMap = {};

  WarrantyController() {
    for (var element in HiveDataBase.warrantyModelBox.values) {
      warrantyMap[element.invId!] = element;
    }
  }

  late String billId;

  initBills(String billId) {
    this.billId = billId;
    if (billId != "1") {
      buildInvInit(billId);
      Get.find<WarrantyPlutoController>().getRows(warrantyMap[billId]?.invRecords?.toList() ?? []);
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

  void getInvByCode(String text) {
    List<WarrantyModel> inv = warrantyMap.values.where((element) => element.invCode == text).toList();

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

    Get.find<WarrantyPlutoController>().getRows(initModel.invRecords ?? []);
    isNew = false;
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then(
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
    UserManagementController myUser = Get.find<UserManagementController>();
    initModel.sellerId = myUser.myUserModel!.userSellerId!;
    warrantyMap[initModel.invId!] = initModel;

    await addInvoiceToFirebase();
    ChangesController changesViewModel = Get.find<ChangesController>();
    changesViewModel.addChangeToChanges(initModel.toJson(), AppConstants.warrantyCollection);
    isNew = false;
    update();
  }

  updateInvoice({required bool isAdd, required bool done}) async {
    if (isAdd) {
      initModel.invId = generateId(RecordType.warrantyInv);
    }

    initModel.invCode = invCodeController.text;
    initModel.invNots = noteController.text;
    initModel.customerPhone = mobileNumberController.text;
    initModel.customerName = customerNameController.text;
    initModel.done = done;
    initModel.invDate = dateController;
    initModel.invRecords = Get.find<WarrantyPlutoController>().handleSaveAll();

    await saveInvoice();
  }

  void deleteInvoice({WarrantyModel? warrantyModel}) {
    if (warrantyModel != null) {
      HiveDataBase.globalModelBox.delete(warrantyModel.invId);
      warrantyMap.remove(warrantyModel.invId);
      update();
      return;
    }
    FirebaseFirestore.instance.collection(AppConstants.warrantyCollection).doc(initModel.invId).set({"isDeleted": true}, SetOptions(merge: true));
    HiveDataBase.globalModelBox.delete(initModel.invId);
    warrantyMap.remove(initModel.invId);

    ChangesController changesViewModel = Get.find<ChangesController>();
    changesViewModel.addRemoveChangeToChanges(initModel.toJson(), AppConstants.warrantyCollection);
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
    await HiveDataBase.warrantyModelBox.put(initModel.invId, initModel);
    print("end add to Hive and firebase");
  }
}
