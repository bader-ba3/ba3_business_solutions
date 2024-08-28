import 'package:ba3_business_solutions/Const/const.dart';
import 'package:ba3_business_solutions/Widgets/Invoice_Pluto_Edit_View_Model.dart';
import 'package:ba3_business_solutions/Widgets/Pluto_View_Model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/Pattern_model.dart';
import 'package:ba3_business_solutions/model/invoice_discount_record_model.dart';
import 'package:ba3_business_solutions/model/invoice_record_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/view/invoices/widget/all_invoice_data_sorce.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../model/global_model.dart';
import '../view/invoices/Controller/Screen_View_Model.dart';
import '../view/invoices/widget/invoice_discount_record_source.dart';
import '../view/invoices/widget/invoice_record_source.dart';
import 'account_view_model.dart';
import 'isolate_view_model.dart';

class InvoiceViewModel extends GetxController {
  var accountController = Get.find<AccountViewModel>();
  var bondController = Get.find<BondViewModel>();
  var productController = Get.find<ProductViewModel>();
  var patternController = Get.find<PatternViewModel>();
  var storeViewController = Get.find<StoreViewModel>();
  var sellerViewController = Get.find<SellersViewModel>();
  var startDateController = TextEditingController()..text = DateTime.now().toString().split(" ")[0];
  var endDateController = TextEditingController()..text = DateTime.now().toString().split(" ")[0];

  List<String> invIdList = [];

  List<String> invCodeList = [];

  List<String> patternList = [];

  // String typeBill = "";

  RxMap<String, GlobalModel> invoiceModel = <String, GlobalModel>{}.obs;

  List<InvoiceRecordModel> invoiceRecordModel = [];

  List<String> accountPickList = [];

  List<String> storePickList = [];

  String? dateController;
  TextEditingController primaryAccountController = TextEditingController();
  TextEditingController secondaryAccountController = TextEditingController();
  TextEditingController invCustomerAccountController = TextEditingController();
  TextEditingController sellerController = TextEditingController();
  TextEditingController invCodeController = TextEditingController();
  TextEditingController storeController = TextEditingController();
  TextEditingController storeNewController = TextEditingController();
  TextEditingController billIDController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController entryBondIdController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController firstPayController = TextEditingController();
  TextEditingController invReturnCodeController = TextEditingController();
  TextEditingController invReturnDateController = TextEditingController();
  final DataGridController dataGridController = DataGridController();
  late GlobalModel initModel;
  int colorInvoice = Colors.grey.value;

  double total = 0.0;

  late List<InvoiceRecordModel> records;
  late List<InvoiceDiscountRecordModel> discountRecords;
  late InvoiceRecordSource invoiceRecordSource;
  late InvoiceDiscountRecordSource invoiceDiscountRecordSource;

  late allInvoiceDataGridSource invoiceAllDataGridSource;

  Map<String, String> nextPrevList = {};

  List<GlobalModel> allInvoiceForPluto = [];

  /// we don't need this
  getDataForPluto() async {
    IsolateViewModel isolateViewModel = Get.find<IsolateViewModel>();
    isolateViewModel.init();
    print("from invoice View");
    final a = await compute<({List<GlobalModel> invoiceModel, IsolateViewModel isolateViewModel}), List<GlobalModel>>((message) {
      Get.put(message.isolateViewModel);
      return message.invoiceModel;
    }, (invoiceModel: invoiceModel.values.toList(), isolateViewModel: isolateViewModel));
    allInvoiceForPluto = a;
    // Get.find<PlutoViewModel>().  update();
    update();
    // return a;
  }

