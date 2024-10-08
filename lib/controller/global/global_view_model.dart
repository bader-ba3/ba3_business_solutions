import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/bond/entry_bond_view_model.dart';
import 'package:ba3_business_solutions/controller/cheque/cheque_view_model.dart';
import 'package:ba3_business_solutions/controller/global/changes_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store/store_view_model.dart';
import 'package:ba3_business_solutions/controller/user/user_management_model.dart';
import 'package:ba3_business_solutions/core/utils/generate_id.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../core/constants/app_strings.dart';
import '../../core/helper/functions/functions.dart';
import '../../model/bond/bond_record_model.dart';
import '../../model/bond/entry_bond_record_model.dart';
import '../../model/invoice/invoice_discount_record_model.dart';
import '../../view/main/main_screen.dart';
import '../databsae/import_view_model.dart';
import '../invoice/invoice_view_model.dart';

class GlobalViewModel extends GetxController {
  // Map<String, GlobalModel> allGlobalModel = {};
  bool isDrawerOpen = true;
  ProductViewModel productController = Get.find<ProductViewModel>();
  StoreViewModel storeController = Get.find<StoreViewModel>();
  BondViewModel bondViewModel = Get.find<BondViewModel>();
  InvoiceViewModel invoiceViewModel = Get.find<InvoiceViewModel>();
  AccountViewModel accountViewModel = Get.find<AccountViewModel>();
  EntryBondViewModel entryBondViewModel = Get.find<EntryBondViewModel>();
  SellersViewModel sellerViewModel = Get.find<SellersViewModel>();
  ChequeViewModel chequeViewModel = Get.find<ChequeViewModel>();
  bool isEdit = false;

  GlobalViewModel() {
    initFromLocal();
  }

  RxInt count = 0.obs;
  int allCountOfInvoice = 0;

  /// forEach on all item it's [SoSlow].
  Future<void> initFromLocal() async {
    // allGlobalModel.clear();
    print("-" * 20);
    print("YOU RUN SHORT TIME OPERATION");
    print("-" * 20);
    // allGlobalModel = Map.fromEntries(HiveDataBase.globalModelBox.values
    //     .map((e) => MapEntry(e.entryBondId ?? e.bondId!, e))
    //     .toList());

    ///TODo: خليها اذا رح نجيب شي من الفيربيز
    /*  if (false) {
      await FirebaseFirestore.instance
          .collection(AppStrings.globalCollection)
          .get()
          .then((value) async {
        print("start Firebase");
        count = 0.obs;
        allCountOfInvoice = value.docs.length;
        update();
        print(value.docs.length);
        for (var element in value.docs) {
          await Future.sync(() async {
            count.value++;
            print(count.toString());
            // for (var element in value.docChanges) {
            if (element.data()['isDeleted'] != null &&
                element.data()['isDeleted']) {
              if (HiveDataBase.globalModelBox.keys.contains(element.id)) {
                deleteGlobal(HiveDataBase.globalModelBox.get(element.id)!);
              }
              // } else if (!getNoVAt(element.doc.id)) {
            } else {
              if (element.data()['bondType'] != AppStrings.bondTypeInvoice) {
                allGlobalModel[element.id] =
                    GlobalModel.fromJson(element.data());
                allGlobalModel[element.id]?.invRecords = [];
                allGlobalModel[element.id]?.bondRecord = [];
                allGlobalModel[element.id]?.cheqRecords = [];
                if (allGlobalModel[element.id]!.globalType ==
                    AppStrings.globalTypeInvoice) {
                  await FirebaseFirestore.instance
                      .collection(AppStrings.globalCollection)
                      .doc(element.id)
                      .collection(AppStrings.invoiceRecordCollection)
                      .get()
                      .then((value) {
                    allGlobalModel[element.id]?.invRecords = value.docs
                        .map((e) => InvoiceRecordModel.fromJson(e.data()))
                        .toList();
                  });
                } else if (allGlobalModel[element.id]!.globalType ==
                    AppStrings.globalTypeCheque) {
                  await FirebaseFirestore.instance
                      .collection(AppStrings.globalCollection)
                      .doc(element.id)
                      .collection(AppStrings.chequeRecordCollection)
                      .get()
                      .then((value) {
                    allGlobalModel[element.id]?.cheqRecords = value.docs
                        .map((e) => ChequeRecModel.fromJson(e.data()))
                        .toList();
                  });
                } else if (allGlobalModel[element.id]!.globalType ==
                    AppStrings.globalTypeBond) {
                  await FirebaseFirestore.instance
                      .collection(AppStrings.globalCollection)
                      .doc(element.id)
                      .collection(AppStrings.bondRecordCollection)
                      .get()
                      .then((value) {
                    allGlobalModel[element.id]?.bondRecord = value.docs
                        .map((e) => BondRecordModel.fromJson(e.data()))
                        .toList();
                  });
                }
              }
              HiveDataBase.globalModelBox.put(
                  allGlobalModel[element.id]?.entryBondId,
                  allGlobalModel[element.id]!);
              // updateDataInAll(allGlobalModel[element.id]!);
            }
          });
        }
      });
    } else*/
    {
      print("start");
      count = 0.obs;
      allCountOfInvoice = HiveDataBase.globalModelBox.values.length;
      update();

      for (var value in HiveDataBase.globalModelBox.values) {
        await initUpdateDataInAll(value);
      }

      if (Get.currentRoute == "/LoginView") {
        Get.offAll(() => const MainScreen());
      }
    }
  }

