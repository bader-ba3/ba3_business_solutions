import 'package:ba3_business_solutions/adapter/global_model_adapter.dart';
import 'package:ba3_business_solutions/old_model/global_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDataBase {
  static late Box<GlobalModel> globalModelBox;
  static late Box<String> constBox;
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(GlobalModelAdapter());
    // globalModelBox=await Hive.openBox<GlobalModel>();
    constBox=await Hive.openBox<String>("Const");
    if(constBox.get("myReadFlag")==null){
      constBox.put("myReadFlag", "readFlag"+DateTime.now().microsecondsSinceEpoch.toString());
    }
  }
  static String getMyReadFlag(){
    return constBox.get("myReadFlag")!;
  }
  static Future<void> setDataName(dataName) async {
    globalModelBox=await Hive.openBox<GlobalModel>(dataName);
  }
}