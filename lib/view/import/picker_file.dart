import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../Const/const.dart';
import '../../controller/bond_view_model.dart';
import '../../controller/import_view_model.dart';
import '../../controller/user_management_model.dart';

class FilePickerWidget extends StatelessWidget {

   FilePickerWidget({super.key});

   final List allSeparator=["Tab (  )","comma (,)","semicolon (;)"];
   final List allSeparatorValue=["	",",",";"];
   final importViewModel = Get.find<ImportViewModel>();

   @override
  Widget build(BuildContext context) {
     var separator;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatefulBuilder(
                  builder: (context,setState) {
                    return DropdownButton(
                        value: separator,
                        items: allSeparator.map((e) => DropdownMenuItem(value: allSeparatorValue[allSeparator.indexOf(e)],child: Text(e))).toList(), onChanged: (_){
                      setState((){
                        separator=_;
                      });
                    });
                  }
              ),
              SizedBox(height: 50,),
              ElevatedButton(
                onPressed: () {
                  if(separator!=null){
                    checkPermissionForOperation(Const.roleUserAdmin,Const.roleViewImport).then((value) {
                      if(value)importViewModel.pickFile(separator);
                    });
                  }else{
                    Get.snackbar("error", "plz select separator");
                  }
                },
                child: Text("استيراد"),
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  if(separator!=null){
                    importViewModel.pickBondFile(separator);
                  }else{
                    Get.snackbar("error", "plz select separator");
                  }
                },
                child: Text("سندات"),
              ),
              SizedBox(height: 30,),
              ElevatedButton(
                onPressed: () {
                  if(separator!=null){
                    importViewModel.pickInvoiceFile(separator);
                  }else{
                    Get.snackbar("error", "plz select separator");
                  }
                },
                child: Text("فواتير"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
