import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:ba3_business_solutions/controller/bond/bond_controller.dart';
import 'package:ba3_business_solutions/controller/bond/entry_bond_controller.dart';
import 'package:ba3_business_solutions/controller/cheque/cheque_controller.dart';
import 'package:ba3_business_solutions/controller/cost/cost_center_controller.dart';
import 'package:ba3_business_solutions/controller/databsae/import_controller.dart';
import 'package:ba3_business_solutions/controller/inventory/inventory_controller.dart';
import 'package:ba3_business_solutions/controller/invoice/invoice_controller.dart';
import 'package:ba3_business_solutions/controller/pattern/pattern_controller.dart';
import 'package:ba3_business_solutions/controller/print/print_controller.dart';
import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_controller.dart';
import 'package:ba3_business_solutions/controller/seller/target_controller.dart';
import 'package:ba3_business_solutions/controller/store/store_controller.dart';
import 'package:ba3_business_solutions/controller/user/cards_controller.dart';
import 'package:get/get.dart';

import '../../controller/account/account_customer_controller.dart';
import '../../controller/databsae/database_controller.dart';
import '../../controller/global/changes_controller.dart';
import '../../controller/invoice/screen_controller.dart';
import '../../controller/invoice/search_controller.dart';
import '../../controller/pluto/pluto_controller.dart';
import '../../controller/user/user_management_controller.dart';
import '../../controller/warranty/warranty_controller.dart';

class GetBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ScreenController());
    // Get.put(GlobalViewModel());
    Get.put(SearchViewController());
    Get.put(EntryBondController());
    Get.put(ImportController());
    Get.put(ProductController());
    Get.put(UserManagementController());
    Get.put(AccountController());
    Get.put(StoreController());
    Get.put(BondController());
    Get.put(PatternController());
    Get.put(SellersController());
    Get.put(InvoiceController());
    Get.put(ChequeController());
    Get.put(CostCenterController());
    Get.put(InventoryController());
    Get.put(AccountCustomerController());

    // Get.put(IsolateViewModel());
    Get.put(DataBaseController());
    Get.put(CardsController());
    Get.put(PrintController());
    Get.put(PlutoController());

    // Lazy controllers with fenix
    Get.lazyPut(() => WarrantyController(), fenix: true);
    Get.lazyPut(() => ChangesController(), fenix: true);
    Get.lazyPut(() => TargetController(), fenix: true);
  }
}
