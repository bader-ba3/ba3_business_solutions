import 'package:ba3_business_solutions/model/bond/entry_bond_record_model.dart';
import 'package:ba3_business_solutions/model/invoice/invoice_discount_record_model.dart';

import '../../controller/account/account_controller.dart';
import '../../controller/pattern/pattern_controller.dart';
import '../../controller/seller/sellers_controller.dart';
import '../../controller/store/store_controller.dart';
import '../../core/constants/app_constants.dart';
import '../../core/helper/functions/functions.dart';
import '../bond/bond_record_model.dart';
import '../cheque/cheque_rec_model.dart';
import '../invoice/invoice_record_model.dart';

class GlobalModel {
  String? globalId,
      originAmenId,
      bondId,
      bondDescription,
      bondTotal,
      bondDate,
      bondCode,
      bondType,
      invId,
  invProFit,
      invName,
      invSubTotal,
      invPrimaryAccount,
      invMobileNumber,
      invSecondaryAccount,
      invStorehouse,
      invComment,
      invType,
      invFullCode,
      invGiftAccount,
      invSecGiftAccount,
      originId,
      patternId,
      invCode,
      invReturnCode,
      invReturnDate,
      invSeller,
      invDate,
      invVatAccount,
      invCustomerAccount,
      invPayType,
      invDueDate,
      invSecStorehouse,
      globalType,
      invPartnerCode;
  double? invTotal, invTotalPartner;
  double? discountTotal;
  double? addedTotal;
  double? firstPay;
  List<BondRecordModel>? bondRecord = [];
  List<InvoiceRecordModel>? invRecords = [];
  List<InvoiceDiscountRecordModel>? invDiscountRecord = [];
  bool? invIsPending, invIsPaid ,isDeleted;

  String? cheqId,
      cheqName,
      cheqAllAmount,
      cheqRemainingAmount,
      cheqPrimeryAccount,
      cheqSecoundryAccount,
      cheqCode,
      cheqDate,
      cheqStatus,
      cheqType,
      cheqBankAccount,
      cheqDeuDate,
      cheqPaidEntryBond;

  String? entryBondId, entryBondCode;

  List<EntryBondRecordModel>? entryBondRecord = [];

  List<ChequeRecModel>? cheqRecords = [];

