import 'package:ba3_business_solutions/data/model/account/account_customer.dart';
import 'package:ba3_business_solutions/core/utils/hive.dart';
import 'package:get/get.dart';

class AccountCustomerController extends GetxController {
  Map<String, AccountCustomer> customerMap = {};

  AccountCustomerController() {
    for (var element in HiveDataBase.accountCustomerBox.values) {
      customerMap[element.customerAccountId!] = element;
    }
  }
}
