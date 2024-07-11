import 'package:ba3_business_solutions/controller/product_view_model.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';


import '../../../Const/const.dart';
import '../../../controller/user_management_model.dart';
import '../../../model/product_model.dart';
import '../../../model/product_record_model.dart';

class AddProduct extends StatefulWidget {
  final String? oldKey;
  final String? oldBarcode;
  final String? oldParent;
  const AddProduct({super.key, this.oldKey,this.oldBarcode, this.oldParent});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController customerPriceController = TextEditingController();
  TextEditingController wholePriceController = TextEditingController();
  TextEditingController retailPriceController = TextEditingController();
  TextEditingController costPriceController = TextEditingController();
  TextEditingController minPriceController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  String? productType;
  // String? prodParentId;
  // bool prodIsRoot=false;
  late ProductModel editedProduct;
  List<ProductRecordModel> editedProductRecord = [];
  ProductViewModel productController = Get.find<ProductViewModel>();
  bool isEdit = false;
  bool hasVat = true;
  bool isGroup = false;

  @override
  void initState() {
    super.initState();
    initPage();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: WillPopScope(
        onWillPop: () async {
          if (isEdit) {
            Get.defaultDialog(actions: [
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.back();
                  },
                  child: Text("تجاهل")),
              ElevatedButton(
                  onPressed: () {
                    checkPermissionForOperation(Const.roleUserUpdate,Const.roleViewProduct).then((value) {
                      if(value){
                        productController.updateProduct(editedProduct, withLogger: true);
                        Get.back();
                        Get.back();
                      }
                    });


                  },
                  child: Text("تعديل")),
            ]);
            return false;
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(editedProduct.prodName ?? "إضافة المادة"),
            actions: [
              // if (editedProduct.prodId != null)
              //   ElevatedButton(
              //       onPressed: () {
              //         checkPermissionForOperation(Const.roleUserDelete,Const.roleViewProduct).then((value) {
              //           if(value){
              //             productController.deleteProduct(withLogger: true);
              //             Get.back();
              //           }
              //         });
              //
              //
              //       },
              //       child: Text("حذف"))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50),
            child: Container(
              width: double.infinity,
              child: ListView(
                      children: [
                        item(text: "اسم المادة",controller:nameController ,onChange:(_) {
                          editedProduct.prodName= _;
                            isEdit = true;
                        }),
                        Row(
                          children: [
                            item(text: "الرمز",controller:codeController ,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                onChange:(_) {
                                editedProduct.prodCode= _;
                                isEdit = true;
                              }),

                            if(editedProduct.prodParentId!=null)
                            Text(getProductModelFromId(editedProduct.prodParentId)!.prodFullCode!),
                            Spacer(),
                          ],
                        ),
                        item(text: "سعر مستهلك",controller:customerPriceController , inputFormatters: [FilteringTextInputFormatter.digitsOnly],onChange:(_) {
                          editedProduct.prodCustomerPrice = _;
                          isEdit = true;
                        }),
                        item(text: "سعر الجملة",controller:wholePriceController , inputFormatters: [FilteringTextInputFormatter.digitsOnly],onChange:(_) {
                          editedProduct.prodWholePrice = _;
                          isEdit = true;
                        }),
                        item(text: "سعر مفرق",controller:retailPriceController , inputFormatters: [FilteringTextInputFormatter.digitsOnly],onChange:(_) {
                          editedProduct.prodRetailPrice = _;
                          isEdit = true;
                        }),
                        item(text: "سعر تكلفة",controller:costPriceController , inputFormatters: [FilteringTextInputFormatter.digitsOnly],onChange:(_) {
                          editedProduct.prodCostPrice = _;
                          isEdit = true;
                        }),
                        item(text: "اقل سعر مسموح",controller:minPriceController , inputFormatters: [FilteringTextInputFormatter.digitsOnly],onChange:(_) {
                          editedProduct.prodMinPrice = _;
                          isEdit = true;
                        }),
                        item(text: "الباركود",controller:barcodeController , inputFormatters: [FilteringTextInputFormatter.digitsOnly],onChange:(_) {
                          editedProduct.prodBarcode = _;
                          isEdit = true;
                        }),                       
                        SizedBox(height: 30,),
                        Row(
                          children: [
                            SizedBox(
                                width:70,
                                child: Text("isLocal")),
                            SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: StatefulBuilder(builder: (context, setstate) {
                                return Checkbox(
                                    value: editedProduct.prodIsLocal!,
                                    onChanged:  (_) {
                                      setstate(() {
                                        editedProduct.prodIsLocal = _;
                                        isEdit = true;
                                      });
                                    });
                              }),
                            ),
                          ],
                        ),
                        // SizedBox(height: 30,),
                        // StatefulBuilder(builder: (context, setstate) {
                        //   return Column(
                        //     children: [
                        //       Row(
                        //         children: [
                        //           Text("حساب مجموعة" ),
                        //           SizedBox(
                        //             width: 30,
                        //             height: 30,
                        //             child: Checkbox(
                        //               value: editedProduct.prodIsGroup??false,
                        //               onChanged: (_) {
                        //                 setstate(() {
                        //                   editedProduct.prodIsGroup = _!;
                        //                 });
                        //               },
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ],
                        //   );
                        // }),
                        if(widget.oldKey != null)
                        SizedBox(height: 30,),
                        if(widget.oldKey != null)
                        StatefulBuilder(builder: (context, setstate) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Text("حساب اب"),
                                  SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Checkbox(
                                      value: editedProduct.prodIsParent??false,
                                      onChanged: (_) {
                                        setstate(() {
                                          editedProduct.prodIsParent = _!;
                                          editedProduct.prodParentId=null;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30,),
                              Row(
                                children: [
                                  Flexible(flex: 2, child: Text("الحساب الاب")),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  Flexible(
                                      flex: 3,
                                      child:
                                      //  customTextFieldWithoutIcon(accVatController, true)
                                      IgnorePointer(
                                        ignoring:  editedProduct.prodIsParent??false,
                                        child: Container(
                                          color:   editedProduct.prodIsParent??false?Colors.grey.shade700:Colors.transparent,
                                          child: DropdownButton(
                                            value: editedProduct.prodParentId,
                                            items: productController.productDataMap.entries.toList().where((element) => element.value.prodIsGroup!).map((MapEntry<String, ProductModel> e) => DropdownMenuItem(value: e.key,child: Text(e.value.prodCode! +" - "+ e.value.prodName!))).toList(),
                                            onChanged: (_) {
                                              setstate(() {
                                                editedProduct.prodParentId = _.toString();
                                              });
                                            },
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ],
                          );
                        }),
                        SizedBox(height: 30,),
                        Row(
                          children: [
                            SizedBox(
                                width:70,
                                child: Text("نوع الحساب")),
                            SizedBox(
                              width: 20,
                            ),
                            SizedBox(
                                height: 35,
                                width: 130,
                                child: StatefulBuilder(
                                  builder: (context,setstate) {
                                    return DropdownButton(
                                      value: editedProduct.prodType,
                                        isExpanded: true,
                                        items: [Const.productTypeStore,Const.productTypeService].map((e) => DropdownMenuItem(value: e,child:
                                        Text(getProductTypeFromEnum(e.toString())))).toList(), onChanged: (_){
                                        setstate((){
                                          editedProduct.prodType=_;
                                        });
                                    });
                                  }
                                )),
                          ],
                        ),
                        SizedBox(height: 30,),
                        ElevatedButton(
                          onPressed: () {
                            if(checkInput()) {
                          if (editedProduct.prodId == null) {
                            checkPermissionForOperation(Const.roleUserWrite, Const.roleViewProduct).then((value) {
                              if (value) {
                                productController.createProduct(editedProduct, withLogger: true);
                                isEdit = false;
                              }
                            });
                          } else {
                            checkPermissionForOperation(Const.roleUserUpdate, Const.roleViewProduct).then((value) {
                              if (value) {
                                productController.updateProduct(editedProduct, withLogger: true);
                                isEdit = false;
                              }
                            });
                          }
                        }
                      },
                          child: Text(editedProduct.prodId == null ? "إضافة" : "تعديل"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void initPage() {
    if (widget.oldKey != null) {
      editedProduct = ProductModel.fromJson(productController.productDataMap[widget.oldKey!]!.toJson());
      productController.productModel = ProductModel.fromJson(productController.productDataMap[widget.oldKey!]!.toJson());
      editedProductRecord.clear();
      productController.productModel?.prodRecord?.forEach((element) {
        editedProductRecord.add(ProductRecordModel.fromJson(element.toJson()));
      });
      ProductModel _ = productController.productDataMap[widget.oldKey!]!;
      nameController.text = _.prodName!;
      codeController.text = _.prodCode!;
      customerPriceController.text = _.prodCustomerPrice??"0";
      wholePriceController.text = _.prodWholePrice??"0";
      retailPriceController.text = _.prodRetailPrice??"0";
      costPriceController.text = _.prodCostPrice??"0";
      minPriceController.text = _.prodMinPrice??"0";
      barcodeController.text = _.prodBarcode!;
      productType=_.prodType;
      isGroup = _.prodIsGroup ?? false;
      // editedProduct.prodParentId = _.prodParentId ;
      // editedProduct.prodIsParent=_.prodParentId==null;
      print(_.toFullJson());
    }
    else {
      editedProduct = ProductModel();
      productController.productModel = ProductModel();
      editedProductRecord = <ProductRecordModel>[];
      hasVat = true;
      isGroup = false;
      editedProduct.prodIsLocal = false;

      editedProduct.prodType = Const.productTypeStore;
      editedProduct.prodIsGroup = false;
      if(widget.oldBarcode!=null){
        barcodeController.text=widget.oldBarcode!;
        editedProduct.prodBarcode=widget.oldBarcode;
      }
      if(widget.oldParent!=null){
        editedProduct.prodCode = productController.getNextProductCode(perantId: widget.oldParent);
        editedProduct.prodParentId = widget.oldParent ;
        editedProduct.prodIsParent=false;
      }else{
        editedProduct.prodCode = productController.getNextProductCode();
      }
      codeController.text = editedProduct.prodCode!;
    }
     // productController.initProductPage(editedProductRecord);
  }
  bool checkInput() {
    if(editedProduct.prodName?.isEmpty??true){
      Get.snackbar("خطأ", "يرجى كتابة اسم");
    }else if (editedProduct.prodCode?.isEmpty??true){
      Get.snackbar("خطأ", "يرجى كتابة رمز");
    }
    else if (editedProduct.prodCustomerPrice?.isEmpty??true){
      Get.snackbar("خطأ", "يرجى كتابة سعر المستهلك");
    }
    else if (editedProduct.prodWholePrice?.isEmpty??true){
      Get.snackbar("خطأ", "يرجى كتابة السعر الجملة");
    }
    else if (editedProduct.prodCostPrice?.isEmpty??true){
      Get.snackbar("خطأ", "يرجى كتابة السعر التكلفة");
    }
    else if (editedProduct.prodRetailPrice?.isEmpty??true){
      Get.snackbar("خطأ", "يرجى كتابة سعر المفرق");
    }
    else if (editedProduct.prodMinPrice?.isEmpty??true){
      Get.snackbar("خطأ", "يرجى كتابة اقل سعر مسموح");
    }else if (editedProduct.prodBarcode?.isEmpty??true){
      Get.snackbar("خطأ", "يرجى كتابة باركود");
    }else{
      return true;
    }
    return false;
  }

  Widget item({required String text,required TextEditingController controller,required Function(String _) onChange ,List<TextInputFormatter>? inputFormatters}){
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                width:70,
                child: Text(text)),
            SizedBox(
              width: 30,
            ),
            SizedBox(
              height: 50,
              width: 400,
              child: TextFormField(
                inputFormatters:inputFormatters ,
                controller: controller,
                onChanged: onChange
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}


