import 'dart:ui';

import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/core/bindings.dart';
import 'package:ba3_business_solutions/view/timer/timer_view.dart';
import 'package:ba3_business_solutions/view/widget/filtering_data_grid.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/view/home/home_view.dart';
import 'package:ba3_business_solutions/view/user_management/account_management_view.dart';
import 'package:ba3_business_solutions/view/inventory/new_inventory_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:translator/translator.dart';
import 'Const/const.dart';
import 'firebase_options.dart';
import 'view/sellers/seller_targets.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveDataBase.init();
  await Const.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);
  HardwareKeyboard.instance.addHandler(
    (event) {
      if (HardwareKeyboard.instance.isControlPressed &&
          HardwareKeyboard.instance.isShiftPressed &&
          HardwareKeyboard.instance
              .isPhysicalKeyPressed(PhysicalKeyboardKey.keyD)) {
        GlobalViewModel? globalViewModel = Get.find<GlobalViewModel>();
        if (globalViewModel.initialized) {
          globalViewModel.changeFreeType(true);
        }
        return true;
      } else if (HardwareKeyboard.instance.isControlPressed &&
          HardwareKeyboard.instance.isShiftPressed &&
          HardwareKeyboard.instance
              .isPhysicalKeyPressed(PhysicalKeyboardKey.keyC)) {
        GlobalViewModel? globalViewModel = Get.find<GlobalViewModel>();
        if (globalViewModel.initialized) {
          globalViewModel.changeFreeType(false);
        }
        return true;
      }
      return false;
    },
  );
 

  // FirebaseFirestore.instance.collection("2024").doc("bon1720282515909594").delete();
  //  HiveDataBase.globalModelBox.delete("bon1720282515909594");
  // FirebaseFirestore.instance.collection("2024").count().get().then((value) => print(value.count),);
  // HiveDataBase.globalModelBox.deleteFromDisk();
   runApp(MyApp());
 
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: GetBinding(),
      debugShowCheckedModeBanner: false,
      scrollBehavior: AppScrollBehavior(),
      title: "Ba3 Business",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            // backgroundColor:Colors.grey.shade200! ,
            //  backgroundColor:Color.fromARGB(255, 255, 247, 222) ,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            // surfaceTintColor: Colors.grey.shade200! ,
            //   surfaceTintColor: Color.fromARGB(255, 255, 247, 221) ,
            surfaceTintColor: Colors.white,
            // color: Color.fromARGB(255, 255, 248, 228),
            elevation: 0),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.lightBlue.shade100),
          elevation: const WidgetStatePropertyAll(0),
        )),
        colorScheme: ColorScheme.fromSeed(
            primary: Colors.black,
            seedColor: Colors.black,
            // background: Colors.grey.shade200!
            // background: Color.fromARGB(255, 255, 247, 221)
            background: Colors.white),
        useMaterial3: true,
      ),
      home: UserManagement(),
    );
  }
}
class AppScrollBehavior extends MaterialScrollBehavior{
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad
  };
}
