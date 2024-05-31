import 'package:ba3_business_solutions/model/global_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/bond_view_model.dart';

void showLoadingDialog({required int total,required Future<void> Function(int index) fun}) {
  Get.defaultDialog(
    title: "يرجى الانتظار",
    barrierDismissible: false,
    content:  LoadingView(total:total, fun: fun,)
  );
}
class LoadingView extends StatefulWidget {
  final int total ;
  final Future<void> Function(int index) fun;
  const LoadingView({super.key, required this.total, required this.fun});
  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  bool isCancel = false;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized().waitUntilFirstFrameRasterized.then((value) {
      Future.sync(() async {
        await longTask();
        Get.back();
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(i.toString()+ "  /  "+widget.total.toString()),
        SizedBox(height: 10,),
        CircularProgressIndicator(),
        SizedBox(height: 10,),
        ElevatedButton(onPressed: (){
          isCancel=true;
        }, child: const Text("cancel"))
      ],
    );
  }



  int i = 0;
  Future<void> longTask() async {
    for (int index=0 ;index < widget.total;index++) {
      if(isCancel)return;
      i++;
      print(i.toString());
      setState(() {});
      await widget.fun(index);
    }
  }
}
