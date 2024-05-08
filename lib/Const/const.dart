
import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/hive.dart';

enum EnvType { debug, release }

//release :
//      send data to logger
abstract class Const {
  static String dataName='';

  static init({String? oldData})async{
    if(dataName==''){
      await FirebaseFirestore.instance.collection(settingCollection).doc(dataCollection).get().then((value) {
        dataName=value.data()?['defaultDataName'];

      });
    }else{
      dataName=oldData!;
    }
    await HiveDataBase.setDataName(dataName);
    globalCollection=dataName;
  }
  static const EnvType env = EnvType.debug; //"debug" or "release"
  static const vatGCC = 0.05;
  static const vat0_01 = 0.01;
  static const rowCustomBondAmount = 'rowCustomBondAmount';
  static const rowBondId = 'id';
  static const rowBondCreditAmount = 'credit';
  static const rowBondDebitAmount = 'debit';
  static const rowBondAccount = 'secondary';
  static const rowBondDescription = 'description';
  static const noVatKey = 'noVat-';
  static const isFilterFree = false;
  ////////////--------------------------------------------------
  static const recordCollection = 'Record';
  static String bondsCollection = 'Bonds';
  static String accountsCollection = 'Accounts';
  static String invoicesCollection = 'Invoices';
  static String productsCollection = "Products";
  static String logsCollection = "Logs";
  static String patternCollection = "Patterns";
  static String storeCollection = "Stores";
  static String chequesCollection = "Cheques";
  static String costCenterCollection = "CostCenter";
  static String sellersCollection = "Sellers";
  static String usersCollection = "users";
  static String roleCollection = "Role";
  static String settingCollection = "Setting";
  static String globalCollection="$dataName";
  static String dataCollection = "data";
  ////////////--------------------------------------------------
  static const rowAccountId = 'rowAccountId';
  static const rowAccountTotal = 'rowAccountTotal';
  static const rowAccountType = 'rowAccountType';
  static const rowAccountName = 'rowAccountName';
  static const rowAccountBalance = 'rowAccountBalance';
  ////////////--------------------------------------------------
  static const rowInvId = "invId";
  static const rowInvProduct = "invProduct";
  static const rowInvQuantity = "invQuantity";
  static const rowInvSubTotal = "invSubTotal";
  static const rowInvVat = "rowInvVat";
  static const rowInvTotal = "invTotal";
  static const rowInvTotalVat = "rowInvTotalVat";
  ////////////--------------------------------------------------
  static const rowViewAccountId = "rowViewAccountId";
  static const rowViewAccountName = "rowViewAccountName";
  static const rowViewAccountCode = "rowViewAccountCode";
  static const rowViewAccountBalance = "rowViewAccountBalance";
  static const rowViewAccountLength = "rowViewAccountLength";
  ////////////--------------------------------------------------
  static const rowProductRecProduct = "rowProductRecProduct";
  static const rowProductType = "rowProductType";
  static const rowProductQuantity = "rowProductQuantity";
  static const rowProductDate = "rowProductDate";
  static const rowProductInvId = "rowProductInvId";
  static const productTypeService = "productTypeService";
  static const productTypeStore = "productTypeStore";
  ////////////--------------------------------------------------
  static const bondTypeDaily = "bondTypeDaily";
  static const bondTypeDebit = "bondTypeDebit";
  static const bondTypeCredit = "bondTypeCredit";
  ////////////--------------------------------------------------
  static const patId = "patId";
  static const patCode = "patCode";
  static const patPrimary = "patPrimary";
  static const patName = "patName";
  static const patType = "patType";
  ////////////--------------------------------------------------
  static const stCode = "stCode";
  static const stId = "stId";
  static const stName = "stName";
  ////////////--------------------------------------------------
  static const rowViewCheqId = 'rowViewCheqId';
  static const rowViewChequeStatus = 'rowViewChequeStatus';
  static const rowViewChequePrimeryAccount = 'rowViewChequePrimeryAccount';
  static const rowViewChequeSecoundryAccount = 'rowViewChequeSecoundryAccount';
  static const rowViewChequeAllAmount = 'rowViewChequeAllAmount';
  static const chequeStatusPaid = 'chequeStatusPaid';
  static const chequeStatusNotPaid = 'chequeStatusNotPaid';
  static const chequeStatusNotAllPaid = 'chequeStatusNotAllPaid';
  static const chequeTypePay = 'chequeTypePay';
  static const chequeTypeCatch = 'chequeTypeCatch';
  static const chequeTypeList = [chequeTypePay, chequeTypeCatch];
  static const chequeRecTypeInit = 'chequeRecTypeInit';
  static const chequeRecTypeAllPayment = 'chequeRecTypeAllPayment';
  static const chequeRecTypePartPayment = 'chequeRecTypePartPayment';
  ////////////--------------------------------------------------
  static const accountTypeDefault = "accountTypeDefault";
  static const accountTypeFinalAccount = "accountTypeFinalAccount";
  static const accountTypeAggregateAccount = "accountTypeAggregateAccount";
  static const accountTypeList = [accountTypeDefault,accountTypeFinalAccount,accountTypeAggregateAccount];
  ////////////--------------------------------------------------
  static const rowSellerAllInvoiceInvId = "rowSellerAllInvoiceInvId";
  static const rowSellerAllInvoiceAmount = "rowSellerAllInvoiceAmount";
  static const rowSellerAllInvoiceDate = "rowSellerAllInvoiceDate";
  ////////////--------------------------------------------------
  static const rowImportName = "rowImportName";
  static const rowImportPrice = "rowImportPrice";
  static const rowImportBarcode = "rowImportBarcode";
  static const rowImportCode = "rowImportCode";
  static const rowImportGroupCode = "rowImportGroupCode";
  static const rowImportHasVat = "rowImportHasVat";
  ////////////--------------------------------------------------
  static const roleUserRead = "roleUserRead";
  static const roleUserWrite = "roleUserWrite";
  static const roleUserUpdate = "roleUserUpdate";
  static const roleUserDelete = "roleUserDelete";
  static const roleUserAdmin = "roleUserAdmin";
  static const roleViewBond = "roleViewBond";
  static const roleViewAccount = "roleViewAccount";
  static const roleViewInvoice = "roleViewInvoice";
  static const roleViewProduct = "roleViewProduct";
  static const roleViewStore = "roleViewStore";
  static const roleViewPattern = "roleViewPattern";
  static const roleViewCheques = "roleViewCheques";
  static const roleViewSeller = "roleViewSeller";
  static const roleViewReport = "roleViewReport";
  static const roleViewImport = "roleViewImport";
  static const roleViewUserManagement = "roleViewUserManagement";
  static const allRolePage=[roleViewBond,roleViewAccount,roleViewInvoice,roleViewProduct,roleViewStore,roleViewPattern,roleViewCheques,roleViewSeller,roleViewReport,roleViewImport,roleViewUserManagement,];
  ////////////--------------------------------------------------
  static const invoiceChoosePriceMethodeCustomerPrice = "invoiceChoosePriceMethodeCustomerPrice";
  static const invoiceChoosePriceMethodeDefault = "invoiceChoosePriceMethodeCustomerPrice";
  static const invoiceChoosePriceMethodeLastPrice = "invoiceChoosePriceMethodeLastPrice";
  static const invoiceChoosePriceMethodeAveragePrice = "invoiceChoosePriceMethodeAveragePrice";
  static const invoiceChoosePriceMethodeHigher = "invoiceChoosePriceMethodeHigher";
  static const invoiceChoosePriceMethodeLower = "invoiceChoosePriceMethodeLower";
  static const invoiceChoosePriceMethodeMinPrice = "invoiceChoosePriceMethodeMinPrice";
  static const invoiceChoosePriceMethodeWholePrice = "invoiceChoosePriceMethodeWholePrice";
  static const invoiceChoosePriceMethodeRetailPrice = "invoiceChoosePriceMethodeRetailPrice";
  static const invoiceChoosePriceMethodeCostPrice = "invoiceChoosePriceMethodeCostPrice";
  static const invoiceChoosePriceMethodeCustom = "invoiceChoosePriceMethodeCustom";
  ////////////--------------------------------------------------
  static const rowAccountAggregateName= "rowAccountAggregateName";
  ////////////---------------------------------------------------
  static const globalTypeInvoice= "globalTypeInvoice";
  static const globalTypeBond= "globalTypeBond";
  static const globalTypeCheque= "globalTypeCheque";
  ////////////---------------------------------------------------
  static const invoiceRecordCollection="invoiceRecord";
  static const bondRecordCollection="bondRecord";
  static const chequeRecordCollection="chequeRecord";
  ////////////----------------------------------------------------
  static const productsAllSubscription  = "productsAllSubscription";
}

