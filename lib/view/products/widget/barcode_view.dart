import 'package:ba3_business_solutions/view/invoices/pages/new_invoice_view.dart';
import 'package:ba3_business_solutions/view/invoices/widget/custom_Text_field.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ProductBarcodeView extends StatefulWidget {
  const ProductBarcodeView({super.key, required this.name, required this.price, required this.barcode});

  final String name, price, barcode;

  @override
  State<ProductBarcodeView> createState() => _ProductBarcodeViewState();
}

class _ProductBarcodeViewState extends State<ProductBarcodeView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController barcodeController = TextEditingController();
  TextEditingController batteryController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.text = widget.name;
    priceController.text = widget.price;
    barcodeController.text = widget.barcode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          // shrinkWrap: true,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: Get.width / 2,
              // height: Get.height / 2,
              margin: const EdgeInsets.only(left: 10, right: 10),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.white, border: Border.all(color: Colors.black)),
              child: Column(
                children: [
                  CustomTextFieldWithoutIcon(controller: nameController),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFieldWithoutIcon(
                    controller: batteryController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: BarcodeWidget(
                      barcode: Barcode.code128(),
                      // نوع الباركود
                      data: barcodeController.text,
                      // البيانات التي تريد تشفيرها في الباركود
                      width: 400,
                      height: 160,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextFieldWithoutIcon(controller: priceController),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            AppButton(
                title: "print",
                onPressed: () {
                  _printBarcodeWithInfo(nameController.text, barcodeController.text);
                },
                iconData: Icons.print)
          ],
        ),
      ),
    );
  }

  void _printBarcodeWithInfo(text, barcode) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Product Information', // عنوان رئيسي
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              // مسافة
              pw.Text('Product Name: ABC Product'),
              // اسم المنتج
              pw.Text('Price: \$10.00'),
              // السعر
              pw.Text('SKU: 12345'),
              // كود المنتج
              pw.SizedBox(height: 20),
              // مسافة
              pw.BarcodeWidget(
                barcode: pw.Barcode.isbn(), // توليد الباركود
                data: '1234567891231', // نفس البيانات المستخدمة لتوليد الباركود
                width: 200,
                height: 80,
              ),
              pw.SizedBox(height: 20),
              // مسافة
              pw.Text('Scan the barcode above for more information'),
              // نص إضافي
            ],
          );
        },
      ),
    );

    // طباعة المستند
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