  Map<String, dynamic> toJson() {
    return {
      if (globalId != null) 'globalId': globalId,
      if (invTotalPartner != null) 'invTotalPartner': invTotalPartner,
      if (invDueDate != null) 'invDueDate': invDueDate,
      if (cheqDeuDate != null) 'cheqDeuDate': cheqDeuDate,
      if (cheqPaidEntryBond != null) 'cheqPaidEntryBond': cheqPaidEntryBond,

      if (invIsPaid != null) 'invIsPaid': invIsPaid,
      if (invProFit != null) 'invProFit': invProFit,
      if (isDeleted != null) 'isDeleted': isDeleted,
      if (invPartnerCode != null) 'invPartnerCode': invPartnerCode,
      if (invReturnCode != null) 'invReturnCode': invReturnCode,
      if (invReturnDate != null) 'invReturnDate': invReturnDate,
      if (addedTotal != null) 'addedTotal': addedTotal,
      if (firstPay != null) 'firstPay': firstPay,
      if (discountTotal != null) 'discountTotal': discountTotal,
      if (invId != null) 'invId': invId,
      if (bondId != null) 'bondId': bondId,
      if (originAmenId != null) 'originAmenId': originAmenId,
      if (bondDescription != null) 'bondDescription': bondDescription,
      if (bondTotal != null) 'bondTotal': bondTotal,
      if (bondDate != null) 'bondDate': bondDate,
      if (bondCode != null) 'bondCode': bondCode,
      if (bondType != null) 'bondType': bondType,
      //  if(bondRecord!=null)"bondRecord": bondRecord?.map((record) => record.toJson()).toList(),
      if (invName != null) 'invName': invName,
      if (invTotal != null) 'invTotal': invTotal,
      if (invSubTotal != null) 'invSubTotal': invSubTotal,
      if (invPrimaryAccount != null) 'invPrimaryAccount': invPrimaryAccount,
      if (invSecondaryAccount != null)
        'invSecondaryAccount': invSecondaryAccount,
      if (invStorehouse != null) 'invStorehouse': invStorehouse,
      if (invComment != null) 'invComment': invComment,
      if (invType != null) 'invType': invType,
      if (originId != null) 'originId': originId,
      // if (invRecords != null) "invRecords": invRecords?.map((record) => record.toJson()).toList(),
      if (invDiscountRecord != null)
        "invDiscountRecord":
            invDiscountRecord?.map((record) => record.toJson()).toList(),
      if (invCode != null) "invCode": invCode,
      if (patternId != null) "patternId": patternId,
      if (invSeller != null) "invSeller": invSeller,
      if (invDate != null) "invDate": invDate,
      if (invMobileNumber != null) "invMobileNumber": invMobileNumber,
      if (invVatAccount != null) "invVatAccount": invVatAccount,
      if (invPayType != null) "invPayType": invPayType,
      if (invCustomerAccount != null) "invCustomerAccount": invCustomerAccount,
      if (invFullCode != null) "invFullCode": invFullCode,
      if (invIsPending != null) "invIsPending": invIsPending,
      if (globalType != null) "globalType": globalType,
      if (invSecStorehouse != null) "invSecStorehouse": invSecStorehouse,
      if (invGiftAccount != null) "invGiftAccount": invGiftAccount,
      if (invSecGiftAccount != null) "invSecGiftAccount": invSecGiftAccount,
      // if(patternModel != null)"pattrenModel"

      if (cheqId != null) 'cheqId': cheqId,
      if (cheqName != null) 'cheqName': cheqName,
      if (cheqAllAmount != null) 'cheqAllAmount': cheqAllAmount,
      if (cheqRemainingAmount != null)
        'cheqRemainingAmount': cheqRemainingAmount,
      if (cheqPrimeryAccount != null) 'cheqPrimeryAccount': cheqPrimeryAccount,
      if (cheqSecoundryAccount != null)
        'cheqSecoundryAccount': cheqSecoundryAccount,
      if (cheqCode != null) 'cheqCode': cheqCode,
      if (cheqDate != null) 'cheqDate': cheqDate,
      if (cheqStatus != null) 'cheqStatus': cheqStatus,
      if (discountTotal != null) 'discountTotal': discountTotal,
      if (cheqType != null) 'cheqType': cheqType,
      if (cheqBankAccount != null) 'cheqBankAccount': cheqBankAccount,

      if (entryBondId != null) 'entryBondId': entryBondId,
      if (entryBondCode != null) 'entryBondCode': entryBondCode,
    };
  }

