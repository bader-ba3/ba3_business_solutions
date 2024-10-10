import 'package:ba3_business_solutions/controller/account/account_view_model.dart';
import 'package:ba3_business_solutions/controller/global/global_view_model.dart';
import 'package:ba3_business_solutions/core/constants/app_strings.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:ba3_business_solutions/view/bonds/pages/bond_details_view.dart';
import 'package:ba3_business_solutions/view/bonds/pages/custom_bond_details_view.dart';
import 'package:ba3_business_solutions/view/bonds/widget/bond_record_pluto_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../core/utils/generate_id.dart';
import '../../model/bond/bond_record_model.dart';
import '../../view/bonds/widget/bond_record_data_source.dart';
import '../../view/bonds/widget/custom_bond_record_data_source.dart';

class BondViewModel extends GetxController {
  late BondRecordDataSource recordDataSource;
  late DataGridController dataGridController;
  late CustomBondRecordDataSource customBondRecordDataSource;
  final TextEditingController noteController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController codeController = TextEditingController();
  final TextEditingController debitOrCreditController = TextEditingController();
  String? lastBondOpened;
  GlobalModel bondModel = GlobalModel();
  RxMap<String, GlobalModel> allBondsItem = <String, GlobalModel>{}.obs;
  bool isEdit = false;
  GlobalModel tempBondModel = GlobalModel();
  Map<String, String> codeList = {};
  TextEditingController userAccountController = TextEditingController();



  initGlobalBond(GlobalModel globalModel) {


    allBondsItem[globalModel.bondId!] = globalModel;


  }

  deleteGlobalBond(GlobalModel globalModel) {
    allBondsItem.removeWhere((key, value) => key == globalModel.bondId);
  }



  void restoreOldData() {
    tempBondModel = GlobalModel.fromJson(bondModel.toFullJson());
    update();


  }

  void changeIndexCode({required String code, required String type}) {
    var model = allBondsItem.values.toList().firstWhereOrNull(
        (element) => element.bondCode == code && element.bondType == type);
    if (model == null) {
      Get.snackbar("خطأ", "غير موجود");
    } else {
      tempBondModel = GlobalModel.fromJson(model.toFullJson());
      bondModel = GlobalModel.fromJson(model.toFullJson());
      if (bondModel.bondType == AppStrings.bondTypeDaily ||
          bondModel.bondType == AppStrings.bondTypeStart ||
          bondModel.bondType == AppStrings.bondTypeInvoice) {
        Get.off(() => BondDetailsView(
              oldId: bondModel.bondId,
              bondType: bondModel.bondType!,
            ));
        update();
      } else {
        Get.off(() => CustomBondDetailsView(
              oldId: bondModel.bondId,
              isDebit: bondModel.bondType == AppStrings.bondTypeDebit,
            ));
        update();
      }
    }
    update();
  }

  void deleteBondById(String? bondId) {
    allBondsItem.removeWhere((key, value) => key == bondId);
    // initPage(tempBondModel.bondType);
    update();
  }


  bool isNew = false;

  initPage({String? oldId, String? type}) {
    final plutoEditViewModel = Get.find<BondRecordPlutoViewModel>();
    initCodeList(type);
    if (oldId != null) {
      tempBondModel = allBondsItem[oldId]!;
      bondModel = allBondsItem[oldId]!;
      codeController.text = tempBondModel.bondCode!;
      dateController.text = tempBondModel.bondDate!.split(" ")[0];
      noteController.text = tempBondModel.bondDescription ?? '';

      if (tempBondModel.bondType == AppStrings.bondTypeCredit) {
        debitOrCreditController.text =
            getAccountNameFromId(tempBondModel.bondRecord?.last.bondRecAccount);
        plutoEditViewModel.getRows(
            tempBondModel.bondRecord
                    ?.where(
                      (element) => (element.bondRecCreditAmount ?? 0) > 0,
                    )
                    .toList() ??
                [],
            type!);
      } else if (tempBondModel.bondType == AppStrings.bondTypeDebit) {
        debitOrCreditController.text =
            getAccountNameFromId(tempBondModel.bondRecord?.last.bondRecAccount);
        plutoEditViewModel.getRows(
            tempBondModel.bondRecord
                    ?.where(
                      (element) => (element.bondRecDebitAmount ?? 0) > 0,
                    )
                    .toList() ??
                [],
            type!);
      } else {
        debitOrCreditController.text = "";
        plutoEditViewModel.getRows(
            tempBondModel.bondRecord?.toList() ?? [], type!);
      }
      isNew = false;
    } else {
      plutoEditViewModel.getRows([], type!);
      tempBondModel = GlobalModel();
      codeController.text = getNextBondCode(type: type);
      dateController.text = '';
      noteController.text = '';

      debitOrCreditController.text = '';
      isNew = true;
    }
    tempBondModel.bondType = type;


    WidgetsFlutterBinding.ensureInitialized()
        .waitUntilFirstFrameRasterized
        .then(
      (value) {
        update();
      },
    );
  }

