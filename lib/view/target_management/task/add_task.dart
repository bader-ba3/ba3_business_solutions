import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/target_view_model.dart';
import 'package:ba3_business_solutions/model/target_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../Const/const.dart';
import '../../../controller/user_management_model.dart';
import '../../invoices/widget/custom_TextField.dart';

class AddTaskView extends StatefulWidget {
  final  String? oldKey;
  const AddTaskView({super.key,  this.oldKey});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TargetViewModel targetViewModel = Get.find<TargetViewModel>();
  late TaskModel targetModel ;
  @override
  void initState() {
    if(widget.oldKey==null){
      targetModel = TaskModel();
    }else{
      targetModel = TaskModel.fromJson(targetViewModel.allTarget[widget.oldKey]!.toJson());
      productNameController.text = getProductNameFromId(targetModel.taskProductId);
      quantityController.text = targetModel.taskQuantity.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: GetBuilder<TargetViewModel>(
        builder: (controller) {
          return Scaffold(
            appBar: AppBar(title: Text(widget.oldKey ==null ?"إضافة التاسك":"تعديل التاسك"),),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Get.width/2.5,
                    child: Row(
                      children: [
                        const Text("المادة :"),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: customTextFieldWithIcon(
                            productNameController,
                                (text) async {
                              var a = await controller.getComplete(text);
                              if(a.isNotEmpty) {
                                targetModel.taskProductId = getProductIdFromName(a);
                                productNameController.text = a;
                                setState(() {});
                              }
                            },
                            onChanged: (_) {
                              // patternController.editPatternModel?.patPrimary = _;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        if(targetModel.taskProductId!=null)
                          Icon(Icons.check),
                      ],
                    ),
                  ),
                  SizedBox(height: 50,),
                  SizedBox(
                    width: Get.width/5,
                    child: Row(
                      children: [
                        const Text("العدد المطلوب :"),
                        const SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child:TextFormField(
                            textAlign: TextAlign.center,
                              decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0), // Adjust border radius
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: Colors.blue, // Change the border color when focused
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                          ),
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly] ,
                              controller: quantityController,
                              onChanged: (_){
                                targetModel.taskQuantity = int.tryParse(quantityController.text);
                              }
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () {
                        print(targetModel.taskProductId);
                        if(targetModel.taskProductId?.isEmpty??true){
                          Get.snackbar("خطأ", "يرجى كتابة اسم المادة");
                        }else if(targetModel.taskQuantity==null ||targetModel.taskQuantity==0){
                          Get.snackbar("خطأ", "يرجى كتابة عدد");
                        }else {
                          if (targetModel.taskId != null) {
                            checkPermissionForOperation(Const.roleUserRead, Const.roleViewTask).then((value) {
                              if (value) controller.updateTask(targetModel);
                            });
                          } else {
                            checkPermissionForOperation(Const.roleUserRead, Const.roleViewTask).then((value) {
                              if (value) controller.addTask(targetModel);
                            });
                          }
                        }
                      },
                      child:  Text(targetModel.taskId!=null ?"تعديل":"إنشاء"))
                ],
              ),
            )
          );
        }
      ),
    );
  }
}
