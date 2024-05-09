class ChequeRecModel {
  String? cheqRecBondId, cheqRecType, cheqRecAmount, cheqRecId, cheqRecSecoundryAccount, cheqRecPrimeryAccount, cheqRecChequeType;

  ChequeRecModel({this.cheqRecAmount, this.cheqRecBondId, this.cheqRecChequeType, this.cheqRecId, this.cheqRecPrimeryAccount, this.cheqRecSecoundryAccount, this.cheqRecType});

  ChequeRecModel.fromJson(Map<dynamic, dynamic> map) {
    cheqRecType = map['cheqRecType'];
    cheqRecBondId = map['cheqRecBondId'];
    cheqRecAmount = map['cheqRecAmount'];
    cheqRecId = map['cheqRecId'];
    cheqRecSecoundryAccount = map['cheqRecSecoundryAccount'];
    cheqRecPrimeryAccount = map['cheqRecPrimeryAccount'];
    cheqRecChequeType = map['cheqRecChequeType'];
  }
  toJson() {
    return {
      'cheqRecType': cheqRecType,
      'cheqRecAmount': cheqRecAmount,
      'cheqRecBondId': cheqRecBondId,
      'cheqRecId': cheqRecId,
      'cheqRecSecoundryAccount': cheqRecSecoundryAccount,
      'cheqRecPrimeryAccount': cheqRecPrimeryAccount,
      'cheqRecChequeType': cheqRecChequeType,
    };
  }
}
