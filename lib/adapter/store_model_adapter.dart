import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:hive/hive.dart';

import '../model/account_model.dart';


class StoreModelAdapter extends TypeAdapter<StoreModel>{
  @override
  StoreModel read(BinaryReader reader) {
    return StoreModel.fromJson(reader.read());
  }

  @override
  int get typeId => 3;

  @override
  void write(BinaryWriter writer, StoreModel obj) {
   writer.write(obj.toFullJson());
  }
}