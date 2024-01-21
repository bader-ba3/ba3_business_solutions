import 'dart:developer';
import 'dart:io';

import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:ba3_business_solutions/model/product_model.dart';
import 'package:ba3_business_solutions/view/products/widget/add_product.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';


class QRScannerView extends StatefulWidget {
  const QRScannerView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<QRScannerView> {
 List <ProductModel> data=[];
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        controller?.stopCamera();
        return true;
      },
      child: Scaffold(
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              _buildQrView(context),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  // width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(width: 20,),
                      Wrap(
                        direction: Axis.vertical,
                        children: <Widget>[

                          if(data.isEmpty)
                            const Text('امسح الباركود'),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   crossAxisAlignment: CrossAxisAlignment.center,
                          //   children: <Widget>[
                          //     Container(
                          //       margin: const EdgeInsets.all(8),
                          //       child: ElevatedButton(
                          //           onPressed: () async {
                          //             await controller?.toggleFlash();
                          //             setState(() {});
                          //           },
                          //           child: FutureBuilder(
                          //             future: controller?.getFlashStatus(),
                          //             builder: (context, snapshot) {
                          //               return Text('Flash: ${snapshot.data}');
                          //             },
                          //           )),
                          //     ),
                          //     Container(
                          //       margin: const EdgeInsets.all(8),
                          //       child: ElevatedButton(
                          //           onPressed: () async {
                          //             await controller?.flipCamera();
                          //             setState(() {});
                          //           },
                          //           child: FutureBuilder(
                          //             future: controller?.getCameraInfo(),
                          //             builder: (context, snapshot) {
                          //               if (snapshot.data != null) {
                          //                 return Text(
                          //                     'Camera facing ${describeEnum(snapshot.data!)}');
                          //               } else {
                          //                 return const Text('loading');
                          //               }
                          //             },
                          //           )),
                          //     )
                          //   ],
                          // ),

                          Text("عدد المنتجات "+data.length.toString(),style: TextStyle(fontSize: 24),),
                          SizedBox(height: 10,),
                          for(var i in data)
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Text(i.prodName??"not found",style: TextStyle(fontSize: 22),),
                                  SizedBox(width: 20,),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        data.remove(i);
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(Icons.close,color: Colors.red,),
                                    ),
                                  )
                                ],
                              ),
                            )
                        ],
                      ),
                      Spacer(),
                      if(data.isNotEmpty)
                      ElevatedButton(onPressed: (){
                        Get.back(result: data);
                      }, child: Text("إضافة")),
                      SizedBox(width: 50,),
                    ],
                  ),
                ),
              ),
                Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: (){
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(50.0),
                        child: Container(width: 75,height: 75,decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                        child: Icon(Icons.arrow_back),),
                      ),
                    ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          // cutOutSize: scanArea
          cutOutHeight: 350,
          cutOutWidth: 500
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData)  {
      print(scanData.format==BarcodeFormat.qrcode);
      if(scanData.code!=null){
        if(data.firstWhereOrNull((element) => element.prodBarcode==scanData.code)==null&&scanData.format!=BarcodeFormat.qrcode){

          ProductViewModel productViewController = Get.find<ProductViewModel>();

         var _= productViewController.productDataMap.values.toList().firstWhereOrNull((element) => element.prodBarcode==scanData.code);
         if(_!=null){
           data.add(_);
           setState(() {

           });
           print("object");
         }else{
            controller.pauseCamera();
            Get.defaultDialog(
              onWillPop: ()async{
                controller.resumeCamera();
                return true;
              },
                title: "غير موجود",middleText: "غير موجود "+scanData.code!+"المنتح صاحب الباركود ",actions: [
              ElevatedButton(onPressed: (){
                Get.back();
                controller.resumeCamera();
                }, child: Text("إلغاء")),
              ElevatedButton(onPressed: ()async{
                Get.back();
               await Get.to(()=>AddProduct(oldBarcode:scanData.code));
                controller.resumeCamera();
                }, child: Text("إضافة المنتح")),
            ]);

         }

        //  Get.back(result: {"data":data});

        }
      }


     //  Get.back();
      // setState(() {
      //   result = scanData;
      // });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}