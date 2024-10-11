import 'package:get/get.dart';

import '../../controller/warranty/warranty_pluto_view_model.dart';
import '../../view/Warranty/pages/warranty_view.dart';
import '../../view/user_management/pages/account_management_view.dart';
import 'app_routes.dart';

List<GetPage<dynamic>>? appRouter = [
  GetPage(name: AppRoutes.userManagement, page: () => const UserManagement()),
  GetPage(
      name: AppRoutes.warrantyInvoiceView,
      page: () => const WarrantyInvoiceView(),
      binding: BindingsBuilder(
        () => Get.lazyPut(
          () => WarrantyPlutoViewModel(),
        ),
      )),
];
