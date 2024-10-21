import 'package:ba3_business_solutions/controller/bond/bond_controller.dart';
import 'package:ba3_business_solutions/controller/databsae/import_controller.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_controller.dart';
import 'package:ba3_business_solutions/controller/print/print_controller.dart';
import 'package:ba3_business_solutions/controller/store/store_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/data/datasources/user/user_management_service.dart';
import 'package:ba3_business_solutions/data/repositories/user/user_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/bindings/bindings.dart';
import '../../core/helper/init_app/init_app.dart';
import '../../data/datasources/seller/seller_firestore_service.dart';
import '../../data/repositories/seller/seller_repo.dart';
import '../../view/login/pages/splash_screen.dart';
import '../account/account_controller.dart';
import '../cheque/cheque_controller.dart';
import '../invoice/invoice_controller.dart';
import '../product/product_controller.dart';
import '../seller/sellers_controller.dart';
import '../user/user_management_controller.dart';

class DataBaseController extends GetxController {
  List<String> databaseList = [];

  DataBaseController() {
    getAllDataBase();
  }

  getAllDataBase() {
    FirebaseFirestore.instance
        .collection(AppConstants.settingCollection)
        .doc(AppConstants.dataCollection)
        .snapshots()
        .listen((value) {
      // databaseList.clear();
      databaseList = (value.data()?['dataList'] as List).map((e) => e.toString()).toList();

      WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
        update();
      });
    });
  }

  Future<void> setDataBase(String databaseName, context) async {
    init(oldData: databaseName);
    await Get.deleteAll(force: true);
    Get.put(UserManagementController(UserManagementRepository(UserManagementService())), permanent: true);
    Get.put(AccountController(), permanent: true);
    Get.put(StoreController(), permanent: true);
    Get.put(ProductController(), permanent: true);
    Get.put(BondController(), permanent: true);
    Get.put(PatternController(), permanent: true);
    Get.put(SellersController(SellersRepository(SellersFireStoreService())), permanent: true);
    Get.put(InvoiceController(), permanent: true);
    Get.put(ChequeController(), permanent: true);
    // Get.put(CameraService(),permanent: true);
    // Get.put(FaceDetectorService(),permanent: true);
    // Get.put(MLService(),permanent: true);
    Get.put(DataBaseController(), permanent: true);
    Get.put(ImportController(), permanent: true);
    Get.put(PrintController(), permanent: true);
    Get.offAll(
      () => const SplashScreen(),
      binding: GetBinding(),
    );
  }

  void setDefaultDataBase(String databaseName) {
    if (databaseList.contains(databaseName)) {
      FirebaseFirestore.instance
          .collection(AppConstants.settingCollection)
          .doc(AppConstants.dataCollection)
          .update({"defaultDataName": databaseName});
    } else {
      Get.snackbar("خطأ", "لا يوجد قاعدة بيانات بنفس الاسم");
    }
  }

  void newDataBase(String databaseName) {
    if (databaseList.contains(databaseName)) {
      Get.snackbar("خطأ", "يوجد قاعدة بيانات بنفس الاسم");
    } else {
      FirebaseFirestore.instance.collection(AppConstants.settingCollection).doc(AppConstants.dataCollection).update({
        'dataList': FieldValue.arrayUnion([databaseName]),
      });
    }
  }
}
