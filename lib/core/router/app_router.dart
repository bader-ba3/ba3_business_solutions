import 'package:ba3_business_solutions/view/login/pages/login_screen.dart';
import 'package:get/get.dart';

import '../../controller/warranty/warranty_pluto_controller.dart';
import '../../view/Warranty/pages/warranty_view.dart';
import '../../view/login/pages/splash_screen.dart';
import 'app_routes.dart';

List<GetPage<dynamic>>? appRouter = [
  GetPage(name: AppRoutes.userManagement, page: () => const SplashScreen()),
  GetPage(
      name: AppRoutes.warrantyInvoiceView,
      page: () => const WarrantyInvoiceView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => WarrantyPlutoController(),
        ),
      )),
  GetPage(name: AppRoutes.loginScreen, page: () => const LoginScreen()),
];
