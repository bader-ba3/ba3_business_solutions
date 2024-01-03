enum EnvType { debug, release }

//realse :
//      send data to logger
abstract class Const {
  static const EnvType env = EnvType.debug; //"debug" or "release"
  static const vatGCC = 0.05;
  static const vat0_01 = 0.01;
  static const rowCustomBondAmount = 'rowCustomBondAmount';
  static const rowBondId = 'id';
  static const rowBondCreditAmount = 'credit';
  static const rowBondDebitAmount = 'debit';
  static const rowBondAccount = 'secondary';
  static const rowBondDescription = 'description';
  ///////////--------------------------------------------------
  static const bondsCollection = 'Bonds';
  static const recordCollection = 'Record';
  static const accountsCollection = 'Accounts';
  static const invoicesCollection = 'Invoices';
  static const productsCollection = "Products";
  static const logsCollection = "Logs";
  static const patternCollectionRef = "Patterns";
  static const storeCollectionRef = "Stores";
  static const chequesCollection = "Cheques";
  static const costCenterCollection = "CostCenter";
  static const sellersCollection = "Sellers";
  static const usersCollection = "users";
  static const roleCollection = "Role";
  ///////////--------------------------------------------------
  static const rowAccountId = 'rowAccountId';
  static const rowAccountTotal = 'rowAccountTotal';
  static const rowAccountType = 'rowAccountType';
  static const rowAccountBalance = 'rowAccountBalance';
  ///////////--------------------------------------------------
  static const rowInvId = "invId";
  static const rowInvProduct = "invProduct";
  static const rowInvQuantity = "invQuantity";
  static const rowInvSubTotal = "invSubTotal";
  static const rowInvVat = "rowInvVat";
  static const rowInvTotal = "invTotal";
  static const rowInvTotalVat = "rowInvTotalVat";
  ///////////--------------------------------------------------
  static const rowViewAccountId = "rowViewAccountId";
  static const rowViewAccountName = "rowViewAccountName";
  static const rowViewAccountCode = "rowViewAccountCode";
  static const rowViewAccountBalance = "rowViewAccountBalance";
  static const rowViewAccountLength = "rowViewAccountLength";
  ///////////--------------------------------------------------
  static const rowProductType = "rowProductType";
  static const rowProductQuantity = "rowProductQuantity";
  static const rowProductInvId = "rowProductInvId";
  ///////////--------------------------------------------------
  static const bondTypeDaily = "bondTypeDaily";
  static const bondTypeDebit = "bondTypeDebit";
  static const bondTypeCredit = "bondTypeCredit";
  ///////////--------------------------------------------------
  static const patId = "patId";
  static const patCode = "patCode";
  static const patPrimary = "patPrimary";
  static const patName = "patName";
  static const patType = "patType";
  ///////////--------------------------------------------------
  static const stCode = "stCode";
  static const stId = "stId";
  static const stName = "stName";
  ///////////--------------------------------------------------
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
  ///////////--------------------------------------------------\\\\\\\\\\\
  static const accountTypeDefault = "accountTypeDefault";
  static const accountTypeStatistical = "accountTypeStatistical";
  static const accountTypeChequeCatch = "accountTypeChequeCatch";
  static const accountTypeChequePay = "accountTypeChequePay";
  static const accountTypeBank = "accountTypeBank";
  static const accountTypeList = [accountTypeDefault, accountTypeStatistical, accountTypeChequeCatch, accountTypeChequePay, accountTypeBank];
  ///////////--------------------------------------------------
  static const rowSellerAllInvoiceInvId = "rowSellerAllInvoiceInvId";
  static const rowSellerAllInvoiceAmount = "rowSellerAllInvoiceAmount";
  static const rowSellerAllInvoiceDate = "rowSellerAllInvoiceDate";
  ///////////--------------------------------------------------
  static const rowImportName = "rowImportName";
  static const rowImportPrice = "rowImportPrice";
  static const rowImportBarcode = "rowImportBarcode";
  static const rowImportCode = "rowImportCode";
  static const rowImportGroupCode = "rowImportGroupCode";
  static const rowImportHasVat = "rowImportHasVat";
  ///////////--------------------------------------------------
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
  static const roleViewImport = "roleViewImport";
  static const roleViewUserManagement = "roleViewUserManagement";
  static const allRolePage=[roleViewBond,roleViewAccount,roleViewInvoice,roleViewProduct,roleViewStore,roleViewPattern,roleViewCheques,roleViewSeller,roleViewImport,roleViewUserManagement,];
  ///////////--------------------------------------------------
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

String getAccountTypefromEnum(String type) {
  switch (type) {
    case Const.accountTypeDefault:
      return "حساب عادي";
    case Const.accountTypeStatistical:
      return "حساب إحصائي";
    case Const.accountTypeChequeCatch:
      return "حساب شيكات قبض";
    case Const.accountTypeChequePay:
      return "حساب شيكات دفع";
    case Const.accountTypeBank:
      return "حساب مصرف";
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
