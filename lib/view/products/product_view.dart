import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/model/products_model.dart';
import 'package:ba3_business_solutions/utils/logger.dart';
import 'package:ba3_business_solutions/utils/realm.dart';
import 'package:ba3_business_solutions/view/products/widget/add_product.dart';
import 'package:ba3_business_solutions/view/products/widget/product_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Const/const.dart';
import '../../old_model/product_model.dart';

class AllProduct extends StatelessWidget {
  const AllProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
        //     actions: [
        //   ElevatedButton(
        //       onPressed: () {
        //         Get.to(() => AddProduct());
        //       },
        //       child: const Text("create"))
        // ]
        ),
        body: GetBuilder<ProductViewModel>(builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: StreamBuilder(stream: RealmDataBase.realm.all<Products>().changes,
              builder: (context, snapshot) {
              if(snapshot.data== null){
                return CircularProgressIndicator();
              }
              List<Products> productList =snapshot.data!.results.toList();
              return ListView.builder(
                itemCount: productList.length,
                      itemBuilder: (context, index) {
                        Products model = productList[index];
                        return _prodItemWidget(model ,controller);
                      });
            },),
            // child: ListView.builder(
            //     itemCount: controller.productDataMap.values.where((element) => !element.prodIsGroup!&&(Const.isFilterFree ? element.prodIsLocal!: true)).toList().length,
            //     itemBuilder: (context, index) {
            //       ProductModel model = controller.productDataMap.values.toList().where((element) => !element.prodIsGroup!&&(Const.isFilterFree ? element.prodIsLocal!: true)).toList()[index];
            //       return _oldprodItemWidget(model ,controller);
            //     }),
          );
        }),
      ),
    );
  }
  Widget _prodItemWidget(Products model,controller){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => ProductDetails(
            oldKey: model.prodId,
          ));
        },
        child: Row(
          children: [
            Container(
                width: 100,
                child: Text(model.prodId.toString(),style: TextStyle(fontSize: 20),)),
            Text(" - ",style: TextStyle(fontSize: 20),),
            //   Text(model.prodId ?? "not found"),
            Text(model.prodName ?? "not found",style: TextStyle(fontSize: 20),),
            SizedBox(width: 20,),
            Text("الكمية: "),
            Text(model.prodFullCode.toString(),style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }


  Widget _oldprodItemWidget(ProductModel model,controller){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          logger(newData: model, transfersType: TransfersType.read);
          Get.to(() => ProductDetails(
            oldKey: model.prodId,
          ));
        },
        child: Row(
          children: [
            Container(
                width: 100,
                child: Text(controller.getFullCodeOfProduct(model.prodId!),style: TextStyle(fontSize: 20),)),
            Text(" - ",style: TextStyle(fontSize: 20),),
            //   Text(model.prodId ?? "not found"),
            Text(model.prodName ?? "not found",style: TextStyle(fontSize: 20),),
            SizedBox(width: 20,),
            Text("الكمية: "),
            Text(model.prodFullCode.toString(),style: TextStyle(fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
