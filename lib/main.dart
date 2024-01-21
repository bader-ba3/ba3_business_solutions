import 'package:ba3_business_solutions/core/bindings.dart';
import 'package:ba3_business_solutions/view/user_management/account_management_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'Const/const.dart';
import 'controller/invoice_view_model.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Const.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
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
        appBarTheme: const AppBarTheme(
            backgroundColor:Color.fromARGB(255, 255, 247, 222) ,
            foregroundColor:Colors.black ,
            surfaceTintColor: Color.fromARGB(255, 255, 247, 221) ,
            // color: Color.fromARGB(255, 255, 248, 228),
        elevation: 0
        ),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            background: Color.fromARGB(255, 255, 247, 221)
        ),
        useMaterial3: true,
      ),
      home: UserManagement(),
    );
  }
}