  changeFreeType(type) async {
    // print("chang type off free to $type");

    /* Const.init(isFree: type);
    await Get.deleteAll(force: true);
    Get.put(UserManagementViewModel(), permanent: true);
    Get.put(AccountViewModel(), permanent: true);
    Get.put(StoreViewModel(), permanent: true);
    Get.put(ProductViewModel(), permanent: true);
    Get.put(BondViewModel(), permanent: true);
    Get.put(PatternViewModel(), permanent: true);
    Get.put(SellersViewModel(), permanent: true);
    Get.put(InvoiceViewModel(), permanent: true);
    Get.put(ChequeViewModel(), permanent: true);
    Get.put(CostCenterViewModel(), permanent: true);
    Get.put(IsolateViewModel(), permanent: true);
    Get.put(DataBaseViewModel(), permanent: true);
    Get.put(ImportViewModel(), permanent: true);
    Get.put(CardsViewModel(), permanent: true);
    Get.put(PrintViewModel(), permanent: true);
    Get.offAll(
      () => const UserManagement(),
      binding: GetBinding(),
    );*/
  }

  /////-Add
  addGlobalBond(GlobalModel globalModel) async {
    globalModel.bondDate = DateTime.now().toString();
    globalModel.globalType = AppStrings.globalTypeBond;
    globalModel.bondId = generateId(RecordType.bond);
    // globalModel.entryBondId = generateId(RecordType.entryBond);
    globalModel.entryBondCode = getNextEntryBondCode().toString();

    // addGlobalToLocal(globalModel);
    updateDataInAll(globalModel);
    addBondToFirebase(globalModel);
    bondViewModel.tempBondModel = globalModel;
    bondViewModel.update();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppStrings.bondsCollection);
    update();
  }

  void addGlobalBondToMemory(GlobalModel globalModel) {
    // addGlobalToLocal(globalModel);
    // updateDataInAll(globalModel);
    HiveDataBase.globalModelBox.put(globalModel.bondId!, globalModel);
    bondViewModel.allBondsItem[globalModel.bondId!] = globalModel;

    bondViewModel.update();
    update();
  }

  void addGlobalCheque(GlobalModel globalModel) {
    // globalModel.globalType = Const.globalTypeCheque;
    // globalModel.bondId = generateId(RecordType.bond);
    // globalModel.entryBondId = generateId(RecordType.entryBond);

    updateDataInAll(globalModel);
    chequeViewModel.update();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    addChequeToFirebase(globalModel);
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppStrings.chequesCollection);
    update();
  }

  void addGlobalInvoice(GlobalModel globalModel) {
    // GlobalModel correctedModel = correctInvRecord(globalModel);

    UserManagementViewModel myUser = Get.find<UserManagementViewModel>();
    if ((myUser.allRole[getMyUserRole()]?.roles[AppStrings.roleViewInvoice]?.contains(AppStrings.roleUserAdmin)) ?? false) {
      globalModel.invIsPending = false;
    } else {
      globalModel.invIsPending = true;
    }

    initGlobalInvoiceBond(globalModel);
    updateDataInAll(globalModel);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    addInvoiceToFirebase(globalModel);
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppStrings.invoicesCollection);
    // invoiceViewModel.updateCodeList();
    invoiceViewModel.initModel = globalModel;
    invoiceViewModel.invoiceModel[globalModel.invId!] = globalModel;

    invoiceViewModel.update();
    sendEmailWithPdfAttachment(globalModel);
  }

  void addGlobalInvoiceToMemory(GlobalModel globalModel) {
    // addGlobalToLocal(globalModel);
    // updateDataInAll(globalModel);

    HiveDataBase.globalModelBox.put(globalModel.invId!, globalModel);
    invoiceViewModel.invoiceModel[globalModel.invId!] = globalModel;

    invoiceViewModel.update();

    update();
  }

  void addGlobalChequeToMemory(GlobalModel globalModel) {
    // addGlobalToLocal(globalModel);
    // updateDataInAll(globalModel);
    HiveDataBase.globalModelBox.put(globalModel.cheqId!, globalModel);
    chequeViewModel.allCheques[globalModel.cheqId!] = globalModel;
    chequeViewModel.update();
    update();
  }