  Map<String, dynamic> toFullJson() {
    return {
      if (globalId != null) 'globalId': globalId,
      if (invTotalPartner != null) 'invTotalPartner': invTotalPartner,
      if (invDueDate != null) 'invDueDate': invDueDate,
      if (cheqDeuDate != null) 'cheqDeuDate': cheqDeuDate,
      if (cheqPaidEntryBond != null) 'cheqPaidEntryBond': cheqPaidEntryBond,
      if (invPartnerCode != null) 'invPartnerCode': invPartnerCode,
      if (addedTotal != null) 'addedTotal': addedTotal,
      if (invIsPaid != null) 'invIsPaid': invIsPaid,
      if (invProFit != null) 'invProFit': invProFit,
      if (isDeleted != null) 'isDeleted': isDeleted,
      if (firstPay != null) 'firstPay': firstPay,
      if (invId != null) 'invId': invId,
      if (originAmenId != null) 'originAmenId': originAmenId,
      if (bondId != null) 'bondId': bondId,
      if (bondDescription != null) 'bondDescription': bondDescription,
      if (bondTotal != null) 'bondTotal': bondTotal,
      if (bondDate != null) 'bondDate': bondDate,
      if (invReturnDate != null) 'invReturnDate': invReturnDate,
      if (invReturnCode != null) 'invReturnCode': invReturnCode,
      if (bondCode != null) 'bondCode': bondCode,
      if (bondType != null) 'bondType': bondType,
      if (discountTotal != null) 'discountTotal': discountTotal,
      if (bondRecord != null)
        "bondRecord": bondRecord?.map((record) => record.toJson()).toList(),
      if (invName != null) 'invName': invName,
      if (invTotal != null) 'invTotal': invTotal,
      if (invSubTotal != null) 'invSubTotal': invSubTotal,
      if (invPrimaryAccount != null) 'invPrimaryAccount': invPrimaryAccount,
      if (invSecondaryAccount != null)
        'invSecondaryAccount': invSecondaryAccount,
      if (invStorehouse != null) 'invStorehouse': invStorehouse,
      if (invComment != null) 'invComment': invComment,
      if (invType != null) 'invType': invType,
      if (invPayType != null) 'invPayType': invPayType,
      if (originId != null) 'originId': originId,
      if (invRecords != null)
        "invRecords": invRecords?.map((record) => record.toJson()).toList(),
      if (invDiscountRecord != null)
        "invDiscountRecord":
            invDiscountRecord?.map((record) => record.toJson()).toList(),
      if (invCode != null) "invCode": invCode,
      if (patternId != null) "patternId": patternId,
      if (invSeller != null) "invSeller": invSeller,
      if (invDate != null) "invDate": invDate,
      if (invMobileNumber != null) "invMobileNumber": invMobileNumber,
      if (invVatAccount != null) "invVatAccount": invVatAccount,
      if (invCustomerAccount != null) "invCustomerAccount": invCustomerAccount,
      if (invFullCode != null) "invFullCode": invFullCode,
      if (invIsPending != null) "invIsPending": invIsPending,
      if (invSecStorehouse != null) "invSecStorehouse": invSecStorehouse,
      if (globalType != null) "globalType": globalType,
      if (cheqId != null) 'cheqId': cheqId,
      if (cheqName != null) 'cheqName': cheqName,
      if (cheqAllAmount != null) 'cheqAllAmount': cheqAllAmount,
      if (cheqRemainingAmount != null)
        'cheqRemainingAmount': cheqRemainingAmount,
      if (cheqPrimeryAccount != null) 'cheqPrimeryAccount': cheqPrimeryAccount,
      if (cheqSecoundryAccount != null)
        'cheqSecoundryAccount': cheqSecoundryAccount,
      if (cheqCode != null) 'cheqCode': cheqCode,
      if (cheqDate != null) 'cheqDate': cheqDate,
      if (cheqStatus != null) 'cheqStatus': cheqStatus,
      if (cheqType != null) 'cheqType': cheqType,
      if (cheqBankAccount != null) 'cheqBankAccount': cheqBankAccount,
      if (cheqRecords != null)
        "cheqRecords": cheqRecords?.map((record) => record.toJson()).toList(),
      if (entryBondId != null) 'entryBondId': entryBondId,
      if (entryBondCode != null) 'entryBondCode': entryBondCode,
      if (entryBondRecord != null)
        "entryBondRecord":
            entryBondRecord?.map((record) => record.toJson()).toList(),
      if (invGiftAccount != null) "invGiftAccount": invGiftAccount,
      if (invSecGiftAccount != null) "invSecGiftAccount": invSecGiftAccount,
    };
  }

