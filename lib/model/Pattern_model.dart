class PatternModel {
  String? patName, patCode, patType, patPrimary, patId, patVatAccount, patSecondary,patStore;
  bool? patHasVat;
  PatternModel({
    this.patName,
    this.patCode,
    this.patType,
    this.patPrimary,
    this.patId,
    this.patHasVat,
    this.patVatAccount,
    this.patSecondary,
    this.patStore,
  });

  PatternModel.fromJson(Map<String, dynamic> json) {
    patName = json['patName'];
    patCode = json['patCode'];
    patType = json['patType'];
    patPrimary = json['patPrimary'];
    patHasVat = json['patHasVat'];
    patVatAccount = json['patVatAccount'];
    patSecondary = json['patSecondary'];
    patStore = json['patStore'];
    patId = json['patId'];
  }

  toJson() {
    return {
      'patName': patName,
      'patCode': patCode,
      'patType': patType,
      'patPrimary': patPrimary,
      'patId': patId,
      'patVatAccount': patVatAccount,
      'patHasVat': patHasVat,
      'patSecondary': patSecondary,
      'patStore': patStore,
    };
  }
}
