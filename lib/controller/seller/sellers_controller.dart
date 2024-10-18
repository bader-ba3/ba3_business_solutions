import 'dart:math';

import 'package:ba3_business_solutions/core/constants/app_constants.dart';
import 'package:ba3_business_solutions/core/utils/generate_id.dart';
import 'package:ba3_business_solutions/data/model/seller/seller_model.dart';
import 'package:ba3_business_solutions/view/sellers/widget/all_seller_invoice_data_grid_source.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../data/model/global/global_model.dart';
import '../../data/repositories/seller/seller_repo.dart';
import '../user/user_management_controller.dart';

class SellersController extends GetxController {
  late DataGridController dataViewGridController;
  late AllSellerInvoiceDataGridSource recordViewDataSource = AllSellerInvoiceDataGridSource(sellerRecModel: []);
  RxMap<String, SellerModel> allSellers = <String, SellerModel>{}.obs;

  List<DateTime>? dateRange = [];

  SellersController(this._sellersRepository) {
    getAllSellers();
  }

  final SellersRepository _sellersRepository;

  void getAllSellers() {
    _sellersRepository.getAllSellers().listen((sellers) {
      // Preserve existing seller records
      final oldSellerList = {
        for (var entry in allSellers.entries) entry.key: entry.value.sellerRecord ?? [],
      };

      // Clear and update allSellers with new data and restore old records
      allSellers.assignAll(
        {
          for (var entry in sellers.entries) entry.key: entry.value..sellerRecord = oldSellerList[entry.key] ?? [],
        },
      );
      update();
    });
  }

  void addSeller(SellerModel model) async {
    List<SellerModel> existingSellers = allSellers.values.where((element) => element.sellerCode == model.sellerCode).toList();

    if (existingSellers.isNotEmpty) {
      if (model.sellerId == null || model.sellerId != existingSellers.first.sellerId) {
        return;
      }
    }

    model.sellerId ??= generateId(RecordType.sellers);
    final result = await _sellersRepository.addSeller(model);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message), // Handle error
      (_) => Get.snackbar('Success', 'Seller added successfully'),
    );
  }

  void deleteSeller(SellerModel model) async {
    final result = await _sellersRepository.deleteSeller(model.sellerId);
    result.fold(
      (failure) => Get.snackbar('Error', failure.message),
      (_) => Get.snackbar('Success', 'Seller deleted successfully'),
    );
  }

  void postRecord({userId, invId, amount, date}) {
    allSellers.values.map((e) => e.sellerRecord).toList().forEach((element) {
      element?.removeWhere((record) => record.selleRecInvId == invId);
    });

    SellerRecModel sellerRecord = SellerRecModel(
      selleRecUserId: userId,
      selleRecInvId: invId,
      selleRecAmount: amount.toString(),
      selleRecInvDate: date,
    );

    if (allSellers[userId]?.sellerRecord == null) {
      allSellers[userId]?.sellerRecord = [sellerRecord];
    } else {
      allSellers[userId]?.sellerRecord?.removeWhere((record) => record.selleRecInvId == invId);
      allSellers[userId]?.sellerRecord?.add(sellerRecord);
    }

    update();
  }

  void deleteGlobalSeller(GlobalModel globalModel) {
    allSellers[globalModel.invSeller]?.sellerRecord?.removeWhere((record) => record.selleRecInvId == globalModel.invId);
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      update();
    });
  }

  initSellerPage(key) {
    dataViewGridController = DataGridController();
    recordViewDataSource = AllSellerInvoiceDataGridSource(sellerRecModel: allSellers[key]!.sellerRecord!);
  }

  void filter(List<DateTime> list, key) {
    var startDate = DateTime.parse(list[0].toString().split(" ")[0]);
    var endDate = DateTime.parse(list[1].toString().split(" ")[0]);
    var filteredRecords = allSellers[key]
        ?.sellerRecord
        ?.where((e) =>
            DateTime.parse(e.selleRecInvDate!).millisecondsSinceEpoch <= endDate.millisecondsSinceEpoch &&
            DateTime.parse(e.selleRecInvDate!).millisecondsSinceEpoch >= startDate.millisecondsSinceEpoch)
        .toList();
    dataViewGridController = DataGridController();
    recordViewDataSource = AllSellerInvoiceDataGridSource(sellerRecModel: filteredRecords!);
    update();
  }

  Color getRandomColor() {
    Random random = Random();
    return Color.fromARGB(255, random.nextInt(256), random.nextInt(256), random.nextInt(256));
  }

  Future<String> selectSeller(String searchText) async {
    List<SellerModel> filteredSellers = [];
    SellerModel? selectedSeller;

    // Filter sellers based on input text (code or name)
    allSellers.forEach((key, seller) {
      filteredSellers.addIf(
          seller.sellerCode!.toLowerCase().contains(searchText.toLowerCase()) || seller.sellerName!.toLowerCase().contains(searchText.toLowerCase()),
          seller);
    });

    // If more than one seller matches, show a dialog to select one
    if (filteredSellers.length > 1) {
      await Get.defaultDialog(
        title: "اختر احد البائعين",
        content: SizedBox(
          height: Get.height / 2,
          width: Get.height / 2,
          child: ListView.builder(
            itemCount: filteredSellers.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Get.back();
                  selectedSeller = filteredSellers[index];
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(8),
                  width: 500,
                  child: Center(
                    child: Text(filteredSellers[index].sellerName ?? ""),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else if (filteredSellers.length == 1) {
      // If only one seller matches, auto-select
      selectedSeller = filteredSellers[0];
    } else {
      // No sellers matched
      Get.snackbar("فحص البائعين", "البائع غير موجود");
      return "";
    }

    // Validate permissions or return the seller name
    if (selectedSeller!.sellerId != getCurrentUserSellerId()) {
      if (await hasPermissionForOperation(AppConstants.roleUserAdmin, AppConstants.roleViewInvoice)) {
        return selectedSeller!.sellerName!;
      } else {
        return getSellerNameById(getCurrentUserSellerId()) ?? "";
      }
    } else {
      return selectedSeller!.sellerName!;
    }
  }
}

String? getSellerIdFromText(text) {
  var sellerController = Get.find<SellersController>();
  if (text != null && text != " " && text != "") {
    return sellerController.allSellers.values.toList().firstWhereOrNull((element) => element.sellerName!.contains(text))?.sellerId;
  } else {
    return null;
  }
}

String? getSellerNameById(id) {
  if (id != null && id != " " && id != "") {
    return Get.find<SellersController>().allSellers[id]!.sellerName;
  } else {
    return null;
  }
}
