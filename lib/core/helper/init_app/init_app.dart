import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../constants/app_strings.dart';
import '../../../firebase_options.dart';
import '../../utils/hive.dart';

Future initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

// WindowOptions windowOptions = const WindowOptions(
  //   size: Size(800, 600),
  //   center: true,
  //   backgroundColor: Colors.transparent,
  //   titleBarStyle: TitleBarStyle.hidden,
  // );
  // windowManager.waitUntilReadyToShow(windowOptions, () async {
  //   await windowManager.show();
  //   await windowManager.focus();
  // });

  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(800, 600);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "BA3 Business Solution";
    appWindow.maximizeOrRestore();
    win.show();
  });

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await HiveDataBase.init();
  await init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);
  HardwareKeyboard.instance.addHandler(
    (event) {
      if (HardwareKeyboard.instance.isControlPressed &&
          HardwareKeyboard.instance.isShiftPressed &&
          HardwareKeyboard.instance
              .isPhysicalKeyPressed(PhysicalKeyboardKey.keyC)) {
        HiveDataBase.setIsFree(!HiveDataBase.getWithFree());

        return true;
      }
      return false;
    },
  );
  // FirebaseFirestore.instance.collection("2024").doc("bon1720282515909594").delete();
  //  HiveDataBase.globalModelBox.delete("bon1720282515909594");
  // FirebaseFirestore.instance.collection("2024").count().get().then((value) => print(value.count),);
  // HiveDataBase.globalModelBox.deleteFromDisk();
}

init({String? oldData, bool? isFree}) async {
  if (AppStrings.dataName == '') {
    // await FirebaseFirestore.instance.collection(settingCollection).doc(dataCollection).get().then((value) {
    //   dataName=value.data()?['defaultDataName'];
    // });
    AppStrings.dataName = "2024";
  } else {
    AppStrings.dataName = oldData!;
  }
  await HiveDataBase.setDataName(AppStrings.dataName);
  AppStrings.globalCollection = AppStrings.dataName;
  if (isFree != null) {
    AppStrings.isFreeType = isFree;
  } else {
    AppStrings.isFreeType = HiveDataBase.isFree.get("isFreeType") ?? false;
  }
}