  void initTotal() {
    double debit = 0;
    double credit = 0;
    tempBondModel.bondRecord?.forEach((element) {
      debit = debit + (element.bondRecDebitAmount ?? 0);
      credit = credit + (element.bondRecCreditAmount ?? 0);
    });
    tempBondModel.bondTotal = (debit - credit).toStringAsFixed(2);
  }


  Future<void> fastAddBondToFirebase(
      {required String entryBondId,
      String? amenCode,
      String? bondId,
      String? bondDes,
      String? oldBondCode,
      String? originId,
      required double total,
      required List<BondRecordModel> record,
      String? bondDate,
      String? bondType}) async {
    tempBondModel = GlobalModel();
    tempBondModel.bondRecord = record;
    tempBondModel.originId = originId;
    tempBondModel.originAmenId = amenCode;
    if (entryBondId == "") {
      tempBondModel.entryBondId = generateId(RecordType.entryBond);
    } else {
      tempBondModel.entryBondId = entryBondId;
    }
    if (bondId == null) {
      tempBondModel.bondId = generateId(RecordType.bond);
    } else {
      tempBondModel.bondId = bondId;
    }
    tempBondModel.bondTotal = total.toString();
    tempBondModel.bondType = bondType;
    tempBondModel.bondDescription = bondDes;
    tempBondModel.bondType ??= AppStrings.bondTypeDaily;
    tempBondModel.globalType = AppStrings.globalTypeBond;

    if (oldBondCode == null) {
      var bondCode = "";
      if (!isEdit) {
        // String bondId = generateId(RecordType.bond);
        bondCode =
            (int.parse(allBondsItem.values.lastOrNull?.bondCode ?? "0") + 1)
                .toString();
        while (allBondsItem.values
            .toList()
            .map((e) => e.bondCode)
            .toList()
            .contains(bondCode)) {
          bondCode = (int.parse(bondCode) + 1).toString();
        }
      }
      tempBondModel.bondCode = bondCode;
    } else {
      tempBondModel.bondCode = oldBondCode;
    }
    tempBondModel.bondDate = bondDate;
    tempBondModel.bondDate ??= DateTime.now().toString().split(" ")[0];
    var globalController = Get.find<GlobalViewModel>();

    await globalController.addBondToFirebase(tempBondModel);
  }



  initCodeList(type) {
    codeList = {};
    for (var element in allBondsItem.values) {
      if ((element.bondType!) == type) {
        codeList[element.bondCode ?? '0'] = element.bondId!;
      }
    }

    codeList = Map.fromEntries(codeList.entries.toList()
      ..sort(
        (a, b) {
          if (a.key.startsWith("F") && b.key.startsWith("F")) {
            return int.parse((a.key).split("F-")[1])
                .compareTo(int.parse((b.key).split("F-")[1]));
          } else if (a.key.startsWith("F")) {
            return int.parse((a.key).split("F-")[1])
                .compareTo(int.parse(b.key));
          } else if (b.key.startsWith("F")) {
            return int.parse((a.key))
                .compareTo(int.parse((b.key).split("F-")[1]));
          } else {
            return int.parse(a.key).compareTo(int.parse(b.key));
          }
        },
      ));
  }

  getBondByCode(String bondType, bondCode) {
    List<GlobalModel> bond = allBondsItem.values
        .where((element) =>
            element.globalType == AppStrings.globalTypeBond &&
            element.bondType == bondType &&
            element.bondCode == bondCode)
        .toList();
    if (bond.isNotEmpty) {
      initPage(oldId: bond.first.bondId!, type: bond.first.bondType!);
    } else {
      Get.snackbar("خطأ رقم السند", "رقم السند غير موجود",
          icon: const Icon(
            Icons.error,
            color: Colors.red,
            textDirection: TextDirection.rtl,
          ));
      codeController.text = tempBondModel.bondCode ?? "";
    }

    update();
  }

