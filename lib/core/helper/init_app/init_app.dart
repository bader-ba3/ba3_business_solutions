import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../firebase_options.dart';
import '../../constants/app_constants.dart';
import '../../utils/hive.dart';

Future initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

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
          HardwareKeyboard.instance.isPhysicalKeyPressed(PhysicalKeyboardKey.keyC)) {
        HiveDataBase.setIsFree(!HiveDataBase.getWithFree());
        return true;
      }
      return false;
    },
  );
}

init({String? oldData, bool? isFree}) async {
  if (AppConstants.dataName == '') {
    // Set current year dynamically
    AppConstants.dataName = DateTime.now().year.toString();
  } else {
    AppConstants.dataName = oldData!;
  }
  await HiveDataBase.setDataName(AppConstants.dataName);
  AppConstants.globalCollection = AppConstants.dataName;
  if (isFree != null) {
    AppConstants.isFreeType = isFree;
  } else {
    AppConstants.isFreeType = HiveDataBase.isFree.get("isFreeType") ?? false;
  }
}
