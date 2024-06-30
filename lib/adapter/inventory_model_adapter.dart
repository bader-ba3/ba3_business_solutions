import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:hive/hive.dart';

import '../model/account_model.dart';
import '../model/inventory_model.dart';


class InventoryModelAdapter extends TypeAdapter<InventoryModel>{
  @override
  InventoryModel read(BinaryReader reader) {
    return InventoryModel.fromJson(reader.read());
  }

  @override
  int get typeId => 7;

  @override
  void write(BinaryWriter writer, InventoryModel obj) {
   writer.write(obj.toJson());
  }
}