  bondNextOrPrev(String bondType, bool isPrev) {
    List<GlobalModel> bond = allBondsItem.values
        .where((element) =>
            element.globalType == AppStrings.globalTypeBond &&
            element.bondType == bondType)
        .toList()
        .reversed
        .toList();
    // log(bond.map((e) => [e.bondCode.toString(),e.bondId.toString()],).toList().toString());
    bond.sort(
      (a, b) {
        if (a.bondCode!.startsWith("F") && b.bondCode!.startsWith("F")) {
          return int.parse((a.bondCode ?? "F-0").split("F-")[1])
              .compareTo(int.parse((b.bondCode ?? "F-0").split("F-")[1]));
        } else if (a.bondCode!.startsWith("F")) {
          return int.parse((a.bondCode ?? "F-0").split("F-")[1])
              .compareTo(int.parse(b.bondCode ?? "0"));
        } else if (b.bondCode!.startsWith("F")) {
          return int.parse((a.bondCode ?? "0"))
              .compareTo(int.parse((b.bondCode ?? "F-0").split("F-")[1]));
        } else {
          return int.parse(a.bondCode ?? "0")
              .compareTo(int.parse(b.bondCode ?? "0"));
        }
      },
    );
    int currentPosition = bond.indexOf(bond
            .where(
              (element) => element.bondCode == codeController.text,
            )
            .firstOrNull ??
        bond.last);

    if (isPrev) {
      if (currentPosition != 0) {
        if (bond
            .where(
              (element) => element.bondCode == codeController.text,
            )
            .isNotEmpty) {
          initPage(
              oldId: bond[currentPosition - 1].bondId!,
              type: bond[currentPosition - 1].bondType!);
        } else {
          initPage(oldId: bond.last.bondId!, type: bond.last.bondType!);
        }
      }
    } else {
      if (currentPosition < bond.length - 1) {
        initPage(
            oldId: bond[currentPosition + 1].bondId!,
            type: bond[currentPosition + 1].bondType!);
      }
    }
    update();
  }







  String getNextBondCode({String? type}) {
    initCodeList(type ?? (tempBondModel.bondType!));
    int nextIndex = 0;
    if (codeList.isEmpty) {
      return "0";
    } else {
      if (codeList.keys.last.startsWith("F")) {
        nextIndex = int.parse(codeList.keys.last.split("F-")[1]);
      } else {
        nextIndex = int.parse(codeList.keys.last);
      }
      while (codeList.containsKey(nextIndex.toString())) {
        nextIndex++;
      }
    }
    return nextIndex.toString();
  }

  String? checkValidate() {
    String? text;
    tempBondModel.bondRecord?.forEach((element) {
      if (element.bondRecAccount == '' ||
          element.bondRecAccount == null ||
          element.bondRecId == null ||
          (element.bondRecCreditAmount == 0 &&
              element.bondRecDebitAmount == 0)) {
        // print("empty");
        text = "الحقول فارغة";
      } else {
        // print("ok");
      }
    });
    if (text != null) return text;
    if ((tempBondModel.bondType == AppStrings.bondTypeDaily ||
            tempBondModel.bondType == AppStrings.bondTypeStart) &&
        double.parse(tempBondModel.bondTotal!) != 0) {
      return "خطأ بالمجموع";
    } else if ((tempBondModel.bondType != AppStrings.bondTypeDaily &&
            tempBondModel.bondType != AppStrings.bondTypeStart) &&
        double.parse(tempBondModel.bondTotal!) == 0) {
      return "خطأ بالمجموع";
    }
    if (tempBondModel.bondCode == null ||
        int.tryParse(tempBondModel.bondCode!) == null) {
      return "الرمز فارغ";
    }
    return null;
  }
}
// String getNextBondCode(){
//   var bondController = Get.find<BondViewModel>();
//   if(bondController.allBondsItem.values.isEmpty){
//     return "1";
//   }
//   List codeList=bondController.allBondsItem.values.toList().map((e) => e.bondCode).toList();
//   String code=codeList.last;
//   code =(int.parse(code)+1).toString();
//   while (codeList.contains(code)) {
//     code =(int.parse(code)+1).toString();
//   }
//   return code;
// }
