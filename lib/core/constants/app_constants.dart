import 'package:ba3_business_solutions/controller/account/account_controller.dart';

import '../helper/enums/enums.dart';

abstract class AppConstants {
  static String dataName = '';
  static bool isFreeType = false;

  static const EnvType env = EnvType.debug; //"debug" or "release"
  static const vatGCC = 0.05;
  static const constHeightTextField = 35.0;
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
  static String changesCollection = "$dataName-Changes";
  static const recordCollection = 'Record';
  static String bondsCollection = 'Bonds';
  static String accountsCollection = 'Accounts';
  static String tasksCollection = 'Tasks';
  static String invoicesCollection = 'Invoices';
  static String warrantyCollection = 'Warranty';
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
  static String globalCollection = dataName;
  static String ba3Invoice = "ba3Invoice";
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
  static const bondTypeDaily = /*"سند يومية";*/ "bondTypeDaily";
  static const bondTypeDebit = /*"سند قبض";*/ "bondTypeDebit";
  static const bondTypeCredit = /*"سند دفع";*/ "bondTypeCredit";
  static const bondTypeStart = /*"قيد افتتاحي";*/ "bondTypeStart";
  static const bondTypeInvoice = /*"سند قيد";*/ "bondTypeInvoice";

  ////////////--------------------------------------------------
  static const patId = "patId";
  static const patCode = "patCode";
  static const patPrimary = "patPrimary";
  static const patName = "patName";
  static const patType = "patType";

  ////////////--------------------------------------------------
  static const invoiceTypeSales = "invoiceTypeSales";
  static const invoiceTypeSalesWithPartner = "invoiceTypeSalesWithPartner";
  static const invoiceTypeBuy = 'invoiceTypeBuy';
  static const invoiceTypeAdd = "invoiceTypeAdd";
  static const invoiceTypeChange = "invoiceTypeChange";
  static const tabbySales = "م Tabby";
  static const stripSales = "م Strip";
  static const cardSales = "م Card";

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
  static const roleViewTimer = "roleViewTimer";
  static const roleViewDataBase = "roleViewDataBase";
  static const roleViewCard = "roleViewCard";
  static const roleViewHome = "roleViewHome";

  ////////////--------------------------------------------------
  static const invoiceChoosePriceMethodeCustomerPrice =
      "invoiceChoosePriceMethodeCustomerPrice";
  static const invoiceChoosePriceMethodeDefault =
      "invoiceChoosePriceMethodeCustomerPrice";
  static const invoiceChoosePriceMethodeLastPrice =
      "invoiceChoosePriceMethodeLastPrice";
  static const invoiceChoosePriceMethodeAveragePrice =
      "invoiceChoosePriceMethodeAveragePrice";
  static const invoiceChoosePriceMethodeHigher =
      "invoiceChoosePriceMethodeHigher";
  static const invoiceChoosePriceMethodeLower =
      "invoiceChoosePriceMethodeLower";
  static const invoiceChoosePriceMethodeMinPrice =
      "invoiceChoosePriceMethodeMinPrice";
  static const invoiceChoosePriceMethodeAverageBuyPrice =
      "invoiceChoosePriceMethodeAverageBuyPrice";
  static const invoiceChoosePriceMethodeWholePrice =
      "invoiceChoosePriceMethodeWholePrice";
  static const invoiceChoosePriceMethodeRetailPrice =
      "invoiceChoosePriceMethodeRetailPrice";
  static const invoiceChoosePriceMethodeCostPrice =
      "invoiceChoosePriceMethodeCostPrice";
  static const invoiceChoosePriceMethodeCustom =
      "invoiceChoosePriceMethodeCustom";

  ////////////--------------------------------------------------
  static const rowAccountAggregateName = "rowAccountAggregateName";

  ////////////---------------------------------------------------
  static const globalTypeInvoice = "globalTypeInvoice";
  static const globalTypeBond = "globalTypeBond";
  static const globalTypeCheque = "globalTypeCheque";
  static const globalTypeAccountDue = "globalAccountDue";
  static const globalTypeStartersBond = "globalTypeStartersBond";

  ////////////---------------------------------------------------
  static const invoiceRecordCollection = "invoiceRecord";
  static const bondRecordCollection = "bondRecord";
  static const chequeRecordCollection = "chequeRecord";

  ////////////----------------------------------------------------
  static const productsAllSubscription = "productsAllSubscription";

  ////////////----------------------------------------------------
  static const paidStatusFullUsed = "paidStatusFullUse";
  static const paidStatusNotUsed = "paidStatusNotUsed";
  static const paidStatusSemiUsed = "paidStatusSemiUsed";

  ////////////----------------------------------------------------
  static const userStatusOnline = "userStatusOnline";
  static const userStatusAway = "userStatusAway";

  ////////////----------------------------------------------------
  static const invPayTypeDue = "invPayTypeDue";
  static const invPayTypeCash = "invPayTypeCash";

  /////////////---------------------------------------------------
  static const taskTypeProduct = 'taskTypeProduct';
  static const taskTypeInventory = 'taskTypeInventory';

  static const typeAccountView = "typeAccountView";
  static const typeAccountDueView = "typeAccountDueView";

  static const salleTypeId = "pat1706468132863249";

  /////////////---------------------------------------------------
  static const mainVATCategory = "SR-التصنيف الأساسي";
  static const withoutVAT = "EX-معفى";
  static String vatAccountId =
      getAccountIdFromText("ضريبة القيمة المضافة رأس الخيمة");
  static String returnVatAccountId =
      getAccountIdFromText("استرداد ضريبة القيمة المضافة رأس الخيمة");

  /////////////---------------------------------------------------
  static const firstTimeEnter = "FirstTimeEnter";
  static const secondTimeEnter = "secondTimeEnter";
  static const firstTimeOut = "secondTimeEnter";
  static const secondTimeOut = "secondTimeEnter";
  static const breakTime = "secondTimeEnter";


  static const allRolePage = [
    AppConstants.roleViewBond,
    AppConstants.roleViewAccount,
    AppConstants.roleViewInvoice,
    AppConstants.roleViewProduct,
    AppConstants.roleViewStore,
    AppConstants.roleViewPattern,
    AppConstants.roleViewCheques,
    AppConstants.roleViewSeller,
    AppConstants.roleViewReport,
    AppConstants.roleViewTarget,
    AppConstants.roleViewInventory,
    AppConstants.roleViewTask,
    AppConstants.roleViewImport,
    AppConstants.roleViewUserManagement,
    AppConstants.roleViewDue,
    AppConstants.roleViewStatistics,
    AppConstants.roleViewTimer,
    AppConstants.roleViewDataBase,
    AppConstants.roleViewCard,
    AppConstants.roleViewHome
  ];
  static const accountTypeList = [
    AppConstants.accountTypeDefault,
    AppConstants.accountTypeFinalAccount,
    AppConstants.accountTypeAggregateAccount
  ];

  static const userName = "ali";

  static const prodViewTypeSearch="prodViewTypeSearch";
}