/*  void addGlobalToLocal(GlobalModel globalModel) {
    if (globalModel.invId != null) {
      HiveDataBase.globalModelBox.put(globalModel.invId, globalModel);
    } else {
      HiveDataBase.globalModelBox.put(globalModel.bondId, globalModel);
    }
  }*/

  ////-Update
  void updateGlobalInvoice(GlobalModel globalModel) {
    // GlobalModel correctedModel = correctInvRecord(globalModel);
    initGlobalInvoiceBond(globalModel);

    invoiceViewModel.invoiceModel[globalModel.invId!] = globalModel;
    updateDataInAll(globalModel);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    addInvoiceToFirebase(globalModel);
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppStrings.invoicesCollection);

    update();
    sendEmailWithPdfAttachment(globalModel);
  }

  Future<void> updateGlobalBond(GlobalModel globalModel) async {
    globalModel.entryBondId ??= generateId(RecordType.entryBond);
    bondViewModel.initGlobalBond(globalModel);
    await addBondToFirebase(globalModel);

    updateDataInAll(globalModel);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppStrings.bondsCollection);
    update();
  }

  void updateGlobalCheque(GlobalModel globalModel) {
    updateDataInAll(globalModel);
    addChequeToFirebase(globalModel);
    chequeViewModel.update();
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppStrings.chequesCollection);
    update();
  }

  ////--Delete
  void deleteGlobal(GlobalModel globalModel) {
    entryBondViewModel.deleteBondById(globalModel.entryBondId);
    if (globalModel.invId != null) {
      FirebaseFirestore.instance.collection(AppStrings.globalCollection).doc(globalModel.invId).set({"isDeleted": true}, SetOptions(merge: true));
    }
    if (globalModel.bondId != null) {
      FirebaseFirestore.instance.collection(AppStrings.globalCollection).doc(globalModel.bondId).set({"isDeleted": true}, SetOptions(merge: true));
    }
    deleteGlobalFromLocal(globalModel);
    // deleteDataInAll(globalModel);
    ChangesViewModel changesViewModel = Get.find<ChangesViewModel>();
    changesViewModel.addRemoveChangeToChanges(globalModel.toFullJson(), AppStrings.globalCollection);
    update();
  }

  void deleteGlobalMemory(GlobalModel globalModel) {
    deleteGlobalFromLocal(globalModel);
    // deleteDataInAll(globalModel);
    update();
  }

  void deleteGlobalFromLocal(GlobalModel globalModel) {
    if (globalModel.invId != null) {
      HiveDataBase.globalModelBox.put(globalModel.invId, globalModel..isDeleted = true);
    }
    if (globalModel.bondId != null) {
      HiveDataBase.globalModelBox.put(globalModel.bondId, globalModel..isDeleted = true);
    }
  }

  void deleteAllLocal() {
    HiveDataBase.globalModelBox.deleteFromDisk();
    HiveDataBase.accountModelBox.deleteFromDisk();
    HiveDataBase.storeModelBox.deleteFromDisk();
    HiveDataBase.productModelBox.deleteFromDisk();
    HiveDataBase.lastChangesIndexBox.deleteFromDisk();
    HiveDataBase.constBox.deleteFromDisk();
    HiveDataBase.isNewUser.deleteFromDisk();
  }

  ////-Utils
  GlobalModel correctInvRecord(GlobalModel globalModel) {
    GlobalModel correctedModel = GlobalModel.fromJson(globalModel.toFullJson());
    correctedModel.invRecords?.removeWhere((element) => element.invRecId == null);
    correctedModel.bondRecord?.removeWhere((element) => element.bondRecId == null);
    correctedModel.invDiscountRecord?.removeWhere((element) => element.discountId == null);
    for (var element in correctedModel.invRecords ?? []) {
      if (!(element.invRecProduct?.contains("prod") ?? true)) {
        globalModel.invRecords?[globalModel.invRecords!.indexOf(element)].invRecProduct = productController.searchProductIdByName(element.invRecProduct);
      }
    }
    for (BondRecordModel element in correctedModel.bondRecord ?? []) {
      if (!(element.bondRecAccount?.contains("acc") ?? true)) {
        globalModel.bondRecord?[globalModel.bondRecord!.indexOf(element)].bondRecAccount = getAccountIdFromText(element.bondRecAccount);
      }
    }
    return correctedModel;
  }

  addInvoiceToFirebase(GlobalModel globalModel) async {
/*    try {
      await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.entryBondId).collection(Const.invoiceRecordCollection).get().then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
    } catch (e) {}
    globalModel.invRecords?.forEach((element) async {
      await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.entryBondId).collection(Const.invoiceRecordCollection).doc(element.invRecId).set(element.toJson());
    });*/

    ///This for add to firebase
    /*  await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.invId).set(globalModel.toFullJson());
    if (globalModel.invMobileNumber != null && globalModel.invMobileNumber != '') {
      await FirebaseFirestore.instance.collection(Const.ba3Invoice).doc(globalModel.invMobileNumber).set({
        "listUrl": FieldValue.arrayUnion(['https://ba3-business-solutions.firebaseapp.com/?id=${globalModel.invId}&year=${Const.dataName}'])
      });
    }*/
    await Future.delayed(const Duration(milliseconds: 100));
    await HiveDataBase.globalModelBox.put(globalModel.invId, globalModel);
    print("end ${globalModel.entryBondId}  ${globalModel.invId}");
  }

  Future addBondToFirebase(GlobalModel globalModel) async {
    // print(globalModel.toFullJson());
    // await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.bondRecordCollection).get().then((value) async {
    //   for (var element in value.docs) {
    //     await element.reference.delete();
    //   }
    // });
    // globalModel.bondRecord?.forEach((element) async {
    //   await FirebaseFirestore.instance.collection(Const.globalCollection).doc(globalModel.bondId).collection(Const.bondRecordCollection).doc(element.bondRecId).set(element.toJson());
    // });

    ///this for add to firebase
    await FirebaseFirestore.instance.collection(AppStrings.globalCollection).doc(globalModel.bondId).set(globalModel.toFullJson());
    await Future.delayed(const Duration(milliseconds: 100));

    ///?? globalModel.entryBondId
    await HiveDataBase.globalModelBox.put(globalModel.bondId, globalModel);

    Get.find<ImportViewModel>().addedBond++;
    print("end ${globalModel.bondId}");
    print("end ${globalModel.entryBondRecord!.map(
      (e) => e.toJson(),
    )}");
    print("----------------------------------------");
  }

  void addChequeToFirebase(GlobalModel globalModel) async {
    await FirebaseFirestore.instance.collection(AppStrings.globalCollection).doc(globalModel.entryBondId).collection(AppStrings.chequeRecordCollection).get().then((value) async {
      for (var element in value.docs) {
        await element.reference.delete();
      }
    });
    globalModel.cheqRecords?.forEach((element) async {
      await FirebaseFirestore.instance.collection(AppStrings.globalCollection).doc(globalModel.entryBondId).collection(AppStrings.chequeRecordCollection).doc(element.cheqRecEntryBondId).set(element.toJson());
    });
    await FirebaseFirestore.instance.collection(AppStrings.globalCollection).doc(globalModel.entryBondId).set(globalModel.toJson());
  }

  initGlobalInvoiceBond(GlobalModel globalModel) async {
    globalModel.entryBondRecord = [];
    globalModel.bondDescription = "${getGlobalTypeFromEnum(globalModel.patternId!)} تم التوليد بشكل تلقائي";
    int bondRecId = 0;
    for (var element in globalModel.invRecords!) {
      String dse = "${getInvTypeFromEnum(globalModel.invType!)} عدد ${element.invRecQuantity} من ${getProductNameFromId(element.invRecProduct)}";
      List<InvoiceDiscountRecordModel> discountList = (globalModel.invDiscountRecord!).isEmpty ? [] : (globalModel.invDiscountRecord!).where((e) => e.discountId != null && (e.discountTotal ?? 0) > 0).toList();
      List<InvoiceDiscountRecordModel> addedList = (globalModel.invDiscountRecord!).isEmpty ? [] : (globalModel.invDiscountRecord!).where((e) => e.discountId != null && (e.addedTotal ?? 0) > 0).toList();
      double totalDiscount = discountList
          .map(
            (e) => e.isChooseDiscountTotal! ? e.discountTotal! : e.discountPercentage!,
          )
          .fold(
            0,
            (value, element) => value + element,
          );
      double totalAdded = addedList
          .map(
            (e) => e.isChooseAddedTotal! ? e.addedTotal! : e.addedPercentage!,
          )
          .fold(
            0,
            (value, element) => value + element,
          );

      ///مبيعات
      if (globalModel.invType == AppStrings.invoiceTypeSalesWithPartner || globalModel.invType == AppStrings.invoiceTypeSales) {
        if ((element.invRecQuantity ?? 0) > 0) {
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), ((element.invRecSubTotal ?? 0) * (element.invRecQuantity ?? 0)).abs(), 0, globalModel.invPrimaryAccount, dse));
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), 0, element.invRecSubTotal! * element.invRecQuantity!, globalModel.invSecondaryAccount, dse));
        }
      } else {
        /// فاتورة مشتريات
        globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), 0, element.invRecSubTotal! * element.invRecQuantity!, globalModel.invSecondaryAccount, dse));
        globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), element.invRecSubTotal! * element.invRecQuantity!, 0, globalModel.invPrimaryAccount, dse));
      }

      if (globalModel.invType == AppStrings.invoiceTypeSalesWithPartner || globalModel.invType == AppStrings.invoiceTypeSales) {
        /// gifts
        if ((element.invRecGift ?? 0) > 0) {
          String giftDse = "هدية عدد ${element.invRecGift} من ${getProductNameFromId(element.invRecProduct)}";
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), 0, element.invRecGiftTotal ?? 0, globalModel.invGiftAccount, giftDse));
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), element.invRecGiftTotal!, 0, globalModel.invSecGiftAccount, giftDse));
        }
        if (totalDiscount > 0 || totalAdded > 0) {
          for (var model in globalModel.invDiscountRecord!) {
            if (model.discountTotal != 0) {
              var discountDes = "الخصم المعطى ${model.isChooseDiscountTotal! ? "بقيمة ${model.discountTotal}" : "بنسبة ${model.isChooseDiscountTotal! ? model.discountTotal! : model.discountPercentage!}%"}";
              globalModel.entryBondRecord
                  ?.add(EntryBondRecordModel((bondRecId++).toString(), 0, model.isChooseDiscountTotal! ? model.discountTotal : (element.invRecSubTotal! * element.invRecQuantity!) * (model.discountPercentage == 0 ? 1 : (model.discountPercentage! / 100)), model.accountId, discountDes));
              globalModel.entryBondRecord?.add(
                  EntryBondRecordModel((bondRecId++).toString(), model.isChooseDiscountTotal! ? model.discountTotal : (element.invRecSubTotal! * element.invRecQuantity!) * (model.discountPercentage == 0 ? 1 : (model.discountPercentage! / 100)), 0, globalModel.invSecondaryAccount, discountDes));
            } else {
              var discountDes = "الإضافة المعطى ${model.isChooseAddedTotal! ? "بقيمة ${model.addedTotal}" : "بنسبة ${model.isChooseAddedTotal! ? model.addedTotal! : model.addedPercentage!}%"}";
              globalModel.entryBondRecord?.add(EntryBondRecordModel((bondRecId++).toString(), model.isChooseAddedTotal! ? model.addedTotal : (element.invRecSubTotal! * element.invRecQuantity!) * (model.addedPercentage == 0 ? 1 : (model.addedPercentage! / 100)), 0, model.accountId, discountDes));
              globalModel.entryBondRecord
                  ?.add(EntryBondRecordModel((bondRecId++).toString(), 0, model.isChooseAddedTotal! ? model.addedTotal : (element.invRecSubTotal! * element.invRecQuantity!) * (model.addedPercentage == 0 ? 1 : (model.addedPercentage! / 100)), globalModel.invSecondaryAccount, discountDes));
            }
          }
        }
      }

      /// الضريبة
      if (element.invRecVat != 0 && element.invRecQuantity != 0 /*&&getProductModelFromId(element.invRecProduct)?.prodIsLocal==true*/) {
        if (globalModel.invType == AppStrings.invoiceTypeSales) {
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), (element.invRecVat!) * (element.invRecQuantity ?? 1), 0, globalModel.invVatAccount, "ضريبة $dse"));
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), 0, (element.invRecVat!) * (element.invRecQuantity ?? 1), globalModel.invSecondaryAccount, "ضريبة $dse"));
        } else {
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), element.invRecVat! * (element.invRecQuantity ?? 1), 0, globalModel.invPrimaryAccount, "ضريبة $dse"));
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), 0, element.invRecVat! * (element.invRecQuantity ?? 1), globalModel.invVatAccount, "ضريبة $dse"));
        }
      }
    }

    /// الدفعة الاولى
    if (globalModel.firstPay != null && globalModel.firstPay! > 0) {
      if (globalModel.invPayType == AppStrings.invPayTypeDue) {
        if (globalModel.invCode!.contains("F")) {
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), globalModel.firstPay, 0, getAccountIdFromText("F-حساب التسديد"), "الدفعة الاولى مبيعات ${globalModel.invCode}"));
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), 0, globalModel.firstPay, getAccountIdFromText("F-الصندوق"), "الدفعة الاولى مبيعات ${globalModel.invCode}"));
        } else {
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), globalModel.firstPay, 0, getAccountIdFromText("حساب التسديد"), "الدفعة الاولى مبيعات ${globalModel.invCode}"));
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), 0, globalModel.firstPay, getAccountIdFromText("الصندوق"), "الدفعة الاولى مبيعات ${globalModel.invCode}"));
        }
      }
    }
    Get.find<EntryBondViewModel>().allEntryBonds[globalModel.entryBondId!] = globalModel;
  }

  updateDataInAll(GlobalModel globalModel) async {
    if (globalModel.globalType == AppStrings.globalTypeInvoice) {
      if (!globalModel.invIsPending!) {
        if (globalModel.invType != AppStrings.invoiceTypeAdd && globalModel.invType != AppStrings.invoiceTypeChange) {
          // initGlobalInvoiceBond(globalModel);
          if (getPatModelFromPatternId(globalModel.patternId).patType == AppStrings.invoiceTypeSales || getPatModelFromPatternId(globalModel.patternId).patType == AppStrings.invoiceTypeSalesWithPartner) {
            sellerViewModel.postRecord(userId: globalModel.invSeller!, invId: globalModel.invId, amount: globalModel.invTotal!, date: globalModel.invDate);
          }
        }
        if (globalModel.invType != AppStrings.invoiceTypeChange) {
          accountViewModel.initGlobalAccount(globalModel);
          productController.initGlobalProduct(globalModel);
        }
        storeController.initGlobalStore(globalModel);
      }
      invoiceViewModel.initGlobalInvoice(globalModel);
    } else if (globalModel.globalType == AppStrings.globalTypeCheque) {
      entryBondViewModel.initGlobalChequeBond(globalModel);
      chequeViewModel.initGlobalCheque(globalModel);
    }
    if (globalModel.globalType == AppStrings.globalTypeBond) {
      bondViewModel.initGlobalBond(globalModel);
      entryBondViewModel.initGlobalBond(globalModel);
      accountViewModel.initGlobalAccount(globalModel);
    }
  }

  initUpdateDataInAll(GlobalModel globalModel) async {
    if (globalModel.globalType == AppStrings.globalTypeInvoice) {
      if (!globalModel.invIsPending!) {
        if (globalModel.invType != AppStrings.invoiceTypeAdd && globalModel.invType != AppStrings.invoiceTypeChange) {
          // initGlobalInvoiceBond(globalModel);
          if (getPatModelFromPatternId(globalModel.patternId).patName == "مبيع" || getPatModelFromPatternId(globalModel.patternId).patType == AppStrings.invoiceTypeSalesWithPartner) {
            sellerViewModel.postRecord(userId: globalModel.invSeller!, invId: globalModel.invId, amount: globalModel.invTotal!, date: globalModel.invDate);
          }
        }
      }
      invoiceViewModel.initGlobalInvoice(globalModel);
    }
    if (globalModel.invType != AppStrings.invoiceTypeChange) {
      // accountViewModel.initGlobalAccount(globalModel);
      productController.initGlobalProduct(globalModel);
    }
    if (globalModel.globalType == AppStrings.globalTypeBond) {
      bondViewModel.initGlobalBond(globalModel);
      entryBondViewModel.initGlobalBond(globalModel);
    } else if (globalModel.globalType == AppStrings.globalTypeCheque) {
      entryBondViewModel.initGlobalChequeBond(globalModel);
      chequeViewModel.initGlobalCheque(globalModel);
    }
  }

  deleteDataInAll(GlobalModel globalModel) {
    if (globalModel.globalType == AppStrings.globalTypeInvoice) {
      invoiceViewModel.deleteGlobalInvoice(globalModel);
      bondViewModel.deleteGlobalBond(globalModel);
      accountViewModel.deleteGlobalAccount(globalModel);
      productController.deleteGlobalProduct(globalModel);
      storeController.deleteGlobalStore(globalModel);
      sellerViewModel.deleteGlobalSeller(globalModel);
    } else if (globalModel.globalType == AppStrings.globalTypeCheque) {
      chequeViewModel.deleteGlobalCheque(globalModel);
    } else if (globalModel.globalType == AppStrings.globalTypeBond) {
      bondViewModel.deleteGlobalBond(globalModel);
      accountViewModel.deleteGlobalAccount(globalModel);
    }
  }

  GlobalModel? checkFreeZoneProduct(GlobalModel filteredGlobalModel) {
    if (HiveDataBase.isFree.get("isFree")!) {
      if (filteredGlobalModel.invCode!.startsWith("F-")) {
        return null;
      }
      GlobalModel _ = GlobalModel.fromJson(filteredGlobalModel.toFullJson());
      for (var i = 0; i < _.invRecords!.length; i++) {
        if (_.invRecords![i].invRecIsLocal ?? true) {
        } else {
          _.invTotal = _.invTotal! - _.invRecords![i].invRecTotal!;
          _.invRecords!.removeAt(i);
        }
      }
      if (_.invRecords!.isEmpty) {
        return null;
      } else {
        return _;
      }
    } else {
      return filteredGlobalModel;
    }
  }
}
