import 'package:ba3_business_solutions/controller/sellers_view_model.dart';
import 'package:ba3_business_solutions/controller/target_view_model.dart';
import 'package:ba3_business_solutions/controller/user_management_model.dart';
import 'package:ba3_business_solutions/model/seller_model.dart';
import 'package:ba3_business_solutions/model/user_model.dart';
import 'package:ba3_business_solutions/view/sellers/seller_targets.dart';
import 'package:ba3_business_solutions/view/timer/timer_view.dart';
import 'package:ba3_business_solutions/view/user_management/user_crud/add_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../Const/const.dart';
import '../../../model/task_model.dart';

class AllTimeView extends StatelessWidget {
  const AllTimeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("معاينة التارغتات"),
        ),
        body: GetBuilder<UserManagementViewModel>(builder: (controller) {
          return controller.allUserList.isEmpty
              ? const Center(
            child: Text("لا يوجد مستخدمين بعد"),
          )
              : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: controller.allUserList.values.length,
              itemBuilder: (context, index) {
                late StopWatchTimer _stopWatchTimer;
                UserModel userModel = controller.allUserList.values.toList()[index];
                _stopWatchTimer = StopWatchTimer(
                  mode: StopWatchMode.countUp,
                );
                int totalSec = 0;
                bool isClosed =false;
                if(userModel.userTimeList?.length ==userModel.userDateList?.length ){
                  isClosed = true;
                }
                for (var i  = 0 ; i < (userModel.userDateList?.length ?? 0); i++) {
                  DateTime date =userModel.userDateList![i];
                  int time = userModel.userTimeList!.elementAtOrNull(i)??0;
                  if(DateTime.now().toString().split(" ")[0] == date.toString().split(" ")[0]){
                    totalSec += time;
                  }else{
                  }
                }
                if(isClosed){
                }else {
                  totalSec += DateTime.now().difference(userModel.userDateList!.last).inSeconds;
                  _stopWatchTimer.onStartTimer();
                }
                _stopWatchTimer.setPresetSecondTime(totalSec);
                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Get.to(() => TimerView(oldKey:userModel.userId!,));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.grey.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                        height: 140,
                        width: 140,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              userModel.userName ?? "",
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              getUserStatusFromEnum( userModel.userStatus ?? ""),
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: userModel.userStatus == Const.userStatusOnline?Colors.green:Colors.orange),
                            ),
                            StreamBuilder<int>(
                              stream: _stopWatchTimer.rawTime,
                              initialData: _stopWatchTimer.rawTime.value,
                              builder: (context, snap) {
                                final value = snap.data!;
                                final displayTime = StopWatchTimer.getDisplayTime(value, milliSecond: false);
                                return     Container(
                                  height: 75,
                                  width: 300,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
                                  child: Center(
                                    child: Text(
                                      displayTime,
                                      style: const TextStyle(fontSize: 40, fontFamily: 'Helvetica', fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                );
                              },
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 40,
                              child: Icon(
                                _stopWatchTimer.isRunning ? Icons.stop : Icons.play_arrow,
                                size: 40,
                              ),
                            ),
                            // Text("تارغيت الجوالات: " + sellerData.mobileTotal.toString(), style: const TextStyle(fontSize: 18)),
                            // Text("تارغيت الاكسسوارات: " + sellerData.otherTotal.toString(), style: const TextStyle(fontSize: 18)),
                            // Text("التاسكات المنفذة: " + allTask.toString() + "/"+targetViewModel.allTarget.length.toString(), style: const TextStyle(fontSize: 18)),
                            // Row(
                            //   children: [
                            //     Text("حقق التارغيت:", style: const TextStyle(fontSize: 18)),
                            //     SizedBox(width: 5,),
                            //     Icon(isHitTarget?Icons.check:Icons.cancel,color: isHitTarget?Colors.green:Colors.red,),
                            //   ],
                            // )
                          ],
                        ),
                      ),
                    )
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