  factory GlobalModel.fromJson(json) {
    if (json == null) {
      return GlobalModel();
    }

/*    List<InvoiceRecordModel> invRecordList = [];
    FirebaseFirestore.instance.collection("2024").doc(json["entryBondId"]).collection("invoiceRecord").get().then((value) {
      for (var e in value.docs) {
        invRecordList.add(InvoiceRecordModel.fromJson(e.data()));
      }
    },);*/
    List<BondRecordModel>? bondRecordList = json['bondRecord'] == null
        ? []
        : json['bondRecord']
            ?.map<BondRecordModel>((dynamic e) => BondRecordModel.fromJson(e))
            .toList();
    List<InvoiceRecordModel>? invRecordList = json['invRecords'] == null
        ? []
        : json['invRecords']
            ?.map<InvoiceRecordModel>(
                (dynamic e) => InvoiceRecordModel.fromJson(e))
            .toList();
    List<ChequeRecModel>? cheqRecord = json['cheqRecords'] == null
        ? []
        : json['cheqRecords']
            ?.map<ChequeRecModel>((dynamic e) => ChequeRecModel.fromJson(e))
            .toList();
    List<EntryBondRecordModel>? entryBondRecord =
        json['entryBondRecord'] == null
            ? []
            : json['entryBondRecord']
                ?.map<EntryBondRecordModel>(
                    (dynamic e) => EntryBondRecordModel.fromJson(e))
                .toList();
    List<InvoiceDiscountRecordModel>? invDiscountRecord =
        json['invDiscountRecord'] == null
            ? []
            : json['invDiscountRecord']
                ?.map<InvoiceDiscountRecordModel>(
                    (dynamic e) => InvoiceDiscountRecordModel.fromJson(e))
                .toList();
    return GlobalModel(
      globalId: json['globalId'],
      bondId: json['bondId'],
      invTotalPartner: json['invTotalPartner'],
      invPartnerCode: json['invPartnerCode'],
      discountTotal: json['discountTotal'],
      cheqDeuDate: json['cheqDeuDate'],
      invProFit: json['invProFit'],
      cheqPaidEntryBond: json['cheqPaidEntryBond'],
      firstPay: json['firstPay'],
      addedTotal: json['addedTotal'],
      isDeleted: json['isDeleted'],
      invIsPaid:
          json['invIsPaid'] ?? json['invPayType'] == AppConstants.invPayTypeCash
              ? true
              : false,
      originAmenId: json['originAmenId'],
      bondDescription: json['bondDescription'],
      bondTotal: json['bondTotal'],
      invDueDate:
          json['invDueDate'] ?? json['bondDate'] ?? json['invDate'] ?? '',
      bondDate: json['bondDate'],
      bondCode: json['bondCode'],
      invReturnCode: json['invReturnCode'],
      invReturnDate: json['invReturnDate'],
      bondType: json['bondType'],
      bondRecord: bondRecordList,
      invId: json['invId'],
      invName: json['invName'],
      invTotal: json['invTotal'] == null
          ? null
          : double.parse(json['invTotal'].toString()),
      invSubTotal: json['invSubTotal'],
      invPrimaryAccount: json['invPrimaryAccount'],
      invSecondaryAccount: json['invSecondaryAccount'],
      invStorehouse: json['invStorehouse'],
      invComment: json['invComment'],
      invPayType: json['invPayType'],
      invType: json['invType'],
      originId: json['originId'],
      invRecords: invRecordList,
      invDiscountRecord: invDiscountRecord,
      invCode: json['invCode'],
      patternId: json['patternId'],
      invSeller: json['invSeller'],
      invDate: json['invDate'],
      invMobileNumber: json['invMobileNumber'],
      invVatAccount: json['invVatAccount'],
      invCustomerAccount: json['invCustomerAccount'],
      invFullCode: json['invFullCode'],
      invIsPending: json['invIsPending'],
      invSecStorehouse: json['invSecStorehouse'],
      globalType: json['globalType'],
      cheqId: json['cheqId'],
      cheqName: json['cheqName'],
      cheqAllAmount: json['cheqAllAmount'],
      cheqRemainingAmount: json['cheqRemainingAmount'],
      cheqPrimeryAccount: json['cheqPrimeryAccount'],
      cheqSecoundryAccount: json['cheqSecoundryAccount'],
      cheqCode: json['cheqCode'],
      cheqDate: json['cheqDate'],
      cheqStatus: json['cheqStatus'],
      cheqType: json['cheqType'],
      cheqBankAccount: json['cheqBankAccount'],
      cheqRecords: cheqRecord,
      entryBondId: json['entryBondId'],
      entryBondCode: json['entryBondCode'],
      invGiftAccount: json['invGiftAccount'],
      invSecGiftAccount: json['invSecGiftAccount'],
      entryBondRecord: entryBondRecord,
    );
  }