String getInvTypeFromEnum(String type) {
  switch (type) {
    case "sales":
      return "بيع";
    case "pay":
      return "شراء";
  }
  return type;
}
String getChequeTypefromEnum(String type) {
  switch (type) {
    case Const.chequeTypeCatch:
      return "شيك قبض";
    case Const.chequeTypePay:
      return "شيك دفع";
  }
  return "error";
}

String getBondTypeFromEnum(String type) {
  switch (type) {
    case Const.bondTypeDaily:
      return "يومية";
    case Const.bondTypeDebit:
      return "دفع";
    case Const.bondTypeCredit:
      return "قبض";
  }
  return "error";
}

String getProductTypeFromEnum(String type) {
  switch (type) {
    case Const.productTypeService:
      return "مواد خدمية";
    case Const.productTypeStore:
      return "مواد مستودعية";
  }
  return type;
}

String getAccountTypefromEnum(String type) {
  switch (type) {
    case Const.accountTypeDefault:
      return "حساب عادي";
    case Const.accountTypeFinalAccount:
      return "حساب ختامي";
    case Const.accountTypeAggregateAccount:
      return "حساب تجميعي";
    // case Const.accountTypeChequeCatch:
    //   return "حساب شيكات قبض";
    // case Const.accountTypeChequePay:
    //   return "حساب شيكات دفع";
    // case Const.accountTypeBank:
    //   return "حساب مصرف";
  }
  return "error";
}

