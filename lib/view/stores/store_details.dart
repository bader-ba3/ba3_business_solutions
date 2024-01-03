import 'package:ba3_business_solutions/controller/store_view_model.dart';
import 'package:ba3_business_solutions/model/store_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../Const/const.dart';
import '../../controller/user_management.dart';
import '../accounts/acconts_view.dart';
import '../invoices/widget/custom_TextField.dart';

class StoreDetails extends StatefulWidget {
  final String? oldKey;
  StoreDetails({super.key, this.oldKey});

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
}

class _StoreDetailsState extends State<StoreDetails> {
  var nameController = TextEditingController();
  var codeController = TextEditingController();
  StoreViewModel storeController = Get.find<StoreViewModel>();

  @override
  void initState() {
    if (widget.oldKey == null) {
      storeController.editStoreModel = StoreModel();
    } else {
      storeController.editStoreModel = StoreModel.fromJson(storeController.storeMap[widget.oldKey]?.toJson());
      nameController.text = storeController.editStoreModel?.stName ?? "";
      codeController.text = storeController.editStoreModel?.stCode ?? "";
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stores Control"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GetBuilder<StoreViewModel>(builder: (storeController) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 75,
              ),
              Container(
                width: Get.width * 0.5,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [const Flexible(flex: 2, child: Text("Store NO :")), Text(storeController.editStoreModel?.stId ?? "new Store")],
                ),
              ),
              SizedBox(
                height: 75,
              ),
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(flex: 2, child: Text("Store Name :")),
                        Flexible(
                            flex: 3,
                            child: customTextFieldWithoutIcon(nameController, true, onChanged: (_) {
                              storeController.editStoreModel?.stName = _;
                            })),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Flexible(flex: 2, child: Text("Store code :")),
                        Flexible(
                            flex: 3,
                            child: customTextFieldWithoutIcon(codeController, true, onChanged: (_) {
                              storeController.editStoreModel?.stCode = _;
                            })),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () {
                        nameController.clear();
                        codeController.clear();
                        storeController.clearController();
                      },
                      child: const Text("Clear")),
                  if (storeController.editStoreModel?.stId != null)
                    ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewStore).then((value) {
                            if(value){
                              storeController.editStore();
                            }
                          });


                        },
                        child: const Text("Edit"))
                  else
                    ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          checkPermissionForOperation(Const.roleUserWrite,Const.roleViewStore).then((value) {
                            if(value)storeController.addNewStore();
                          });


                          // storeController.clearController();
                          // storeController.getNewCode();
                        },
                        child: const Text("New")),
                  if (storeController.editStoreModel?.stId != null)
                    ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () {
                          checkPermissionForOperation(Const.roleUserDelete,Const.roleViewStore).then((value) {
                            if(value){
                              storeController.deleteStore();
                              Get.back();
                            }
                          });


                        },
                        child: const Text("Delete")),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          );
        }),
      ),
    );
  }
}
