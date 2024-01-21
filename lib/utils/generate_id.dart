enum RecordType { bond, invoice, product, account, pattern, undefined, store, cheque, costCenter, sellers, user,role }

String generateId(RecordType type) {
  var _ = DateTime.now().microsecondsSinceEpoch.toString();
  switch (type) {
    case RecordType.bond:
      return "bon$_";
    case RecordType.invoice:
      return "inv$_";
    case RecordType.product:
      return "prod$_";
    case RecordType.account:
      return "acc$_";
    case RecordType.pattern:
      return "pat$_";
    case RecordType.store:
      return "store$_";
    case RecordType.cheque:
      return "cheq$_";
    case RecordType.costCenter:
      return "CoCe$_";
    case RecordType.sellers:
      return "seller$_";
    case RecordType.user:
      return "user$_";
    case RecordType.role:
      return "role$_";
    case RecordType.undefined:
      return _;
  }
}
