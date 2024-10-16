import 'package:ba3_business_solutions/controller/databsae/import_controller.dart';
import 'package:ba3_business_solutions/core/shared/widgets/app_spacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/generate_id.dart';

class ImportConfigurationView extends StatefulWidget {
  final List<List<String>> productList;
  final List<String> rows;

  const ImportConfigurationView({super.key, required this.productList, required this.rows});

  @override
  State<ImportConfigurationView> createState() => _ImportConfigurationViewState();
}

class _ImportConfigurationViewState extends State<ImportConfigurationView> {
  Map<String, RecordType> typeMap = {
    "حسابات": RecordType.accCustomer,
    "مواد": RecordType.product,
    "شيكات": RecordType.cheque,
    "حسابات بدون زبائن": RecordType.account,
  };

  Map configProduct = {
    'اسم المادة': 'prodName',
    'رمز المادة': 'prodCode',
    // 'اسم المجموعة' :'prodParentId',
    'سعر المستهلك': 'prodCustomerPrice',
    'سعر جملة': 'prodWholePrice',
    'سعر مفرق': 'prodRetailPrice',
    'سعر التكلفة': 'prodCostPrice',
    'اقل سعر مسموح': 'prodMinPrice',
    'باركود المادة': 'prodBarcode',
    'رمز المجموعة': 'prodParentId',
    'نوع المادة': 'prodType',
  };

  Map configAccount = {
    "الحساب": "accName",
    "رمز الحساب": "accCode",
    "الحساب الرئيسي": 'accParentId',
    "اسم حساب الزبون": 'customerAccountName',
    "رقم البطاقة": 'customerCardNumber',
    "الترميز الضريبي": 'customerVAT',
  };
  Map configAccountWitOut = {
    "الحساب": "accName",
    "رمز الحساب": "accCode",
    "الحساب الرئيسي": 'accParentId',
  };

  Map configCheque = {
    // "الاسم": "cheqName",
    "المبلغ": "cheqAllAmount",
    // "": "cheqRemainingAmount",
    // "الحساب ": "cheqPrimeryAccount",
    "الحساب المقابل": "cheqSecoundryAccount",
    "رثم الورقة": "cheqNum",
    "تاريخ الورقة": "cheqDate",
    "تاريخ الاستحقاق": "cheqDateDue",
    "حالة الورقة": "cheqStatus",
    "اسم النمط": "cheqType",
    // "": "cheqBankAccount"
  };

  Map config = {};
  Map setting = {};

  RecordType? type;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ImportController>();
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        shrinkWrap: true,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<RecordType>(
                  value: type,
                  items: typeMap.keys.map((e) => DropdownMenuItem(value: typeMap[e], child: Text(e.toString()))).toList(),
                  onChanged: (_) {
                    type = _;
                    if (_ == RecordType.product) {
                      config = configProduct;
                    } else if (_ == RecordType.account) {
                      config = configAccountWitOut;
                    } else if (_ == RecordType.cheque) {
                      config = configCheque;
                    }
                    setState(() {});
                  }),
              const SizedBox(
                width: 20,
              ),
              const Text("النوع"),
            ],
          ),
          if (type != null)
            SizedBox(
                width: Get.width,
                child: Wrap(
                  children: List.generate(
                      config.keys.toList().length,
                      (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 120,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(config.keys.toList()[index]),
                                  const Text("| |"),
                                  const Text(" V"),
                                  SizedBox(
                                    height: 30,
                                    width: 300,
                                    child: DropdownButton<int>(
                                        value: setting[config.values.toList()[index]],
                                        items: widget.rows
                                            .map((e) => DropdownMenuItem(
                                                  value: widget.rows.indexOf(e),
                                                  child: Text(e.toString()),
                                                ))
                                            .toList(),
                                        onChanged: (_) {
                                          // print(widget.rows.indexOf(_!));
                                          setting[config.values.toList()[index]] = _;
                                          print(setting);
                                          setState(() {});
                                        }),
                                  )
                                ],
                              ),
                            ),
                          )),
                )),
          ElevatedButton(
              onPressed: () async {
                if (type == RecordType.product) {
                  await controller.addProduct(widget.productList, setting);
                } else if (type == RecordType.account) {
                  await controller.addAccountWithOutCustomer(widget.productList, setting);
                } else if (type == RecordType.cheque) {
                  await controller.addCheque(widget.productList, setting);
                } else if (type == RecordType.accCustomer) {
                  // await addAccountWithCustomer();
                }
                // Get.offAll(() => HomeView());
              },
              child: const Text("ending")),
          const VerticalSpace(70),
          const Text("مثال"),
          const VerticalSpace(70),
          SizedBox(
              height: 80,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: List.generate(
                    widget.rows.length,
                    (index) => Column(
                          children: [Text(widget.rows[index]), Text(widget.productList[0][index])],
                        )),
              ))
        ],
      ),
    );
  }
}