  onCellTap(RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex.rowIndex + 1 == records.length) {
      records.add(InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault));
      invoiceRecordSource.buildDataGridRows(records, getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat);
      invoiceRecordSource.updateDataGridSource();
    }
  }

  onDiscountCellTap(RowColumnIndex rowColumnIndex) {
    if (rowColumnIndex.rowIndex + 1 == discountRecords.length) {
      discountRecords.add(InvoiceDiscountRecordModel());
      invoiceDiscountRecordSource.buildDataGridRows(discountRecords);
      invoiceDiscountRecordSource.updateDataGridSource();
    }
  }

  changeSecAccount() {
    //invoiceRecordSource.buildDataGridRows(records, getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat);
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
    invoiceRecordSource.updateDataGridSource();
    update();
  }

  initAllInvoice() {
    invoiceAllDataGridSource = allInvoiceDataGridSource(invoiceModel);
    invoiceAllDataGridSource.updateDataGridSource();
    update();
  }

  // getAllInvoices() async {
  // _invoicesCollectionRef.snapshots().listen((value) {
  //   _invoiceModel.clear();
  //   for (int i = 0; i < value.docs.length; i++) {
  //     value.docs[i].reference.collection("invRecord").snapshots().listen((value0) {
  //       List<InvoiceRecordModel> _ = [];
  //       for (var element in value0.docs) {
  //         _.add(InvoiceRecordModel.fromJson(element.data()));
  //       }
  //       _invoiceModel[value.docs[i]['invId']] = GlobalModel.fromJson(value.docs[i].data() as Map<String, dynamic>);
  //       _invoiceModel[value.docs[i]['invId']]?.invRecords = _;
  //       invoiceAllDataGridSource.updateDataGridSource();
  //       update();
  //     });
  //   }
  // });
  // }

  initGlobalInvoice(GlobalModel globalModel) {
    invoiceModel[globalModel.invId!] = globalModel;
    initModel = GlobalModel.fromJson(globalModel.toFullJson());

    /// todo : edit this.
    //nextPrevList.assignAll(invoiceModel.values.where((element) => element.patternId == patternId).map((e) => e.invId!));

    // initAllInvoice();
    update();
  }

  deleteGlobalInvoice(GlobalModel globalModel) {
    invoiceModel.removeWhere((key, value) => key == globalModel.invId);
    initAllInvoice();
  }

  computeTotal(List<InvoiceRecordModel> records) {
    int quantity = 0;
    double subtotals = 0.0;
    total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        record.invRecTotal = quantity * (subtotals + record.invRecVat!);
        total += quantity * (subtotals + record.invRecVat!);
        update();
      }
    }
  }

  double computeAllTotal() {
    int quantity = 0;
    double subtotals = 0.0;
    total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        total += quantity * (subtotals + record.invRecVat!);
      }
    }
    for (var record in discountRecords) {
      if ((record.discountPercentage ?? 0) > 0) {
        total -= total * (record.discountPercentage ?? 0);
      }
      if ((record.addedPercentage ?? 0) > 0) {
        total += total * (record.addedPercentage ?? 0);
      }
    }
    return total;
  }

  double computeVatTotal() {
    int quantity = 0;
    total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        total += quantity * record.invRecVat!;
      }
    }
    for (var record in discountRecords) {
      if ((record.discountPercentage ?? 0) > 0) {
        total -= total * (record.discountPercentage ?? 0);
      }
      if ((record.addedPercentage ?? 0) > 0) {
        total += total * (record.addedPercentage ?? 0);
      }
    }

    return total;
  }

  double calculateTotalDiscount(List<double?> totalDiscount) {
    return totalDiscount.fold(0.0, (sum, item) => sum + (item ?? 0.0));
  }

  double computeWithoutVatTotal() {
    int quantity = 0;
    double subtotals = 0.0;
    total = 0.0;

    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        total += quantity * (subtotals);
      }
    }
    for (var record in discountRecords) {
      if ((record.discountPercentage ?? 0) > 0) {
        total -= record.discountTotal ?? 0;
      }
      if ((record.addedPercentage ?? 0) > 0) {
        total += record.addedTotal ?? 0;
      }
    }

    return total;
  }

  // List<InvoiceRecordModel> getInvoiceRecords(String billId) {
  //   List<InvoiceRecordModel> rec = [];
  //   List<InvoiceRecordModel> rawData = ;
  //   List<Map<String, dynamic>> data = [];
  //   for (var item in rawData) {
  //     data.add(item.toJson());
  //   }
  //   for (var item in data) {
  //     if (item["invRecId"] != null) {
  //      // String prodName = productController.productDataMap[item["invRecProduct"]]!.prodName!;
  //       rec.add(InvoiceRecordModel(
  //         invRecQuantity: item["invRecQuantity"],
  //         invRecProduct: prodName,
  //         invRecId: item["invRecId"],
  //         invRecSubTotal: item["invRecSubTotal"],
  //         invRecTotal: item["invRecTotal"],
  //         invRecVat: item["invRecVat"],
  //       ));
  //     }
  //   }
  //   return rec;
  // }

  // addInvoice(GlobalModel invoiceModel, List<InvoiceRecordModel> record) async {
  //   await _invoicesCollectionRef.doc(invoiceModel.invId).set(invoiceModel.toJson());
  //   int i = 0;
  //   do {
  //     if (record[i].invRecId != null) {
  //       await _invoicesCollectionRef.doc(invoiceModel.invId).collection("invRecord").doc(record[i].invRecId).set({
  //         'invRecId': record[i].invRecId,
  //         'invRecProduct': record[i].invRecProduct,
  //         'invRecQuantity': record[i].invRecQuantity,
  //         'invRecSubTotal': record[i].invRecSubTotal,
  //         'invRecTotal': invoiceModel.invTotal,
  //         'invRecVat': record[i].invRecVat,
  //       });
  //     }
  //     i++;
  //   } while (i < record.length);
  // }

  // addBills(GlobalModel invoiceModel, List<InvoiceRecordModel> record, isEdit, {bool withLogger = false}) async {
  //
  //   print("Start ADD${invoiceModel.invId}");
  //   if (!invoiceModel.invPrimaryAccount!.contains("acc")) invoiceModel.invPrimaryAccount = getAccountIdFromText(invoiceModel.invPrimaryAccount);
  //   if (!invoiceModel.invSecondaryAccount!.contains("acc")) invoiceModel.invSecondaryAccount = getAccountIdFromText(invoiceModel.invSecondaryAccount);
  //   if (!invoiceModel.invSeller!.contains("seller")) invoiceModel.invSeller = getSellerIdFromText(invoiceModel.invSeller);
  //   if (!invoiceModel.invStorehouse!.contains("store")) invoiceModel.invStorehouse = getStoreIdFromText(invoiceModel.invStorehouse);
  //   for (var element in record) {
  //     if (!(element.invRecProduct?.contains("prod") ?? true)) record[record.indexOf(element)].invRecProduct = productController.searchProductIdByName(element.invRecProduct);
  //   }
  //   if (!invCodeList.contains(invoiceModel.invCode)) {
  //     bondController.tempBondModel = GlobalModel();
  //     bondController.bondModel = GlobalModel();
  //     bondController.tempBondModel.bondRecord = [];
  //     bondController.tempBondModel.originId = invoiceModel.invId;
  //     bondController.tempBondModel.bondTotal = "0.00";
  //     bondController.tempBondModel.bondType = Const.bondTypeDaily;
  //     bondController.tempBondModel.bondId = invoiceModel.originId;
  //     if (!isEdit) {
  //       String bondId = generateId(RecordType.bond);
  //       bondController.tempBondModel.bondId = bondId;
  //       invoiceModel.originId = bondId;
  //       var bondCode = (int.parse(bondController.allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1).toString();
  //       while (bondController.allBondsItem.values.toList().map((e) => e.bondCode).toList().contains(bondCode)) {
  //         bondCode = (int.parse(bondCode) + 1).toString();
  //       }
  //       invoiceModel.bondCode = bondCode;
  //     }
  //     bondController.tempBondModel.bondCode = invoiceModel.bondCode;
  //     // productController.saveInvInProduct(record, invoiceModel.invId, invoiceModel.invType);
  //     storeViewController.saveInvInStore(record, invoiceModel.invId, invoiceModel.invType,invoiceModel.invStorehouse);
  //     bool isHasVat = patternController.patternModel[invoiceModel.patternId]!.patHasVat!;
  //     switch (invoiceModel.invType) {
  //       case Const.invoiceTypeSales:
  //         {
  //           await addInvoiceRecordToAccount(-1 * invoiceModel.invTotal!, invoiceModel.invPrimaryAccount!, invoiceModel.originId!);
  //           await addInvoiceRecordToAccount(invoiceModel.invTotal!, invoiceModel.invSecondaryAccount!, invoiceModel.originId!);
  //           await addInvoice(invoiceModel, record);
  //           sellerViewController.postRecord(userId: invoiceModel.invSeller!, invId: invoiceModel.invId, amount: invoiceModel.invTotal!, date: dateController);
  //           productController.saveInvInProduct(record, invoiceModel.invId, invoiceModel.invType,invoiceModel.invDate);
  //           print("end ADD${invoiceModel.invId}");
  //           if (isHasVat && computeVatTotal().toStringAsFixed(2) != "0.00") {
  //             bondController.tempBondModel.bondRecord!.add(BondRecordModel("02", computeVatTotal(), 0, patternController.patternModel[invoiceModel.patternId]!.patVatAccount, "ضريبة القيمة المضافة", invId: invoiceModel.originId!));
  //             bondController.tempBondModel.bondRecord!.add(BondRecordModel("03", 0, computeVatTotal(), invoiceModel.invSecondaryAccount, "ضريبة القيمة المضافة", invId: invoiceModel.originId!));
  //           }
  //         }
  //         break;
  //       case Const.invoiceTypeBuy:
  //         {
  //           await addInvoiceRecordToAccount(invoiceModel.invTotal!, invoiceModel.invPrimaryAccount!, invoiceModel.invId!);
  //           await addInvoiceRecordToAccount(-1 * invoiceModel.invTotal!, invoiceModel.invSecondaryAccount!, invoiceModel.invId!);
  //           await addInvoice(invoiceModel, record);
  //           productController.saveInvInProduct(record, invoiceModel.invId, invoiceModel.invType,invoiceModel.invDate);
  //           if (isHasVat && computeVatTotal().toStringAsFixed(2) != "0.00") {
  //             bondController.tempBondModel.bondRecord!.add(BondRecordModel("02", 0, computeVatTotal(), patternController.patternModel[invoiceModel.patternId]!.patVatAccount, "ضريبة القيمة المضافة", invId: invoiceModel.originId!));
  //             bondController.tempBondModel.bondRecord!.add(BondRecordModel("03", computeVatTotal(), 0, invoiceModel.invSecondaryAccount, "ضريبة القيمة المضافة", invId: invoiceModel.originId!));
  //           }
  //         }
  //         break;
  //       // case "due sales":
  //       //   {
  //       //     await addInvoiceRecordToAccount(-1 * invoiceModel.invTotal!, invoiceModel.invPrimaryAccount!, invoiceModel.originId!);
  //       //     await addInvoiceRecordToAccount(invoiceModel.invTotal!, invoiceModel.invSecondaryAccount!, invoiceModel.originId!);
  //       //     await addInvoice(invoiceModel, record);
  //       //     productController.saveInvInProduct(record, invoiceModel.invId, invoiceModel.invType);
  //       //     print("end ADD${invoiceModel.invId}");
  //       //   }
  //       //   break;
  //     }
  //
  //     if (withLogger) {
  //       logger(newData: invoiceModel);
  //     }
  //
  //     invoiceAllDataGridSource.updateDataGridSource();
  //     bondController.postOneBond(false);
  //     print(invoiceModel.invId!);
  //     buildInvInit(true, invoiceModel.invId!);
  //    // showEInvoiceDialog(mobileNumber: invoiceModel.invMobileNumber!, invId: invoiceModel.invId!);
  //     update();
  //     print("end ADD${invoiceModel.invId}");
  //   } else {
  //     Get.snackbar("رقم الفاتورة موجود يا عكروت", "اختار غير رقم يا مطيح");
  //   }
  // }
  //
  // // addInvoiceRecordToAccount(double amount, String account, String billId,) async {
  // //   print("Start addInvoiceRecordToAccount  account: $account  billId: $billId total: $total");
  // //   if (amount < 0) {
  // //     bondController.tempBondModel.bondRecord!.add(BondRecordModel("00", computeWithoutVatTotal(), 0, account, "تم توليده من الفاتورة", invId: billId));
  // //   } else {
  // //     bondController.tempBondModel.bondRecord!.add(BondRecordModel("01", 0, computeWithoutVatTotal(), account, "تم توليده من الفاتورة", invId: billId));
  // //   }
  // //   print("End addInvoiceRecordToAccount  account: $account  billId: $billId total: $total");
  // // }
  // //
  // // updateInvoice(GlobalModel initalModle, GlobalModel invoiceModel, List<InvoiceRecordModel> record, String bondId, {bool withLogger = false}) async {
  // //   print("start update");
  // //   record.forEach((element) {
  // //     if (!(element.invRecProduct?.contains("prod") ?? true)) record[record.indexOf(element)].invRecProduct = productController.searchProductIdByName(element.invRecProduct);
  // //   });
  // //   if (invoiceModel.invCode != initalModle.invCode) {
  // //     if (!invCodeList.contains(invoiceModel.invCode)) {
  // //       await deleteBills(initalModle);
  // //       invoiceModel.originId = initalModle.originId;
  // //       invoiceModel.bondCode = initalModle.bondCode;
  // //       invoiceModel.invId = initalModle.invId;
  // //       invoiceModel.invCode = initalModle.invCode;
  // //       invoiceModel.invRecords = record;
  // //       if (withLogger) {
  // //         logger(newData: invoiceModel, oldData: initalModle);
  // //       }
  // //       await addBills(invoiceModel, record, true);
  // //     } else {
  // //       Get.snackbar("رقم الفاتورة موجود يا عكروت", "اختار غير رقم يا مطيح");
  // //     }
  // //   } else {
  // //     await deleteBills(initalModle);
  // //     invoiceModel.originId = initalModle.originId;
  // //     invoiceModel.bondCode = initalModle.bondCode;
  // //     invoiceModel.invId = initalModle.invId;
  // //     invoiceModel.invCode = initalModle.invCode;
  // //     invoiceModel.invRecords = record;
  // //     invCodeList.clear();
  // //     if (withLogger) {
  // //       logger(newData: invoiceModel, oldData: initalModle);
  // //     }
  // //     await addBills(invoiceModel, record, true);
  // //   }
  // //   getInvCode();
  // //   update();
  // // }
  // // deleteBills(GlobalModel invoiceModel, {bool withLogger = false}) async {
  // //   print("Start Delete Invoice  deleteBills(GlobalModel ${invoiceModel.toJson()} ");
  // //   invoiceModel.invRecords?.forEach((element) {
  // //     if (!(element.invRecProduct?.contains("prod") ?? true)) invoiceModel.invRecords?[invoiceModel.invRecords!.indexOf(element)].invRecProduct = productController.searchProductIdByName(element.invRecProduct);
  // //   });
  // //   if (withLogger) {
  // //     logger(newData: invoiceModel);
  // //   }
  // //   productController.deleteInvFromProduct(invoiceModel.invRecords ?? [], invoiceModel.invId!);
  // //   sellerViewController.deleteRecord(userId: invoiceModel.invSeller!, invId: invoiceModel.invId);
  // //   storeViewController.deleteRecord(storeId: invoiceModel.invStorehouse!, invId: invoiceModel.invId);
  // //  // await deleteInvoice(invoiceModel.invId!, invoiceModel.originId!);
  // //   await removeBondFromAccount(invoiceModel.invPrimaryAccount!, invoiceModel.originId!);
  // //   await removeBondFromAccount(invoiceModel.invSecondaryAccount!, invoiceModel.originId!);
  // //   invoiceAllDataGridSource.updateDataGridSource();
  // //   update();
  // //   print("End Delete Invoice  deleteBills(GlobalModel ${invoiceModel.toJson()} ");
  // // }
  //
  // // deleteInvoice(String billId, String bondId) async {
  // //   await _invoicesCollectionRef.doc(billId).collection('invRecord').get().then((docSnapshot) async {
  // //     for (QueryDocumentSnapshot docSnapshot in docSnapshot.docs) {
  // //       await docSnapshot.reference.delete();
  // //     }
  // //   });
  // //   await _bondCollectionRef.doc(bondId).collection(Const.recordCollection).get().then((docSnapshot) async {
  // //     for (QueryDocumentSnapshot docSnapshot in docSnapshot.docs) {
  // //       await docSnapshot.reference.delete();
  // //     }
  // //   });
  // //   await _invoicesCollectionRef.doc(billId).delete();
  // //   await _bondCollectionRef.doc(bondId).delete();
  // //
  // //   update();
  // //   print("End delete");
  // // }
  //
  // removeBondFromAccount(String account, String bondId) async {
  //   print("Start Delete Invoice From Account  removeInvoiceFromAccount(String $account, String $bondId)");
  //   accountPickList.clear();
  //   accountController.accountList.forEach((key, value) {
  //     if (account.toLowerCase() == value.accId!.toLowerCase() || account.toLowerCase() == value.accName!.toLowerCase()) {
  //       _accountCollectionRef.doc(key).collection(Const.recordCollection).doc(bondId).delete();
  //     }
  //   });
  //
  //   print("End Delete Invoice From Account  removeInvoiceFromAccount(String $account, String $bondId)");
  //   // });
  // }

  bool checkInvCode() {
    return nextPrevList.keys.toList().contains(invCodeController.text);
  }

  buildSource(String billId) {
    records = invoiceModel[billId]!.invRecords! + [InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault)];
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: secondaryAccountController.text == "" ? "a" : getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
  }

  buildSourceRecent(GlobalModel model) {
    records = model.invRecords! + [InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault)];
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: secondaryAccountController.text == "" ? "a" : getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
  }

  buildDiscountSource(String billId) {
    discountRecords = invoiceModel[billId]!.invDiscountRecord! + [InvoiceDiscountRecordModel()];
    invoiceDiscountRecordSource = InvoiceDiscountRecordSource(records: discountRecords);
  }

  buildDiscountSourceRecent(GlobalModel model) {
    discountRecords = model.invDiscountRecord! + [InvoiceDiscountRecordModel()];
    invoiceDiscountRecordSource = InvoiceDiscountRecordSource(records: discountRecords);
  }

  rebuildDiscount() {
    double totalWithoutVat = computeWithoutVatTotal();
    for (InvoiceDiscountRecordModel model in discountRecords) {
      if (model.discountId != null) {
        if ((model.discountTotal ?? 0) > 0) {
          if (model.isChooseDiscountTotal == true) {
            model.discountPercentage = model.discountTotal! / totalWithoutVat;
          } else if (model.isChooseDiscountTotal == false) {
            model.discountTotal = totalWithoutVat * model.discountPercentage! / 100;
          }
        } else if ((model.addedTotal ?? 0) > 0) {
          if (model.isChooseAddedTotal == true) {
            model.addedPercentage = model.addedTotal! / totalWithoutVat;
          } else if (model.isChooseAddedTotal == false) {
            model.addedTotal = totalWithoutVat * model.addedPercentage! / 100;
          }
        }
      }
    }
    invoiceDiscountRecordSource = InvoiceDiscountRecordSource(records: discountRecords);
    update();
  }

  invNextOrPrev(String patId, invCode, bool isPrev) {
    List<GlobalModel> inv = invoiceModel.values.where((element) => element.patternId == patId).toList().reversed.toList();
    inv.sort(
      (a, b) {
        if (a.invCode!.startsWith("F") && b.invCode!.startsWith("F")) {
          return int.parse((a.invCode ?? "F-0").split("F-")[1]).compareTo(int.parse((b.invCode ?? "F-0").split("F-")[1]));
        } else if (a.invCode!.startsWith("F")) {
          return int.parse((a.invCode ?? "F-0").split("F-")[1]).compareTo(int.parse(b.invCode ?? "0"));
        } else if (b.invCode!.startsWith("F")) {
          return int.parse((a.invCode ?? "0")).compareTo(int.parse((b.invCode ?? "F-0").split("F-")[1]));
        } else {
          return int.parse(a.invCode ?? "0").compareTo(int.parse(b.invCode ?? "0"));
        }
      },
    );
    int currentPosition = inv.indexOf(inv
            .where(
              (element) => element.invCode == invCode,
            )
            .firstOrNull ??
        inv.last);


    if (isPrev) {
      if (currentPosition != 0) {
        if(inv.where((element) => element.invCode == invCode,).isNotEmpty) {
          buildInvInit(true, inv[currentPosition - 1].invId!);
        }
        else{
          buildInvInit(true, inv.last.invId!);
        }
      }
    } else {
      if (currentPosition < inv.length-1) {
        buildInvInit(true, inv[currentPosition + 1].invId!);
      }
    }
    update();
  }

  getInvByInvCode(String patId, invCode) {
    List<GlobalModel> inv = invoiceModel.values.where((element) => element.patternId == patId && element.invCode == invCode).toList();
    if (inv.isNotEmpty) {
      buildInvInit(true, inv.first.invId!);
    } else {
      Get.snackbar("خطأ رقم الفاتورة", "رقم الفاتورة غير موجود",
          icon: const Icon(
            Icons.error, color: Colors.red, textDirection: TextDirection.rtl,

          ));
      invCodeController.text=initModel.invCode??"";
    }

    update();
  }

  nextInv(String patId, invCode) {
    var inv = invoiceModel.values.toList().firstWhereOrNull((element) => element.invCode == invCode);
    if (inv == null) {
    } else {
      var index = nextPrevList.values.toList().indexOf(inv.invId!);
      if (nextPrevList.values.toList().last == nextPrevList[index]) {
        getInit(patId);
      } else {
        buildInvInit(true, nextPrevList.values.toList()[index + 1]);
      }
      update();
    }
  }

  //init new inv
  getInit(String patternId) {
    initModel = GlobalModel();
    initModel.patternId = patternId;
    initCodeList(patternId);
    PatternModel patternModel = patternController.patternModel[patternId]!;
    invCodeController.text = getNextCodeInv();
    initModel.invGiftAccount = patternModel.patGiftAccount;
    initModel.invSecGiftAccount = patternModel.patSecGiftAccount;
    var vat = "a";
    if (patternModel.patType != Const.invoiceTypeChange) {
      primaryAccountController.text = getAccountNameFromId(patternModel.patPrimary!);
      secondaryAccountController.text = getAccountNameFromId(patternModel.patSecondary!);
      vat = accountController.accountList[patternModel.patSecondary!]!.accVat!;
    } else {
      primaryAccountController.clear();
      secondaryAccountController.clear();
      storeNewController.text = getStoreNameFromId(patternModel.patNewStore!);
    }
    storeController.text = getStoreNameFromId(patternModel.patStore!);
    entryBondIdController.clear();
    if (patternModel.patColor != null) {
      colorInvoice = patternModel.patColor!;
    }
    invCustomerAccountController.clear();
    noteController.clear();
    billIDController.clear();
    mobileNumberController.clear();
    if (getMyUserSellerId() != null) {
      sellerController.text = getSellerNameFromId(getMyUserSellerId());
    }
    dateController = DateTime.now().toString().split(".")[0];
    records = [...List.generate(5, (index) => InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault))];
    discountRecords = List.generate(3, (index) => InvoiceDiscountRecordModel());
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: vat);
    invoiceDiscountRecordSource = InvoiceDiscountRecordSource(
      records: discountRecords,
    );
  }

  ScreenViewModel screenViewModel = Get.find<ScreenViewModel>();

  initCodeList(patternId) {
    nextPrevList = Map.fromEntries(invoiceModel.values.where((element) => element.patternId == patternId).map((e) => MapEntry(e.invCode!, e.invId!)).toList());

    // if (screenViewModel.openedScreen.values.where((element) => element.patternId == patternId).isEmpty) {
    //   nextPrevList = Map.fromEntries(invoiceModel.values.where((element) => element.patternId == patternId).map((e) => MapEntry(e.invCode!, e.invId!)).toList());
    // } else {
    //   nextPrevList = Map.fromEntries(screenViewModel.openedScreen.values.where((element) => element.patternId == patternId).map((e) => MapEntry(e.invCode!, e.invId!)).toList());
    // }
  }

  String getNextCodeInv() {
    int _ = 0;
    if (nextPrevList.isEmpty) {
      return "0";
    } else {
      _ = int.parse(nextPrevList.keys.where((e) => !e.contains("F-")).last);
      while (nextPrevList.containsKey(_.toString())) {
        _++;
      }
    }
    return _.toString();
  }

  //int old inv
  buildInvInit(bool bool, String invId) {

    if (bool) {
      initModel = invoiceModel[invId]!;
    }
    invReturnCodeController.text=initModel.invReturnCode??'';
    invReturnDateController.text=initModel.invReturnDate??'';
    // typeBill = patternController.patternModel[initModel.patternId]!.patType!;
    invCustomerAccountController.text = initModel.invCustomerAccount != null ? getAccountNameFromId(initModel.invCustomerAccount) : "";
    storeController.text = getStoreNameFromId(initModel.invStorehouse);
    billIDController.text = initModel.invId!;
    PatternModel patternModel = patternController.patternModel[initModel.patternId]!;
    initModel.invGiftAccount = patternModel.patGiftAccount;
    initModel.invSecGiftAccount = patternModel.patSecGiftAccount;
    if (patternController.patternModel[initModel.patternId]!.patColor != null) {
      colorInvoice = patternController.patternModel[initModel.patternId]!.patColor!;
    }

    if (patternModel.patType != Const.invoiceTypeChange && patternModel.patType != Const.invoiceTypeAdd) {
      secondaryAccountController.text = getAccountNameFromId(initModel.invSecondaryAccount!);
      primaryAccountController.text = getAccountNameFromId(initModel.invPrimaryAccount!);
      sellerController.text = getSellerNameFromId(initModel.invSeller);
    } else {
      primaryAccountController.clear();
      secondaryAccountController.clear();
      storeNewController.text = getStoreNameFromId(initModel.invSecStorehouse);
    }
    mobileNumberController.text = initModel.invMobileNumber ?? "";
    noteController.text = initModel.invComment!;
    entryBondIdController.text = initModel.entryBondId ?? "";
    invCodeController.text = initModel.invCode!;
    dateController = initModel.invDate;
    firstPayController.text = initModel.firstPay.toString();

    // dateController = initModel.invDate!;
    initCodeList(initModel.patternId);

    Get.find<InvoicePlutoViewModel>().getRows(initModel.invRecords ?? []);
    // buildSource(initModel.invId!);
    // buildDiscountSource(initModel.invId!);

    if (!bool) {
      update();
    }
  }

  buildInvInitRecent(GlobalModel model) {
    initModel = model;
    invReturnCodeController.text=initModel.invReturnCode??'';
    invReturnDateController.text=initModel.invReturnDate??'';
    // typeBill = patternController.patternModel[initModel.patternId]!.patType!;
    invCustomerAccountController.text = initModel.invCustomerAccount != null ? getAccountNameFromId(initModel.invCustomerAccount) : "";
    storeController.text = getStoreNameFromId(initModel.invStorehouse);
    billIDController.text = initModel.invId!;
    PatternModel patternModel = patternController.patternModel[initModel.patternId]!;
    initModel.invGiftAccount = patternModel.patGiftAccount;
    initModel.invSecGiftAccount = patternModel.patSecGiftAccount;
    if (patternController.patternModel[initModel.patternId]!.patColor != null) {
      colorInvoice = patternController.patternModel[initModel.patternId]!.patColor!;
    }

    if (patternModel.patType != Const.invoiceTypeChange && patternModel.patType != Const.invoiceTypeAdd) {
      secondaryAccountController.text = getAccountNameFromId(initModel.invSecondaryAccount!);
      primaryAccountController.text = getAccountNameFromId(initModel.invPrimaryAccount!);
      sellerController.text = getSellerNameFromId(initModel.invSeller);
    } else {
      primaryAccountController.clear();
      secondaryAccountController.clear();
      storeNewController.text = getStoreNameFromId(initModel.invSecStorehouse);
    }
    mobileNumberController.text = initModel.invMobileNumber ?? "";
    noteController.text = initModel.invComment!;
    entryBondIdController.text = initModel.entryBondId ?? "";
    invCodeController.text = initModel.invCode!;
    firstPayController.text = initModel.firstPay.toString();
    dateController = initModel.invDate;
    // dateController = initModel.invDate!;
    initCodeList(initModel.patternId);

    // buildSourceRecent(initModel);
    // buildDiscountSourceRecent(initModel);

    // update();
  }

  bool checkAllRecord() {
    for (var element in records) {
      return (element.invRecProduct == "" || element.invRecProduct == null || (element.invRecQuantity == 0 && element.invRecGift == 0) || element.invRecQuantity == null);
    }
    return false;
  }

  bool checkAllDiscountRecords() {
    // for (var element in discountRecords) {

    //   if(( element.discountId != null && (element.accountId == null || element.percentage == null || element.total == null))){
    //       return true;
    //   }

    // }
    // double _total =0;
    // if(discountRecords.length>1){
    //   total = discountRecords.map((e)=>e.total??0).reduce((value, element) => value+element);
    // }else if (discountRecords.length == 1){
    //   total =discountRecords.first.total??0;
    // }
    // if(_total>computeWithoutVatTotal()){

    //     return true;
    // }
    return false;
  }

  bool checkAllRecordPrice() {
    for (var element in records) {
      if (element.invRecId != null && element.invRecQuantity! > 0) {
        return (double.parse(getProductModelFromId(element)!.prodMinPrice ?? "0")) > element.invRecTotal!;
      }
    }
    return false;
  }

  getStoreComplete() async {
    storePickList = [];
    // var userInput = storeController.text;
    // storeController.clear();
    storeViewController.storeMap.forEach((key, value) {
      storePickList.addIf(value.stCode!.toLowerCase().contains(storeController.text.toLowerCase()) || value.stName!.toLowerCase().contains(storeController.text.toLowerCase()), value.stName!);
    });
    if (storePickList.length > 1) {
      await Get.defaultDialog(
        title: "اختر احد المستودعات",
        content: SizedBox(
          height: Get.height / 2,
          width: Get.height / 2,
          child: ListView.builder(
            itemCount: storePickList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  storeController.text = storePickList[index];
                  Get.back();
                  update();
                },
                child: Container(
                  padding: const EdgeInsets.all(5),
                  margin: const EdgeInsets.all(8),
                  width: 500,
                  child: Center(
                    child: Text(
                      storePickList[index],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else if (storePickList.length == 1) {
      storeController.text = storePickList[0];
    } else {
      storeController.clear();
      Get.snackbar("فحص المطاييح", "هذا المطيح غير موجود من قبل");
    }
  }

  bool checkAccountComplete(String text) {
    return accountController.accountList.values.map((e) => e.accName?.toLowerCase()).toList().contains(text.toLowerCase());
  }

  bool checkStoreComplete() {
    return storeViewController.storeMap.values.map((e) => e.stName?.toLowerCase()).toList().contains(storeController.text.toLowerCase());
  }

  bool checkStoreNewComplete() {
    return storeViewController.storeMap.values.map((e) => e.stName?.toLowerCase()).toList().contains(storeNewController.text.toLowerCase());
  }

  bool checkSellerComplete() {
    return sellerViewController.allSellers.values.map((e) => e.sellerName?.toLowerCase()).toList().contains(sellerController.text.toLowerCase());
  }

  getInvCode() {
    invIdList = [];
    invCodeList = [];
    invoiceModel.forEach((key, value) {
      invIdList.add(value.invId!);
      invCodeList.add(value.invCode!);
      patternList.add(value.patternId!);
    });
  }

  // viewPattern() {
  //   _pattern.clear();
  //   patternController.patternModel.forEach((key, value) {
  //     _pattern.add(value);
  //   });
  //   Get.defaultDialog(
  //     title: "Chose form dialog",
  //     content: SizedBox(
  //       width: 500,
  //       height: 500,
  //       child: ListView.builder(
  //         itemCount: _pattern.length,
  //         itemBuilder: (context, index) {
  //           return InkWell(
  //             onTap: () {
  //               Get.back();
  //               Get.to(()=>InvoiceView(billId: '1', patternId: _pattern[index].patId!));
  //             },
  //             child: Container(
  //               padding: const EdgeInsets.all(5),
  //               margin: const EdgeInsets.all(8),
  //               width: 500,
  //               child: Center(
  //                 child: Text(
  //                   _pattern[index].patName.toString(),
  //                 ),
  //               ),
  //             ),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  void addProductToInvoice(List<ProductModel> result) {
    double vat = getVatFromName(getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
    List<InvoiceRecordModel> newRecord = [];
    bool isPatternHasVat = patternController.patternModel[initModel.patternId]!.patHasVat!;

    for (var i = 0; i < result.length; i++) {
      var _ = InvoiceRecordSource(records: [], accountVat: '');
      var price = (_.getPrice(Const.invoiceChoosePriceMethodeDefault, result[i].prodId));
      newRecord.insert(i, InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault));
      newRecord[i].invRecProduct = result[i].prodId!.toString();
      newRecord[i].invRecId = (i + 1).toString();
      newRecord[i].prodChoosePriceMethod = Const.invoiceChoosePriceMethodeDefault;
      newRecord[i].invRecSubTotal = price / (result[i].prodIsLocal! ? (vat + 1) : 1);
      newRecord[i].invRecVat = !isPatternHasVat
          ? 0
          : (result[i].prodIsLocal ?? false)
              ? (price - (price / (vat + 1)))
              : 0;
      newRecord[i].invRecQuantity = 1;
    }

    // onCellTap(rowColumnIndex);
    records.removeWhere((element) => element.invRecProduct == null);
    records = records + newRecord + [InvoiceRecordModel(prodChoosePriceMethod: Const.invoiceChoosePriceMethodeDefault)];
    for (var i = 0; i < records.length - 1; i++) {
      records[i].invRecId = (i + 1).toString();
    }
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
    update();
  }

  void deleteOneRecord(int index) {
    records.removeAt(index);
    for (var i = 0; i < records.length - 1; i++) {
      records[i].invRecId = (i + 1).toString();
    }
    invoiceRecordSource = InvoiceRecordSource(records: records, accountVat: getAccountModelFromId(getAccountIdFromText(secondaryAccountController.text))!.accVat!);
    update();
  }

  double getTotal(double input) {
    double totalWithoutVat = computeWithoutVatTotal();

    return totalWithoutVat * input / 100;
  }

  double getPercentage(double input) {
    double totalWithoutVat = computeWithoutVatTotal();
    return input / totalWithoutVat * 100;
  }

  void copyInvoice(GlobalModel initModel) {
    String _ = "";
    for (var i = 0; i < records.length; i++) {}
  }
}

void showEIknvoiceDialog({required String mobileNumber, required String invId}) {
  Get.defaultDialog(
      title: "فاتورتك الرقمية",
      content: SizedBox(
        height: Get.height / 1.8,
        width: Get.height / 1.8,
        child: Column(
          children: [
            QrImageView(
              data: 'https://ba3-business-solutions.firebaseapp.com/?id=' + invId + '&year=' + Const.dataName,
              version: QrVersions.auto,
              size: Get.height / 2.5,
            ),
            //SizedBox(height: 20,),
            Text(
              "مشاركة عبر",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            //SizedBox(height: 20,),
            Row(
              children: [
                InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(
                        text: 'https://ba3-business-solutions.firebaseapp.com/?id=' + invId + '&year=' + Const.dataName,
                      ));
                    },
                    child: CircleAvatar(
                      radius: 30,
                      child: Icon(
                        Icons.copy,
                        color: Colors.grey.shade300,
                      ),
                      backgroundColor: Colors.grey,
                    )),
                SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.chat_bubble),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: Text("موافق"))
      ]);
}

getInvoicePatternFromInvId(id) {
  GlobalModel globalModel = Get.find<InvoiceViewModel>().invoiceModel[id]!;
  return "${getPatModelFromPatternId(globalModel.patternId).patName!} : ${globalModel.invCode!}";
}
