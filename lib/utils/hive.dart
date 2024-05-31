import 'package:ba3_business_solutions/adapter/account_record_model_adapter.dart';
import 'package:ba3_business_solutions/adapter/global_model_adapter.dart';
import 'package:ba3_business_solutions/adapter/product_model_adapter.dart';
import 'package:ba3_business_solutions/adapter/product_record_model_adapter.dart';
import 'package:ba3_business_solutions/adapter/store_model_adapter.dart';
import 'package:ba3_business_solutions/model/account_model.dart';
import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../adapter/account_model_adapter.dart';
import '../model/store_model.dart';

class HiveDataBase {
  static late Box<GlobalModel> globalModelBox;
  static late Box<ProductModel> productModelBox;
  static late Box<AccountModel> accountModelBox;
  static late Box<StoreModel> storeModelBox;
  static late Box<int> lastChangesIndexBox;
  static late Box<String> constBox;
  // static late Box<int> timerTimeBox;
  static late Box<String> timerDateBox;
  static late Box<bool> isNewUser;
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GlobalModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(AccountModelAdapter());
    Hive.registerAdapter(StoreModelAdapter());
    Hive.registerAdapter(AccountRecordAdapter());
    Hive.registerAdapter(ProductRecordModelAdapter());
    productModelBox=await Hive.openBox<ProductModel>("AllProduct");
    accountModelBox=await Hive.openBox<AccountModel>("AllAccount");
    storeModelBox=await Hive.openBox<StoreModel>("AllStore");
    lastChangesIndexBox=await Hive.openBox<int>("lastChangesIndex");
    // globalModelBox=await Hive.openBox<GlobalModel>();
    constBox=await Hive.openBox<String>("Const");
    // timerTimeBox=await Hive.openBox<int>("TimerTime");
    timerDateBox=await Hive.openBox<String>("TimerDate");
    isNewUser=await Hive.openBox<bool>("IsNewUser");
    if(constBox.get("myReadFlag")==null){
      constBox.put("myReadFlag", "readFlag"+DateTime.now().microsecondsSinceEpoch.toString());
    }
    if(lastChangesIndexBox.get("lastChangesIndex")==null){
      lastChangesIndexBox.put("lastChangesIndex", 0);
    }
  }

  static String getMyReadFlag(){
    return constBox.get("myReadFlag")!;
  }

  static Future<void> setDataName(dataName) async {
    globalModelBox=await Hive.openBox<GlobalModel>(dataName);
  }

}