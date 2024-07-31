import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/model/seller_model.dart';
import 'package:ba3_business_solutions/utils/confirm_delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../controller/user_management_model.dart';

class AddSeller extends StatefulWidget {
  const AddSeller({super.key, this.oldKey});
  final String? oldKey;
  @override
  State<AddSeller> createState() => _AddSellerState();
}

class _AddSellerState extends State<AddSeller> {
  var sellerController = Get.find<SellersViewModel>();
  var nameController = TextEditingController();
  var codeController = TextEditingController();
  late SellerModel model;
  @override
  void initState() {
    super.initState();
    if (widget.oldKey == null) {
      model = SellerModel();
      int code = sellerController.allSellers.isEmpty?0:int.parse(sellerController.allSellers.values.last.sellerCode??"0")+1;
      codeController.text = code.toString();
      model.sellerCode = code.toString();
    } else {
      model = sellerController.allSellers[widget.oldKey]!;
      nameController.text = model.sellerName ?? "error";
      codeController.text = model.sellerCode ?? "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<SellersViewModel>(builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: Text(model.sellerId ?? "جديد"),
          ),
          body: Container(
            width: double.infinity,
            child: Column(
              children: [
                Text("الاسم"),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: nameController,
                    onChanged: (_) {
                      model.sellerName = _;
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Text("الرمز"),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    controller: codeController,
                    onChanged: (_) {
                      model.sellerCode = _;
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: () {
                      if(nameController.text.isNotEmpty &&codeController.text.isNotEmpty){
                        if (model.sellerId == null) {
                          checkPermissionForOperation(Const.roleUserWrite, Const.roleViewSeller).then((value) {
                            if (value) sellerController.addSeller(model);
                          });
                        } else {
                          checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewSeller).then((value) {
                            if (value) sellerController.addSeller(model);
                          });
                        }
                      }
                    },
                    child: Text(model.sellerId == null ? "إنشاء" : "تعديل")),
                SizedBox(height: 50,),
                if (model.sellerId != null&&(model.sellerRecord??[]).isEmpty)
                  ElevatedButton(
                      onPressed: () {
                        confirmDeleteWidget().then((value) {
                          if(value) {
                        checkPermissionForOperation(Const.roleUserDelete,Const.roleViewSeller).then((value) {
                          if(value) {
                            sellerController.deleteSeller(model);
                            Get.back();
                            Get.back();
                          }
                        });
                      }
                      });

                      },
                      child: Text("حذف")),
              ],
            ),
          ),
        );
      }),
    );
  }
}
