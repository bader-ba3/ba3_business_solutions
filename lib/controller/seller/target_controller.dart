import 'dart:developer';

import 'package:ba3_business_solutions/controller/seller/sellers_controller.dart';
import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/shared/widgets/target_pointer_widget.dart';
import '../../core/utils/generate_id.dart';
import '../../core/utils/hive.dart';
import '../../data/model/invoice/invoice_record_model.dart';
import '../../data/model/seller/seller_model.dart';
import '../../data/model/seller/task_model.dart';
import '../../data/repositories/seller/target_repo.dart';
import '../product/product_controller.dart';

class TargetController extends GetxController {
  RxMap<String, TaskModel> allTarget = <String, TaskModel>{}.obs;

  final TargetRepository _targetRepository;

  TargetController(this._targetRepository) {
    getAllTargets();
  }

  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  late TaskModel taskModel;
  List<String> allUser = [];

  String? taskDate;
  late ({Map<String, int> productsMap, double mobileTotal, double otherTotal}) sellerData;
  SellerModel? sellerModel;

  int num = 20000;
  final GlobalKey<TargetPointerWidgetState> othersKey = GlobalKey<TargetPointerWidgetState>();
  final GlobalKey<TargetPointerWidgetState> mobileKey = GlobalKey<TargetPointerWidgetState>();

  initTask([String? key]) {
    if (key == null) {
      productNameController.clear();
      quantityController.clear();
      taskModel = TaskModel(taskType: AppConstants.taskTypeProduct);
      taskDate = "${DateTime.now().year}-${DateTime.now().month}";
      allUser.clear();
    } else {
      taskModel = TaskModel.fromJson(Get.find<TargetController>().allTarget[key]!.toJson());
      productNameController.text = getProductNameFromId(taskModel.taskProductId);
      quantityController.text = taskModel.taskQuantity.toString();
      allUser.assignAll(taskModel.taskSellerListId);
      taskDate = taskModel.taskDate;
    }
  }

  initSeller(String sellerId) {
    log('initSeller $sellerId');
    sellerData = checkTask(sellerId);
    sellerModel = Get.find<SellersController>().allSellers[sellerId];
  }

  void getAllTargets() {
    _targetRepository.getAllTargets().listen((taskMap) {
      allTarget.assignAll(taskMap);
      update();
    });
  }

  Future<void> addTask(TaskModel targetModel) async {
    final result = await _targetRepository.addTask(targetModel);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) => Get.snackbar('Success', 'Task added successfully'),
    );
  }

  Future<void> updateTask(TaskModel targetModel) async {
    final result = await _targetRepository.updateTask(targetModel);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) => Get.snackbar('Success', 'Task updated successfully'),
    );
  }

  Future<void> deleteTask(TaskModel targetModel) async {
    final result = await _targetRepository.deleteTask(targetModel.taskId!);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) => Get.snackbar('Success', 'Task deleted successfully'),
    );
  }

// Function to filter the list of invoices by seller and current month
  List<List<InvoiceRecordModel>?> _filterInvoiceRecords(String sellerId) {
    return HiveDataBase.globalModelBox.values
        .where((element) {
          return element.globalType == AppConstants.globalTypeInvoice &&
              element.invType != AppConstants.invoiceTypeBuy &&
              element.invSeller == sellerId &&
              element.invDate?.split("-")[1] == Timestamp.now().toDate().month.toString().padLeft(2, "0");
        })
        .map((e) => e.invRecords)
        .toList();
  }

// Function to update the products map based on the invoice record
  void _updateProductsMap(Map<String, int> productsMap, InvoiceRecordModel record) {
    if (!productsMap.containsKey(record.invRecProduct!)) {
      productsMap[record.invRecProduct!] = record.invRecQuantity?.toInt() ?? 0;
    } else {
      productsMap[record.invRecProduct!] = (productsMap[record.invRecProduct!] ?? 0) + (record.invRecQuantity?.toInt() ?? 0);
    }
  }

// Function to calculate totals and return updated sums
  ({double accessorySum, double mobileSum}) _calculateSums(InvoiceRecordModel record, double accessorySum, double mobileSum) {
    if (record.invRecTotal! / record.invRecQuantity! <= 1000) {
      accessorySum += record.invRecTotal!;
    } else {
      mobileSum += record.invRecTotal!;
    }
    return (accessorySum: accessorySum, mobileSum: mobileSum);
  }

// Main function to check the task
  ({double mobileTotal, double otherTotal, Map<String, int> productsMap}) checkTask(String sellerId) {
    Map<String, int> productsMap = {};
    double accessorySum = 0;
    double mobileSum = 0;

    List<List<InvoiceRecordModel>?> total = _filterInvoiceRecords(sellerId);
    log('total  ${total.map((e) => e!.map((el) => el.toJson())).toList()}');

    if (total.isNotEmpty) {
      for (var records in total) {
        for (InvoiceRecordModel record in records ?? []) {
          if (record.invRecGift == 0 || (record.invRecGift == null && record.invRecQuantity != null)) {
            _updateProductsMap(productsMap, record);
            ({double accessorySum, double mobileSum}) sums = _calculateSums(record, accessorySum, mobileSum);
            accessorySum = sums.accessorySum;
            mobileSum = sums.mobileSum;
          }
        }
      }
    }
    return (mobileTotal: mobileSum, otherTotal: accessorySum, productsMap: productsMap);
  }

// List to hold product names matching the search criteria
  List<String> matchingProductsList = [];

  Future<String> fetchMatchingProducts(String searchText) async {
    ProductController productController = Get.find<ProductController>();
    String selectedProductName = '';

    // Clear previous matching products
    matchingProductsList.clear();

    // Filter products based on the search text
    productController.productDataMap.forEach((key, value) {
      matchingProductsList.addIf(
        !value.prodIsGroup! &&
            (value.prodCode!.toLowerCase().contains(searchText.toLowerCase()) ||
                value.prodFullCode!.toLowerCase().contains(searchText.toLowerCase()) ||
                value.prodName!.toLowerCase().contains(searchText.toLowerCase())),
        value.prodName!,
      );
    });

    // Handle the selection of products based on the filtered list
    if (matchingProductsList.length > 1) {
      await Get.defaultDialog(
        title: "Choose from dialog",
        content: SizedBox(
          width: 500,
          height: 500,
          child: ListView.builder(
            itemCount: matchingProductsList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  selectedProductName = matchingProductsList[index]; // Update selected product name
                  update();
                  Get.back();
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(8),
                  width: 500,
                  child: Center(
                    child: Text(matchingProductsList[index]),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else if (matchingProductsList.length == 1) {
      selectedProductName = matchingProductsList[0]; // Select the only matching product
    } else {
      Get.snackbar("فحص المنتجات", "هذا المنتج غير موجود من قبل");
    }

    return selectedProductName; // Return the selected product name
  }
}
