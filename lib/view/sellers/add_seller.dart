import 'package:ba3_business_solutions/controller/account_view_model.dart';
import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/model/seller_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../controller/user_management.dart';

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
    // TODO: implement initState
    super.initState();
    if (widget.oldKey == null) {
      model = SellerModel();
    } else {
      model = sellerController.allSellers[widget.oldKey]!;
      nameController.text = model.sellerName ?? "error";
      codeController.text = model.sellerCode ?? "error";
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SellersViewModel>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          title: Text(model.sellerId ?? "new"),
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            children: [
              Text("name"),
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
              Text("code"),
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
                    if(model.sellerId == null) {
                      checkPermissionForOperation(Const.roleUserWrite,Const.roleViewSeller).then((value) {
                        if (value) sellerController.addseller(model);
                      });
                    }else{
                      checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewSeller).then((value) {
                        if (value) sellerController.addseller(model);
                      });
                    }
                  },
                  child: Text(model.sellerId == null ? "new" : "edit")),
              SizedBox(height: 50,),
              if (model.sellerId != null&&(model.sellerRecord??[]).isEmpty)
                ElevatedButton(
                    onPressed: () {
                      checkPermissionForOperation(Const.roleUserDelete,Const.roleViewSeller).then((value) {
                        if(value)sellerController.deleteseller(model);
                      });


                    },
                    child: Text("delete")),
            ],
          ),
        ),
      );
    });
  }
}
