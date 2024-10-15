import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:ba3_business_solutions/controller/bond/bond_controller.dart';
import 'package:ba3_business_solutions/controller/bond/entry_bond_controller.dart';
import 'package:ba3_business_solutions/controller/cheque/cheque_controller.dart';
import 'package:ba3_business_solutions/controller/global/changes_controller.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_controller.dart';
import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_controller.dart';
import 'package:ba3_business_solutions/controller/store/store_controller.dart';
import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:ba3_business_solutions/core/utils/generate_id.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../core/constants/app_constants.dart';
import '../../core/helper/functions/functions.dart';
import '../../model/bond/bond_record_model.dart';
import '../../model/bond/entry_bond_record_model.dart';
import '../../model/invoice/invoice_discount_record_model.dart';
import '../../view/main/main_screen.dart';
import '../databsae/import_controller.dart';
import '../invoice/invoice_controller.dart';

class GlobalController extends GetxController {
  // Map<String, GlobalModel> allGlobalModel = {};
  bool isDrawerOpen = true;
  ProductController productController = Get.find<ProductController>();
  StoreController storeController = Get.find<StoreController>();
  BondController bondViewModel = Get.find<BondController>();
  InvoiceController invoiceViewModel = Get.find<InvoiceController>();
  AccountController accountViewModel = Get.find<AccountController>();
  EntryBondController entryBondViewModel = Get.find<EntryBondController>();
  SellersController sellerViewModel = Get.find<SellersController>();
  ChequeController chequeViewModel = Get.find<ChequeController>();
  bool isEdit = false;

