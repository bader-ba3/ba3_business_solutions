import 'dart:ui';

import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/core/bindings.dart';

import 'package:ba3_business_solutions/utils/hive.dart';

import 'package:ba3_business_solutions/view/user_management/account_management_view.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'Const/const.dart';
import 'firebase_options.dart';



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
   runApp(const MyApp());
 
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
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            surfaceTintColor: Colors.white,
            elevation: 0),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.lightBlue.shade100),
          elevation: const WidgetStatePropertyAll(0),
        )),
        colorScheme: ColorScheme.fromSeed(
            primary: Colors.black,
            seedColor: Colors.black,
            background: Colors.white),
        useMaterial3: true,
      ),
      home: const UserManagement(),
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
