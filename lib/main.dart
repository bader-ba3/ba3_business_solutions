import 'package:ba3_business_solutions/core/bindings.dart';
import 'package:ba3_business_solutions/view/timer/timer_view.dart';
import 'package:ba3_business_solutions/view/widget/filtering_data_grid.dart';
import 'package:ba3_business_solutions/utils/hive.dart';
import 'package:ba3_business_solutions/view/home/home_view.dart';
import 'package:ba3_business_solutions/view/user_management/account_management_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
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
    // DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    // DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
       return GetMaterialApp(
         initialBinding: GetBinding(),
          debugShowCheckedModeBanner: false,
          title: "Ba3 Business",
          theme: ThemeData(
            appBarTheme:  AppBarTheme(
                // backgroundColor:Colors.grey.shade200! ,
                backgroundColor:Color.fromARGB(255, 255, 247, 222) ,
                foregroundColor:Colors.black ,
                // surfaceTintColor: Colors.grey.shade200! ,
                surfaceTintColor: Color.fromARGB(255, 255, 247, 221) ,
                // color: Color.fromARGB(255, 255, 248, 228),
            elevation: 0
            ),
              elevatedButtonTheme:ElevatedButtonThemeData(
                style:  ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.lightBlue.shade100),
                  elevation: MaterialStatePropertyAll(0),)
              ),
            colorScheme: ColorScheme.fromSeed(
              primary: Colors.black,
                seedColor: Colors.black,
                // background: Colors.grey.shade200!
                background: Color.fromARGB(255, 255, 247, 221)
            ),
            useMaterial3: true,
          ),
          home: UserManagement(),
         // home:Test()
    );
  }
}
