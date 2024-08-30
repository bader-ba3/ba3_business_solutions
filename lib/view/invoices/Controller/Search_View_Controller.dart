import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SearchViewController extends GetxController{


TextEditingController productForSearchController=TextEditingController();
TextEditingController startDateForSearchController=TextEditingController()..text=DateTime.now().toString().split(" ")[0];
TextEditingController endDateForSearchController=TextEditingController()..text=DateTime.now().toString().split(" ")[0];
TextEditingController groupForSearchController=TextEditingController();
TextEditingController accountForSearchController=TextEditingController();
TextEditingController storeForSearchController=TextEditingController();


initController(){
   productForSearchController.clear();
   startDateForSearchController.text=DateTime.now().toString().split(" ")[0];
   endDateForSearchController.text=DateTime.now().toString().split(" ")[0];
   groupForSearchController.clear();
   accountForSearchController.clear();
   storeForSearchController.clear();
}

}