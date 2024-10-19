import 'package:get/get.dart';

import '../../controller/warranty/warranty_pluto_controller.dart';
import '../../view/Warranty/pages/warranty_view.dart';
import '../../view/user_management/pages/splash_page.dart';
import 'app_routes.dart';

List<GetPage<dynamic>>? appRouter = [
  GetPage(name: AppRoutes.userManagement, page: () => const SplashPage()),
  GetPage(
      name: AppRoutes.warrantyInvoiceView,
      page: () => const WarrantyInvoiceView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => WarrantyPlutoController(),
        ),
      )),
];
