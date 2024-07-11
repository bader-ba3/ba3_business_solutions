import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/controller/target_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/view/target_management/task/add_task.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/target_model.dart';

class AllTaskView extends StatefulWidget {
  const AllTaskView({super.key});

  @override
  State<AllTaskView> createState() => _AllTaskViewState();
}

class _AllTaskViewState extends State<AllTaskView> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text("عرض المهام"),),
        body: GetBuilder<TargetViewModel>(
          builder: (controller){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: controller.allTarget.length,
                itemBuilder: (context, index) {
                MapEntry<String, TaskModel> model =  controller.allTarget.entries.toList()[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){
                      Get.to(()=>AddTaskView(oldKey: model.key,));
                    },
                    child: Row(
                      children: [
                        Text("يجب بيع ",style: TextStyle(fontSize: 20),),
                        SizedBox(width: 5,),
                        Text(getProductNameFromId(model.value.taskProductId.toString()),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        SizedBox(width: 5,),
                        Text("بعدد",style: TextStyle(fontSize: 20),),
                        SizedBox(width: 5,),
                        Text(model.value.taskQuantity.toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        SizedBox(width: 20,),
                        ElevatedButton(onPressed: (){
                          Get.defaultDialog(
                            title: "قائمة المشاركين",
                            content:  Container(
                              height: Get.width/4,
                              width: Get.width/4,
                              child: ListView.builder(
                                itemCount: model.value.taskUserListId!.length,
                                itemBuilder: (context, index) {
                                String user = model.value.taskUserListId![index];
                                return Text(getUserModelById(user).userName.toString());
                              },),
                            )
                          );
                        }, child: Text("قائمة المشاركين"))
                      ],
                    ),
                  ),
                );
              },),
            );
          },
        ),
      ),
    );
  }
}