  String? affectedId() {
    return invId ?? bondId;
  }

  String? affectedKey({String? type}) {
    return type == AppConstants.globalTypeInvoice ? "invId" : "bondId";
  }

  GlobalModel({
    this.globalId,
    this.bondId,
    this.invPartnerCode,
    this.invTotalPartner,
    this.invReturnDate,
    this.cheqDeuDate,
    this.cheqPaidEntryBond,
    this.invReturnCode,
    this.invIsPaid,
    this.invProFit,
    this.originAmenId,
    this.bondDescription,
    this.bondTotal,
    this.bondDate,
    this.bondCode,
    this.bondRecord,
    this.bondType,
    this.invDueDate,
    this.invId,
    this.invName,
    this.invTotal,
    this.invSubTotal,
    this.invPrimaryAccount,
    this.invSecondaryAccount,
    this.invStorehouse,
    this.invDiscountRecord,
    this.invComment,
    this.invType,
    this.invPayType,
    this.invRecords,
    this.originId,
    this.invCode,
    this.patternId,
    this.invSeller,
    this.invDate,
    this.invMobileNumber,
    this.invVatAccount,
    this.invCustomerAccount,
    this.invFullCode,
    this.invSecStorehouse,
    this.invIsPending,
    this.globalType,
    this.cheqId,
    this.cheqName,
    this.cheqAllAmount,
    this.cheqRemainingAmount,
    this.cheqPrimeryAccount,
    this.cheqSecoundryAccount,
    this.cheqCode,
    this.cheqDate,
    this.cheqStatus,
    this.cheqType,
    this.cheqBankAccount,
    this.cheqRecords,
    this.entryBondId,
    this.entryBondCode,
    this.entryBondRecord,
    this.invGiftAccount,
    this.invSecGiftAccount,
    this.discountTotal,
    this.firstPay,
    this.addedTotal,
    this.isDeleted,
  });

