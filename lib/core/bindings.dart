import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/bond_view_model.dart';
import 'package:ba3_business_solutions/controller/cards_view_model.dart';
import 'package:ba3_business_solutions/controller/cheque_view_model.dart';
import 'package:ba3_business_solutions/controller/cost_center_view_model.dart';
import 'package:ba3_business_solutions/controller/faceController/ml_service.dart';
import 'package:ba3_business_solutions/controller/global_view_model.dart';
import 'package:ba3_business_solutions/controller/import_view_model.dart';
import 'package:ba3_business_solutions/controller/inventory_view_model.dart';
import 'package:ba3_business_solutions/controller/invoice_view_model.dart';
import 'package:ba3_business_solutions/controller/isolate_view_model.dart';
import 'package:ba3_business_solutions/controller/pattern_model_view.dart';
import 'package:ba3_business_solutions/controller/print_view_model.dart';
import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/controller/target_view_model.dart';
import 'package:get/get.dart';
import '../controller/changes_view_model.dart';
import '../controller/database_view_model.dart';
import '../controller/faceController/camera.service.dart';
import '../controller/faceController/face_detector_service.dart';
import '../controller/user_management_model.dart';

class GetBinding extends Bindings {
  @override
  void dependencies() {

    Get.put(ImportViewModel());
    Get.put(ProductViewModel());
    Get.put(UserManagementViewModel());
    Get.put(AccountViewModel());
    Get.put(StoreViewModel());
    Get.put(BondViewModel());
    Get.put(PatternViewModel());
    Get.put(SellersViewModel());
    Get.put(InvoiceViewModel());
    Get.put(ChequeViewModel());
    Get.put(CostCenterViewModel());
    Get.put(InventoryViewModel());
    // Get.put(CameraService());
    // Get.put(FaceDetectorService());
    // Get.put(MLService());
    Get.put(IsolateViewModel());
    Get.put(DataBaseViewModel());
    Get.put(CardsViewModel());
    Get.put(TargetViewModel());
    Get.put(PrintViewModel());
    // Get.lazyPut(()=>GlobalViewModel(),fenix: true);
    Get.lazyPut(()=>ChangesViewModel(),fenix: true);
  }
}
