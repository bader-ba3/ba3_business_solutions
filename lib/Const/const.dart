
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';

import '../utils/hive.dart';

enum EnvType { debug, release }

//release :
//      send data to logger
abstract class Const {
  static String dataName='';
  static bool isFreeType=false;

  static init({String? oldData,bool? isFree})async{
    if(dataName==''){
      // await FirebaseFirestore.instance.collection(settingCollection).doc(dataCollection).get().then((value) {
      //   dataName=value.data()?['defaultDataName'];
      // });
      dataName="2024";
    }else{
      dataName=oldData!;
    }
    await HiveDataBase.setDataName(dataName);
    globalCollection=dataName;
    if(isFree!=null){
      isFreeType = isFree;
    }else{

      isFreeType = HiveDataBase.isFree.get("isFreeType")??false;
    }

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
  static const minMobileTarget = 1000;
  static const minOtherTarget = 1000;
  ////////////--------------------------------------------------
  static String changesCollection = dataName+"-"+'Changes';
  static const recordCollection = 'Record';
  static String bondsCollection = 'Bonds';
  static String accountsCollection = 'Accounts';
  static String tasksCollection = 'Tasks';
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
  static String readFlagsCollection = "ReadFlags";
  static String inventoryCollection = "Inventory";
  static String globalCollection=dataName;
  static String dataCollection = "data";
  ////////////--------------------------------------------------
  static const rowAccountId = 'rowAccountId';
  static const rowAccountTotal = 'rowAccountTotal';
  static const rowAccountTotal2 = 'rowAccountTotal2';
  static const rowAccountType = 'rowAccountType';
  static const rowAccountName = 'rowAccountName';
  static const rowAccountDate = 'rowAccountDate';
  static const rowAccountBalance = 'rowAccountBalance';
  ////////////--------------------------------------------------
  static const rowInvId = "invId";
  static const rowInvProduct = "invProduct";
  static const rowInvGift = "rowInvGift";
  static const rowInvQuantity = "invQuantity";
  static const rowInvSubTotal = "invSubTotal";
  static const rowInvVat = "rowInvVat";
  static const rowInvTotal = "invTotal";
  static const rowInvTotalVat = "rowInvTotalVat";
  static const rowInvDiscountId = "rowInvDiscountId";
  static const rowInvDiscountAccount = "rowInvDiscountAccount";
    static const rowInvDisAddedTotal = "rowInvDisAddedTotal";
  static const rowInvDisAddedPercentage = "rowInvDisAddedPercentage";
  static const rowInvDisDiscountTotal = "rowInvDisDiscountTotal";
  static const rowInvDisDiscountPercentage = "rowInvDisDiscountPercentage";
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
  static const rowProductTotal = "rowProductTotal";
  static const rowProductInvId = "rowProductInvId";
  static const productTypeService = "productTypeService";
  static const productTypeStore = "productTypeStore";
  ////////////--------------------------------------------------
  static const bondTypeDaily = /*"سند يومية";*/"bondTypeDaily";
  static const bondTypeDebit = /*"سند قبض";*/"bondTypeDebit";
  static const bondTypeCredit = /*"سند دفع";*/"bondTypeCredit";
  static const bondTypeStart = /*"قيد افتتاحي";*/"bondTypeStart";
  static const bondTypeInvoice = /*"سند قيد";*/"bondTypeInvoice";
  ////////////--------------------------------------------------
  static const patId = "patId";
  static const patCode = "patCode";
  static const patPrimary = "patPrimary";
  static const patName = "patName";
  static const patType = "patType";
  ////////////--------------------------------------------------
  static const invoiceTypeSales = "invoiceTypeSales";
  static const invoiceTypeBuy = 'invoiceTypeBuy';
  static const invoiceTypeAdd = "invoiceTypeAdd";
  static const invoiceTypeChange = "invoiceTypeChange";
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
  static const roleViewTask = "roleViewTask";
  static const roleViewTarget = "roleViewTarget";
  static const roleViewInventory = "roleViewInventory";
  static const roleViewUserManagement = "roleViewUserManagement";
  static const roleViewDue = "roleViewDue";
  static const roleViewStatistics = "roleViewStatistics";
  static const roleViewTimer="roleViewTimer";
  static const roleViewDataBase="roleViewDataBase";
  static const roleViewCard="roleViewCard";
  static const roleViewHome="roleViewHome";
  static const allRolePage=[roleViewBond,roleViewAccount,roleViewInvoice,roleViewProduct,roleViewStore,roleViewPattern,roleViewCheques,roleViewSeller,roleViewReport,roleViewTarget,roleViewInventory,roleViewTask,roleViewImport
  ,roleViewUserManagement,roleViewDue,roleViewStatistics,roleViewTimer,roleViewDataBase,roleViewCard,roleViewHome];
  ////////////--------------------------------------------------
  static const invoiceChoosePriceMethodeCustomerPrice = "invoiceChoosePriceMethodeCustomerPrice";
  static const invoiceChoosePriceMethodeDefault = "invoiceChoosePriceMethodeCustomerPrice";
  static const invoiceChoosePriceMethodeLastPrice = "invoiceChoosePriceMethodeLastPrice";
  static const invoiceChoosePriceMethodeAveragePrice = "invoiceChoosePriceMethodeAveragePrice";
  static const invoiceChoosePriceMethodeHigher = "invoiceChoosePriceMethodeHigher";
  static const invoiceChoosePriceMethodeLower = "invoiceChoosePriceMethodeLower";
  static const invoiceChoosePriceMethodeMinPrice = "invoiceChoosePriceMethodeMinPrice";
  static const invoiceChoosePriceMethodeAverageBuyPrice = "invoiceChoosePriceMethodeAverageBuyPrice";
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
  ////////////----------------------------------------------------
  static const paidStatusFullUsed  = "paidStatusFullUse";
  static const paidStatusNotUsed  = "paidStatusNotUsed";
  static const paidStatusSemiUsed  = "paidStatusSemiUsed";
  ////////////----------------------------------------------------
  static const userStatusOnline  = "userStatusOnline";
  static const userStatusAway  = "userStatusAway";
    ////////////----------------------------------------------------
  static const invPayTypeDue  = "invPayTypeDue";
  static const invPayTypeCash  = "invPayTypeCash";
  /////////////---------------------------------------------------
  static const taskTypeProduct = 'taskTypeProduct';
  static const taskTypeInventory = 'taskTypeInventory';

}


String getInvPayTypeFromEnum(String type) {
  switch (type) {
    case Const.invPayTypeCash:
      return "نقدي";
    case Const.invPayTypeDue:
      return "اجل";
  }

  return "UNKNOWN";
}

String getGlobalTypeFromEnum(String type) {
  
  switch (type) {
    case Const.globalTypeBond:
      return "سند";
    case Const.bondTypeCredit:
      return "سند  قبض";
    case Const.bondTypeDaily:
      return "سند يومية";
    case Const.bondTypeDebit:
      return "سند دفع";
          case Const.bondTypeInvoice:
      return "سند قيد";
          case Const.bondTypeStart:
      return "قيد افتتاحي";
    case Const.chequeTypeCatch:
      return "شيك قبض";
    case Const.chequeTypePay:
      return "شيك دفع";
  }

 return "فاتورة "+getPatModelFromPatternId(type).patName!;
}

String getAccountPaidStatusFromEnum(String type,bool isPositive) {
  switch (type) {
    case Const.paidStatusFullUsed:
      return isPositive?"مقبوض كليا":"مدفوع كليا";
    case Const.paidStatusNotUsed:
      return isPositive?"غير مقبوض":"غير مدفوع";
    case Const.paidStatusSemiUsed:
      return isPositive?"مقبوض جزئيا":"مدفوع جزئيا";
  }
  return type;
}
String getUserStatusFromEnum(String type) {
  switch (type) {
    case Const.userStatusOnline:
      return "موجود";
    case Const.userStatusAway:
      return "في الخارج";
  }
  return type;
}

String getInvTypeFromEnum(String type) {
  switch (type) {
    case Const.invoiceTypeSales:
      return "بيع";
    case Const.invoiceTypeBuy:
      return "شراء";
    case Const.invoiceTypeAdd:
      return "إدخال";
          case Const.invoiceTypeChange:
      return "مناقلة";
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
      return "سند يومية";
    case Const.bondTypeDebit:
      return "سند دفع";
    case Const.bondTypeCredit:
      return "سند قبض";
    case Const.bondTypeStart:
      return "قيد افتتاحي";
    case Const.bondTypeInvoice:
      return "سند قيد";
  }
  print(type);
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
    case Const.roleViewTarget:
      return "التارغت";
    case Const.roleViewTask:
      return "التاسكات";
    case Const.roleViewInventory:
      return "الجرد";
    case Const.roleViewUserManagement:
      return "إدارة المستخدمين";
      case Const.roleViewDue:
      return "الاستحقاق";
            case Const.roleViewStatistics:
      return "التقارير";
    case Const.roleViewTimer:
      return "المؤقت";
     case Const.roleViewDataBase:
      return "ادارة قواعد البيانات";
         case Const.roleViewCard:
      return "ادارة البطاقات";
               case Const.roleViewHome:
      return "الصفحة الرئيسية";
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