  GlobalController() {
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
    globalModel.globalType = AppConstants.globalTypeBond;
    globalModel.bondId = generateId(RecordType.bond);
    globalModel.entryBondId = generateId(RecordType.entryBond);
    globalModel.entryBondCode = getNextEntryBondCode().toString();

    // addGlobalToLocal(globalModel);
    updateDataInAll(globalModel);

    bondViewModel.tempBondModel = globalModel;
    bondViewModel.update();
    ChangesController changesViewModel = Get.find<ChangesController>();
    addBondToFirebase(globalModel);
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppConstants.bondsCollection);
    update();
  }

  addGlobalBondToMemory(GlobalModel globalModel) async {
    // addGlobalToLocal(globalModel);
    // updateDataInAll(globalModel);
    await HiveDataBase.globalModelBox.put(globalModel.bondId!, globalModel);
    bondViewModel.allBondsItem[globalModel.bondId!] = globalModel;
    globalModel.entryBondId ??= generateId(RecordType.entryBond);
    entryBondViewModel.allEntryBonds[globalModel.entryBondId!] = globalModel;
    bondViewModel.update();
    update();
  }

  void addGlobalCheque(GlobalModel globalModel) {
    // globalModel.globalType = Const.globalTypeCheque;
    // globalModel.bondId = generateId(RecordType.bond);
    // globalModel.entryBondId = generateId(RecordType.entryBond);

    updateDataInAll(globalModel);
    chequeViewModel.update();
    ChangesController changesViewModel = Get.find<ChangesController>();
    addChequeToFirebase(globalModel);
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppConstants.chequesCollection);
    update();
  }

  void addGlobalInvoice(GlobalModel globalModel) {
    // GlobalModel correctedModel = correctInvRecord(globalModel);

    UserManagementController myUser = Get.find<UserManagementController>();
    if ((myUser.allRole[getMyUserRole()]?.roles[AppConstants.roleViewInvoice]?.contains(AppConstants.roleUserAdmin)) ?? false) {
      globalModel.invIsPending = false;
    } else {
      globalModel.invIsPending = true;
    }

    initGlobalInvoiceBond(globalModel);
    updateDataInAll(globalModel);
    ChangesController changesViewModel = Get.find<ChangesController>();
    addInvoiceToFirebase(globalModel);
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppConstants.invoicesCollection);
    // invoiceViewModel.updateCodeList();
    invoiceViewModel.initModel = globalModel;
    invoiceViewModel.invoiceModel[globalModel.invId!] = globalModel;

    invoiceViewModel.update();
    // sendEmailWithPdfAttachment(globalModel);
  }

  addGlobalInvoiceToMemory(GlobalModel globalModel) async {
    // addGlobalToLocal(globalModel);
    // updateDataInAll(globalModel);

    await HiveDataBase.globalModelBox.put(globalModel.invId!, globalModel);
    invoiceViewModel.invoiceModel[globalModel.invId!] = globalModel;
    globalModel.entryBondId ??= generateId(RecordType.entryBond);
    entryBondViewModel.allEntryBonds[globalModel.entryBondId!] = globalModel;
    invoiceViewModel.update();

    update();
  }

  addGlobalChequeToMemory(GlobalModel globalModel) async {
    // addGlobalToLocal(globalModel);
    // updateDataInAll(globalModel);
    await HiveDataBase.globalModelBox.put(globalModel.cheqId!, globalModel);
    chequeViewModel.allCheques[globalModel.cheqId!] = globalModel;
    globalModel.entryBondId ??= generateId(RecordType.entryBond);
    entryBondViewModel.allEntryBonds[globalModel.entryBondId!] = globalModel;
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
    ChangesController changesViewModel = Get.find<ChangesController>();
    addInvoiceToFirebase(globalModel);
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppConstants.invoicesCollection);

    update();

  }

  Future<void> updateGlobalBond(GlobalModel globalModel) async {
    globalModel.entryBondId ??= generateId(RecordType.entryBond);
    bondViewModel.initGlobalBond(globalModel);

    updateDataInAll(globalModel);
    ChangesController changesViewModel = Get.find<ChangesController>();
    await addBondToFirebase(globalModel);
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppConstants.bondsCollection);
    update();
  }

  void updateGlobalCheque(GlobalModel globalModel) {
    updateDataInAll(globalModel);
    addChequeToFirebase(globalModel);
    chequeViewModel.update();
    ChangesController changesViewModel = Get.find<ChangesController>();
    changesViewModel.addChangeToChanges(globalModel.toFullJson(), AppConstants.chequesCollection);
    update();
  }

  ////--Delete
  void deleteGlobal(GlobalModel globalModel) {
    entryBondViewModel.deleteBondById(globalModel.entryBondId);
    if (globalModel.invId != null) {
      FirebaseFirestore.instance.collection(AppConstants.globalCollection).doc(globalModel.invId).set({"isDeleted": true}, SetOptions(merge: true));
    }
    if (globalModel.bondId != null) {
      FirebaseFirestore.instance.collection(AppConstants.globalCollection).doc(globalModel.bondId).set({"isDeleted": true}, SetOptions(merge: true));
    }
    deleteGlobalFromLocal(globalModel);
    // deleteDataInAll(globalModel);
    ChangesController changesViewModel = Get.find<ChangesController>();
    changesViewModel.addRemoveChangeToChanges(globalModel.toFullJson(), AppConstants.globalCollection);
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
        globalModel.invRecords?[globalModel.invRecords!.indexOf(element)].invRecProduct =
            productController.searchProductIdByName(element.invRecProduct);
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
    initGlobalInvoiceBond(globalModel);
    await Future.delayed(const Duration(milliseconds: 100));
    await HiveDataBase.globalModelBox.put(globalModel.invId, globalModel);
    print("end ${globalModel.entryBondId}  ${globalModel.invId}");
  }

  ///ALI5656
  ///HUAWEI WATCH 4 PRO مستعمل
  ///SKINARMA CASE FOR IP 16 PRO SAIDO MAG-CHARGE
  ///SKINARMA CASE FOR IP 16 PRO MAX HELDRO MAX MAGCLICK WITH CAMERA STAND - TAUPE GOLD
  ///SKINARMA CASE FOR IP 16 PRO MAX HELDRO MAX MAGCLICK WITH CAMERA STAND - LUCENT CLEAR
  ///SKINARMA CASE FOR IP 16 PRO HELDRO MAX MAGCLICK WITH CAMERA STAND - TAUPE GOLD
  ///SKINARMA CASE FOR IP 16 PRO HELDRO MAX MAGCLICK WITH CAMERA STAND - LUCENT CLEAR
  /// UNIQ OPTIX CLEAR FOR IP 16 PRO
  ///UNIQ OPTIX XENON NANO CERAM FOR IP 16 PRO MAX
  ///UNIQ OPTIX CLEAR FOR IP 16 PRO MAX
  ///كشاف امامي كبير جيتور
  ///PORODO LIFESTYLE PORTABLE GARMENT STEAMER 1700W - BLACK
  ///PORODO LIFESTYLE PORTABLE HANDLE MULTIFUNCTIONAL GARMENT STEAMER 2500W 1200ML - BLACK
  ///GREEN LION SMART SCENT DIFFUSER 150ML
  ///POWEROLOGY MAGSFE DUAL PD CHARGER 65W
  ///LEVELO OTTO TYPE-C APPLE WATCH WIRELESS CHARGER
  ///WIWU PANDORA WIRELESS STEREO BLACK
  ///WIWU PANDORA WIRELESS STEREO WHITE
  ///CAVO X TYPE-C TO TYPE-C CABLE MX-NC040
  ///CAVO X TYPE-C TO LIGHTNING CABLE 1.2M MX-NC041
  ///MOXEDO ULTRA SHIELD TEMPERED GLASS SCREEN PROTECTOR FOR IP 16 CLEAR
  ///MOXEDO ULTRA SHIELD TEMPERED GLASS SCREEN PROTECTOR FOR IP 16 PRO CLEAR
  /// MOXEDO ULTRA SHIELD TEMPERED GLASS SCREEN PROTECTOR FOR IP 16 PLUS CLEAR
  /// MOXEDO ULTRA SHIELD TEMPERED GLASS SCREEN PROTECTOR FOR IP 16 PRO MAX CLEAR
  /// MOXEDO ULTRA SHIELD TEMPERED GLASS SCREEN PROTECTOR FOR IP 16 PRIVACY
  /// MOXEDO ULTRA SHIELD TEMPERED GLASS SCREEN PROTECTOR FOR IP 16 PRO PRIVACY
  /// MOXEDO ULTRA SHIELD TEMPERED GLASS SCREEN PROTECTOR FOR IP 16 PLUS PRIVACY
  /// MOXEDO ULTRA SHIELD TEMPERED GLASS SCREEN PROTECTOR FOR IP 16 PRO MAX PRIVACY
  /// MOXEDO CAMERA LENS PROTECTOR FOR IP 16 & IP 16 PLUS PURPLE
  /// MOXEDO CAMERA LENS PROTECTOR FOR IP 16 & IP 16 PLUS BLUE
  /// MOXEDO CAMERA LENS PROTECTOR FOR IP 16 & IP 16 PLUS GREEN
  /// MOXEDO CAMERA LENS PROTECTOR FOR IP 16 & IP 16 PLUS SILVER
  /// MOXEDO CAMERA LENS PROTECTOR FOR IP 16 & IP 16 PLUS BLACK
  /// MOXEDO CAMERA LENS PROTECTOR FOR IP 16 & IP 16 PRO & PRO MAX SILVER
  /// MOXEDO CAMERA LENS PROTECTOR FOR IP 16 & IP 16 PRO & PRO MAX GOLD
  /// MOXEDO CAMERA LENS PROTECTOR FOR IP 16 & IP 16 PRO & PRO MAX TIT
  /// MOXEDO CAMERA LENS PROTECTOR FOR IP 16 & IP 16 PRO & PRO MAX BLACK
  /// MOXEDO WALL MOUNT OSCILLATING FAN
  /// MOXEDO 2IN1 PORTABLE MAKEUP BAG PINK
  /// MOXEDO 2IN1 PORTABLE MAKEUP BAG MAROON
  /// MOXEDO 2IN1 PORTABLE MAKEUP BAG BLACK
  /// REMSON ELITE GUARD PRO IP 16 CLEAR
  /// REMSON ELITE GUARD PRO IP 16 PLUS CLEAR
  /// REMSON ELITE GUARD PRO IP 16 PRO CLEAR
  /// REMSON ELITE GUARD PRO IP 16 PRO MAX CLEAR
  /// REMSON ELITE GUARD PRO IP 16 PRIVACY
  /// REMSON ELITE GUARD PRO IP 16 PLUS PRIVACY
  /// REMSON ELITE GUARD PRO IP 16 PRO PRIVACY
  /// REMSON ELITE GUARD PRO IP 16 PRO MAX PRIVACY
  /// SKINARMA CASE FOR IP 16 PRO MAX HELIO BLACK
  /// SKINARMA CASE FOR IP 16 PRO HELIO BLACK
  /// SKINARMA CASE FOR IP 16 PRO MAX SAIDO MAG CHARGE + KADO MAGNETIC CARD HOLDER TITANIUM
  /// SKINARMA CASE FOR IP 16 PRO SAIDO MAG CHARGE + KADO MAGNETIC CARD HOLDER TITANIUM
  /// SKINARMA CASE FOR IP 16 PRO MAX HELIO TITANIUM
  /// SKINARMA CASE FOR IP 16 PRO MAX SAIDO MAG CHARGE + KADO MAGNETIC CARD HOLDER GLOD
  /// SKINARMA CASE FOR IP 16 PRO SAIDO MAG CHARGE + KADO MAGNETIC CARD HOLDER GLOD
  /// غطاء مفصلات جيتور باب خلفي
  /// كليبرات جيتور ازرق
  /// كليبرات جيتور برتقالي
  /// اضاءة خلفية جيتور
  /// SKINARMA CASE FOR IP 16 PRO SAIDO MAG-CHARGE
  /// SKINARMA CASE FOR IP 16 PRO HELDRO MAX MAGCLICK WITH CAMERA STAND - LUCENT CLEAR
  /// SKINARMA CASE FOR IP 16 PRO MAX HELDRO MAX MAGCLICK WITH CAMERA STAND - TAUPE GOLD
  /// WIWU STARLINK USB-C TO USB-C CABLE 60W WI-C043E
  /// WIWU GEEK CAR CHARGER 90W WI-QC013
  /// WIWU MAGIC KEYBOARD FOR IPAD PRO 11 2024
  /// SKINARMA CASE FOR IP 16 PRO MAX HELDRO MAX MAGCLICK WITH CAMERA STAND - TAUPE GOLD
  /// GREEN LION MAGSAFE LEATHER GRIP FOR IP 16 PRO MAX
  /// GREEN LION MAGSAFE LEATHER GRIP FOR IP 16 PRO MAX BLACK
  ///  GREEN LION MAGSAFE LEATHER GRIP FOR IP 16 PRO GOLD
  ///  GREEN LION MAGSAFE LEATHER GRIP FOR IP 16 PRO MAX GOLD
  ///  GREEN LION MAGSAFE LEATHER GRIP FOR IP 16 PRO GREY
  ///  GREEN LION GRIP-X FOR IP 16 PRO MAX GREY
  ///  GREEN LION GRIP-X FOR IP 16 PRO MAX GOLD
  ///  GREEN LION GRIP-X FOR IP 16 PRO MAX BLACK
  ///  GREEN LION GRIP-X FOR IP 16 PRO GREY
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
    await FirebaseFirestore.instance.collection(AppConstants.globalCollection).doc(globalModel.bondId).set(globalModel.toFullJson());
    await Future.delayed(const Duration(milliseconds: 100));

    ///?? globalModel.entryBondId
    await HiveDataBase.globalModelBox.put(globalModel.bondId, globalModel);

    Get.find<ImportController>().addedBond++;
    print("end ${globalModel.bondId}");
    print("end ${globalModel.entryBondRecord!.map(
      (e) => e.toJson(),
    )}");
    print("----------------------------------------");
  }

  void addChequeToFirebase(GlobalModel globalModel) async {
    await FirebaseFirestore.instance
        .collection(AppConstants.globalCollection)
        .doc(globalModel.entryBondId)
        .collection(AppConstants.chequeRecordCollection)
        .get()
        .then((value) async {
      for (var element in value.docs) {
        await element.reference.delete();
      }
    });
    globalModel.cheqRecords?.forEach((element) async {
      await FirebaseFirestore.instance
          .collection(AppConstants.globalCollection)
          .doc(globalModel.entryBondId)
          .collection(AppConstants.chequeRecordCollection)
          .doc(element.cheqRecEntryBondId)
          .set(element.toJson());
    });
    await FirebaseFirestore.instance.collection(AppConstants.globalCollection).doc(globalModel.entryBondId).set(globalModel.toJson());
  }

  initGlobalInvoiceBond(GlobalModel globalModel) async {
    globalModel.entryBondRecord = [];
    globalModel.bondDescription = "${getGlobalTypeFromEnum(globalModel.patternId!)} تم التوليد بشكل تلقائي";
    int bondRecId = 0;
    for (var element in globalModel.invRecords!) {
      String dse = "${getInvTypeFromEnum(globalModel.invType!)} عدد ${element.invRecQuantity} من ${getProductNameFromId(element.invRecProduct)}";
      List<InvoiceDiscountRecordModel> discountList = (globalModel.invDiscountRecord!).isEmpty
          ? []
          : (globalModel.invDiscountRecord!).where((e) => e.discountId != null && (e.discountTotal ?? 0) > 0).toList();
      List<InvoiceDiscountRecordModel> addedList = (globalModel.invDiscountRecord!).isEmpty
          ? []
          : (globalModel.invDiscountRecord!).where((e) => e.discountId != null && (e.addedTotal ?? 0) > 0).toList();
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
      if (globalModel.invType == AppConstants.invoiceTypeSalesWithPartner || globalModel.invType == AppConstants.invoiceTypeSales) {
        if ((element.invRecQuantity ?? 0) > 0) {
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(),
              ((element.invRecSubTotal ?? 0) * (element.invRecQuantity ?? 0)).abs(), 0, globalModel.invPrimaryAccount, dse));
          globalModel.entryBondRecord!.add(EntryBondRecordModel(
              (bondRecId++).toString(), 0, element.invRecSubTotal! * element.invRecQuantity!, globalModel.invSecondaryAccount, dse));
        }
      } else {
        /// فاتورة مشتريات
        globalModel.entryBondRecord!.add(EntryBondRecordModel(
            (bondRecId++).toString(), 0, element.invRecSubTotal! * element.invRecQuantity!, globalModel.invSecondaryAccount, dse));
        globalModel.entryBondRecord!.add(
            EntryBondRecordModel((bondRecId++).toString(), element.invRecSubTotal! * element.invRecQuantity!, 0, globalModel.invPrimaryAccount, dse));
      }

      if (globalModel.invType == AppConstants.invoiceTypeSalesWithPartner || globalModel.invType == AppConstants.invoiceTypeSales) {
        /// gifts
        if ((element.invRecGift ?? 0) > 0) {
          String giftDse = "هدية عدد ${element.invRecGift} من ${getProductNameFromId(element.invRecProduct)}";
          globalModel.entryBondRecord!
              .add(EntryBondRecordModel((bondRecId++).toString(), 0, element.invRecGiftTotal ?? 0, globalModel.invGiftAccount, giftDse));
          globalModel.entryBondRecord!
              .add(EntryBondRecordModel((bondRecId++).toString(), element.invRecGiftTotal!, 0, globalModel.invSecGiftAccount, giftDse));
        }
        if (totalDiscount > 0 || totalAdded > 0) {
          for (var model in globalModel.invDiscountRecord!) {
            if (model.discountTotal != 0) {
              var discountDes =
                  "الخصم المعطى ${model.isChooseDiscountTotal! ? "بقيمة ${model.discountTotal}" : "بنسبة ${model.isChooseDiscountTotal! ? model.discountTotal! : model.discountPercentage!}%"}";
              globalModel.entryBondRecord?.add(EntryBondRecordModel(
                  (bondRecId++).toString(),
                  0,
                  model.isChooseDiscountTotal!
                      ? model.discountTotal
                      : (element.invRecSubTotal! * element.invRecQuantity!) * (model.discountPercentage == 0 ? 1 : (model.discountPercentage! / 100)),
                  model.accountId,
                  discountDes));
              globalModel.entryBondRecord?.add(EntryBondRecordModel(
                  (bondRecId++).toString(),
                  model.isChooseDiscountTotal!
                      ? model.discountTotal
                      : (element.invRecSubTotal! * element.invRecQuantity!) * (model.discountPercentage == 0 ? 1 : (model.discountPercentage! / 100)),
                  0,
                  globalModel.invSecondaryAccount,
                  discountDes));
            } else {
              var discountDes =
                  "الإضافة المعطى ${model.isChooseAddedTotal! ? "بقيمة ${model.addedTotal}" : "بنسبة ${model.isChooseAddedTotal! ? model.addedTotal! : model.addedPercentage!}%"}";
              globalModel.entryBondRecord?.add(EntryBondRecordModel(
                  (bondRecId++).toString(),
                  model.isChooseAddedTotal!
                      ? model.addedTotal
                      : (element.invRecSubTotal! * element.invRecQuantity!) * (model.addedPercentage == 0 ? 1 : (model.addedPercentage! / 100)),
                  0,
                  model.accountId,
                  discountDes));
              globalModel.entryBondRecord?.add(EntryBondRecordModel(
                  (bondRecId++).toString(),
                  0,
                  model.isChooseAddedTotal!
                      ? model.addedTotal
                      : (element.invRecSubTotal! * element.invRecQuantity!) * (model.addedPercentage == 0 ? 1 : (model.addedPercentage! / 100)),
                  globalModel.invSecondaryAccount,
                  discountDes));
            }
          }
        }
      }

      /// الضريبة
      if (element.invRecVat != 0 && element.invRecQuantity != 0 /*&&getProductModelFromId(element.invRecProduct)?.prodIsLocal==true*/) {
        if (globalModel.invType == AppConstants.invoiceTypeSales) {
          globalModel.entryBondRecord!.add(EntryBondRecordModel(
              (bondRecId++).toString(), (element.invRecVat!) * (element.invRecQuantity ?? 1), 0, globalModel.invVatAccount, "ضريبة $dse"));
          globalModel.entryBondRecord!.add(EntryBondRecordModel(
              (bondRecId++).toString(), 0, (element.invRecVat!) * (element.invRecQuantity ?? 1), globalModel.invSecondaryAccount, "ضريبة $dse"));
        } else {
          globalModel.entryBondRecord!.add(EntryBondRecordModel(
              (bondRecId++).toString(), element.invRecVat! * (element.invRecQuantity ?? 1), 0, globalModel.invPrimaryAccount, "ضريبة $dse"));
          globalModel.entryBondRecord!.add(EntryBondRecordModel(
              (bondRecId++).toString(), 0, element.invRecVat! * (element.invRecQuantity ?? 1), globalModel.invVatAccount, "ضريبة $dse"));
        }
      }
    }

    /// الدفعة الاولى
    if (globalModel.firstPay != null && globalModel.firstPay! > 0) {
      if (globalModel.invPayType == AppConstants.invPayTypeDue) {
        if (globalModel.invCode!.contains("F")) {
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), globalModel.firstPay, 0,
              getAccountIdFromText("F-حساب التسديد"), "الدفعة الاولى مبيعات ${globalModel.invCode}"));
          globalModel.entryBondRecord!.add(EntryBondRecordModel(
              (bondRecId++).toString(), 0, globalModel.firstPay, getAccountIdFromText("F-الصندوق"), "الدفعة الاولى مبيعات ${globalModel.invCode}"));
        } else {
          globalModel.entryBondRecord!.add(EntryBondRecordModel((bondRecId++).toString(), globalModel.firstPay, 0,
              getAccountIdFromText("حساب التسديد"), "الدفعة الاولى مبيعات ${globalModel.invCode}"));
          globalModel.entryBondRecord!.add(EntryBondRecordModel(
              (bondRecId++).toString(), 0, globalModel.firstPay, getAccountIdFromText("الصندوق"), "الدفعة الاولى مبيعات ${globalModel.invCode}"));
        }
      }
    }
    Get.find<EntryBondController>().allEntryBonds[globalModel.entryBondId!] = globalModel;
  }

  updateDataInAll(GlobalModel globalModel) async {
    if (globalModel.globalType == AppConstants.globalTypeInvoice) {
      if (!globalModel.invIsPending!) {
        if (globalModel.invType != AppConstants.invoiceTypeAdd && globalModel.invType != AppConstants.invoiceTypeChange) {
          // initGlobalInvoiceBond(globalModel);
          if (getPatModelFromPatternId(globalModel.patternId).patType == AppConstants.invoiceTypeSales ||
              getPatModelFromPatternId(globalModel.patternId).patType == AppConstants.invoiceTypeSalesWithPartner) {
            sellerViewModel.postRecord(
                userId: globalModel.invSeller!, invId: globalModel.invId, amount: globalModel.invTotal!, date: globalModel.invDate);
          }
        }
        if (globalModel.invType != AppConstants.invoiceTypeChange) {
          accountViewModel.initGlobalAccount(globalModel);
          productController.initGlobalProduct(globalModel);
        }
        storeController.initGlobalStore(globalModel);
      }
      invoiceViewModel.initGlobalInvoice(globalModel);
    } else if (globalModel.globalType == AppConstants.globalTypeCheque) {
      entryBondViewModel.initGlobalChequeBond(globalModel);
      chequeViewModel.initGlobalCheque(globalModel);
    }
    if (globalModel.globalType == AppConstants.globalTypeBond) {
      bondViewModel.initGlobalBond(globalModel);
      entryBondViewModel.initGlobalBond(globalModel);
      accountViewModel.initGlobalAccount(globalModel);
    }
  }

  initUpdateDataInAll(GlobalModel globalModel) async {
    if (globalModel.globalType == AppConstants.globalTypeInvoice) {
      if (!globalModel.invIsPending!) {
        if (globalModel.invType != AppConstants.invoiceTypeAdd && globalModel.invType != AppConstants.invoiceTypeChange) {
          // initGlobalInvoiceBond(globalModel);
          if (getPatModelFromPatternId(globalModel.patternId).patName == "مبيع" ||
              getPatModelFromPatternId(globalModel.patternId).patType == AppConstants.invoiceTypeSalesWithPartner) {
            sellerViewModel.postRecord(
                userId: globalModel.invSeller!, invId: globalModel.invId, amount: globalModel.invTotal!, date: globalModel.invDate);
          }
        }
      }
      invoiceViewModel.initGlobalInvoice(globalModel);
    }
    if (globalModel.invType != AppConstants.invoiceTypeChange) {
      // accountViewModel.initGlobalAccount(globalModel);
      productController.initGlobalProduct(globalModel);
    }
    if (globalModel.globalType == AppConstants.globalTypeBond) {
      bondViewModel.initGlobalBond(globalModel);
      entryBondViewModel.initGlobalBond(globalModel);
    } else if (globalModel.globalType == AppConstants.globalTypeCheque) {
      entryBondViewModel.initGlobalChequeBond(globalModel);
      chequeViewModel.initGlobalCheque(globalModel);
    }
  }

  deleteDataInAll(GlobalModel globalModel) {
    if (globalModel.globalType == AppConstants.globalTypeInvoice) {
      invoiceViewModel.deleteGlobalInvoice(globalModel);
      bondViewModel.deleteGlobalBond(globalModel);
      accountViewModel.deleteGlobalAccount(globalModel);
      productController.deleteGlobalProduct(globalModel);
      storeController.deleteGlobalStore(globalModel);
      sellerViewModel.deleteGlobalSeller(globalModel);
    } else if (globalModel.globalType == AppConstants.globalTypeCheque) {
      chequeViewModel.deleteGlobalCheque(globalModel);
    } else if (globalModel.globalType == AppConstants.globalTypeBond) {
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
