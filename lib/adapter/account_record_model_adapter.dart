import 'package:ba3_business_solutions/model/account_record_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:hive/hive.dart';

import '../model/account_model.dart';


class AccountRecordAdapter extends TypeAdapter<AccountRecordModel>{
  @override
  AccountRecordModel read(BinaryReader reader) {
    return AccountRecordModel.fromJson(reader.read());
  }

  @override
  int get typeId => 4;

  @override
  void write(BinaryWriter writer, AccountRecordModel obj) {
   writer.write(obj.toJson());
  }
}