  Map<String, dynamic> toMap({String? type}) {
    if (type == AppConstants.globalTypeInvoice) {
      return {
        "الرقم التسلسلي": invId ?? '',
        "الرمز": invCode ?? '',
        "النمط": getPatModelFromPatternId(patternId).patName ?? '', //Isolate
        "التاريخ": invDate ?? '',
        "تاريخ الاستحقاق": invDueDate ?? '',
        "نوع الفاتورة": getInvPayTypeFromEnum(invPayType ?? ""),
        'المجموع الكلي': (invTotal ?? 0).toStringAsFixed(2),
        'المستودع': getStoreNameFromId(invStorehouse), //Isolate
        'دائن': getAccountNameFromId(invPrimaryAccount), //Isolate
        'مدين': getAccountNameFromId(invSecondaryAccount), //Isolate
        "رقم جوال العميل": invMobileNumber ?? '',

        "حساب العميل": getAccountNameFromId(invCustomerAccount), //Isolate
        'النوع': getInvTypeFromEnum(invType ?? ""),
        "حساب البائع": getSellerNameFromId(invSeller), //Isolate
        'وصف': invComment ?? '',
        'ربح الفاتورة': invProFit ?? '',
      };
    } else if (type == AppConstants.globalTypeBond) {
      return {
        'bondId': bondId ?? entryBondId,
        'رقم السند': bondCode,
        // 'AmenCode': originAmenId,
        'نوع السند': getBondTypeFromEnum(bondType ?? ""),
        'تاريخ السند': bondDate,
        'القيمة': bondRecord
                ?.map(
                  (e) => e.bondRecDebitAmount!,
                )
                .toList()
                .fold(
                  0.0,
                  (previousValue, element) => previousValue + element,
                ) ??
            '',
        'البيان': bondDescription,
        "الحسابات المتأثرة": bondRecord
                ?.map(
                  (e) => getAccountNameFromId(e.bondRecAccount),
                )
                .toList() ??
            ''
      };
    } else if (type == AppConstants.globalTypeCheque) {
      return {
        'cheqId': cheqId,
        'رقم الشيك': cheqName,

        // 'نوع الشيك ورقمه': cheqName,
        'القيمة': cheqAllAmount,
        'تاريخ التحرير': cheqDate!.split(" ")[0],
        'تاريخ الاستحقاق': cheqDeuDate?.split(" ")[0] ?? '',
        // 'cheqRemainingAmount': cheqRemainingAmount,
        'حساب الورقة': getAccountNameFromId(cheqPrimeryAccount),
        'الحساب المقابل': getAccountNameFromId(cheqSecoundryAccount),

        'حالة الشيك': getChequeStatusFromEnum(cheqStatus.toString()),
        'نوع الشيك': getChequeTypeFromEnum(cheqType.toString()),
        'اسم البنك': getAccountNameFromId(cheqBankAccount),
      };
    } else if (type == AppConstants.globalTypeAccountDue) {
      return {
        "الرقم التسلسلي": invId ?? '',
        "الرمز": invCode ?? '',
        "النمط": getPatModelFromPatternId(patternId).patFullName ?? '',
        //Isolate
        "التاريخ": invDate?.split(" ")[0] ?? '',
        "تاريخ الاستحقاق": invDueDate?.split("T")[0] ?? '',
        // "حالة الفاتورة":invIsPaid,
        // "نوع الفاتورة": getInvPayTypeFromEnum(invPayType ?? ""),
        'المجموع الكلي': (invTotal ?? 0).toStringAsFixed(2),
        'المستودع': getStoreNameFromId(invStorehouse),
        //Isolate
        'دائن': getAccountNameFromId(invPrimaryAccount),
        //Isolate
        'مدين': getAccountNameFromId(invSecondaryAccount),
        //Isolate
        "رقم جوال العميل": invMobileNumber ?? '',
        'النوع': getInvTypeFromEnum(invType ?? ""),
        'وصف': invComment ?? '',
      };
    } else if (type == AppConstants.globalTypeStartersBond) {
      return {
        'bondId': entryBondId,
        'رقم السند': entryBondCode ?? 0,
        // 'AmenCode': originAmenId,
        'تاريخ السند': bondDate ?? invDate,
        'القيمة': bondRecord
                ?.map(
                  (e) => e.bondRecDebitAmount!,
                )
                .toList()
                .fold(
                  0.0,
                  (previousValue, element) => previousValue + element,
                ) ??
            '',
        'البيان': bondDescription,
        "الحسابات المتأثرة": entryBondRecord
                ?.map(
                  (e) => getAccountNameFromId(e.bondRecAccount),
                )
                .toList() ??
            ''
      };
    } else {
      return toFullJson();
    }
  }

  Map<String, dynamic> toBondAR({String? type}) {
    return {
      'bondCode': bondCode,
      'AmenCode': originAmenId,
      'bondType': getBondTypeFromEnum(bondType ?? ""),
      'bondDate': bondDate,
      'bondTotal': bondRecord
          ?.map((e) => e.bondRecDebitAmount)
          .reduce((value, element) => value! + element!)!
          .toStringAsFixed(2),
      'bondDescription': bondDescription,
    };
  }

  Map<String, dynamic> toEntryBondAR({String? type}) {
    return {
      'bondCode': entryBondCode,
      'AmenCode': originAmenId,
      'bondType': getBondTypeFromEnum(bondType ?? ""),
      'bondDate': bondDate,
      'bondTotal': entryBondRecord
          ?.map((e) => e.bondRecDebitAmount)
          .reduce((value, element) => value! + element!)!
          .toStringAsFixed(2),
      'bondDescription': bondDescription,
    };
  }
}

GlobalModel getBondData() {
  return GlobalModel(bondId: null, bondTotal: "0", bondRecord: [
    BondRecordModel('00', 0, 0, "", ""),
  ]);
}