String getChequeStatusfromEnum(String type) {
  switch (type) {
    case Const.chequeStatusPaid:
      return "تم الدفع";
    case Const.chequeStatusNotPaid:
      return "لم يتم الدفع";
    case Const.chequeStatusNotAllPaid:
      return "تم الدفع جزئبا";
  }
  return "error";
}

double getVatFromName(text) {
  return text == "a"
      ? 0
      : text == "GCC"
          ? 0.05
          : 0;
}
String getRoleNameFromEnum(String type) {
  switch (type) {
    case Const.roleUserRead:
      return "القراءة";
    case Const.roleUserWrite:
      return "الكتابة";
    case Const.roleUserUpdate:
      return "التعديل";
    case Const.roleUserDelete:
      return "الحذف";
    case Const.roleUserAdmin:
      return "الإدارة";
  }
  return "error";
}
String getPageNameFromEnum(String type) {
  switch (type) {
    case Const.roleViewInvoice:
      return "الفواتير";
    case Const.roleViewBond:
      return "السندات";
    case Const.roleViewAccount:
      return "الحسابات";
    case Const.roleViewProduct:
      return "المواد";
    case Const.roleViewStore:
      return "المستودعات";
    case Const.roleViewPattern:
      return "انماط البيع";
    case Const.roleViewCheques:
      return "الشيكات";
    case Const.roleViewSeller:
      return "البائعون";
    case Const.roleViewReport:
      return "تقارير المبيعات";
    case Const.roleViewImport:
      return "استيراد المعلومات";
    case Const.roleViewUserManagement:
      return "إدارة المستخدمين";
  }
  return "error";
}
String getNameOfRoleFromEnum(String type) {
  switch (type) {
    case Const.roleUserRead:
      return "قراءة البيانات";
    case Const.roleUserWrite:
      return "كتابة البيانات";
    case Const.roleUserUpdate:
      return "تعديل البيانات";
    case Const.roleUserDelete:
      return "حذف البيانات";
    case Const.roleUserAdmin:
      return "إدارة البيانات";
  }
  return type;
}