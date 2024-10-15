import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../controller/product/product_controller.dart';
import '../../controller/seller/sellers_controller.dart';

class PdfInvoiceApi {
  static Future<Uint8List> generate(GlobalModel invoice, {bool? update, GlobalModel? invoiceOld}) async {
    final data = await rootBundle.load('assets/NotoSansArabic-Regular.ttf');

    // final file=await File('assets/NotoSansArabic-Regular.ttf').readAsBytes();
    final font = Font.ttf(data.buffer.asByteData());
    final image = await rootBundle.load('assets/logo.jpg');
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        // buildHeader(invoice),
        if (update == true) ...[
          Text("This bill Update"),
          buildTitle(invoiceOld!, image, font),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Text("invoice.info.description"),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildInvoice(invoiceOld),
          Divider(),
          buildTotal(invoiceOld),
          Divider(),
          Text("**************End"),
          Divider(),
          Divider(),
        ],
        buildTitle(invoice, image, font),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        Text("invoice.info.description"),

        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
      ],
      footer: (context) => buildFooter(invoice),
    ));
    return await pdf.save();
    // return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildTitle(GlobalModel invoice, image, font) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INVOICE',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 0.4 * PdfPageFormat.cm),
            Text("invCode of Invoice: ${invoice.invCode}"),
            SizedBox(height: 0.4 * PdfPageFormat.cm),
            Text("invType of Invoice: ${invoice.invType}"),
            SizedBox(height: 0.4 * PdfPageFormat.cm),
            Text("invId of Invoice: ${invoice.invId}"),
            SizedBox(height: 0.4 * PdfPageFormat.cm),

            Text("Date of Invoice: ${invoice.invDate}"),
            SizedBox(height: 0.4 * PdfPageFormat.cm),
            Text("Mobile Number: ${invoice.invMobileNumber}"),
            SizedBox(height: 0.4 * PdfPageFormat.cm),
            Row(children: [
              Text("Seller Name: "),
              Text(
                getSellerNameFromId(invoice.invSeller) ?? "",
                style: TextStyle(font: font),
                textDirection: TextDirection.rtl,
              ),
            ]),
            SizedBox(height: 0.4 * PdfPageFormat.cm),
            // Annotation(builder: AnnotationUrl("${Uri.base.origin}?id=${invoice.invId!}"), child: Text("The Origin Invoice", style: TextStyle(color: PdfColor.fromHex("#0000AA"), decoration: TextDecoration.underline))),
          ],
        ),
        Image(MemoryImage(image.buffer.asUint8List()), width: 5 * PdfPageFormat.cm, height: 5 * PdfPageFormat.cm),
      ]);

  static Widget buildInvoice(GlobalModel invoice) {
    final headers = ['Item Name', 'Barcode', 'Quantity', 'Unit Price', 'VAT', 'Total'];

    // إنشاء البيانات بشكل قائمة من القوائم
    List<List<dynamic>> data = invoice.invRecords!.map((item) {
      final barcode = Barcode.codabar(); // اختيار نوع الباركود المناسب

      // تحويل الباركود إلى صورة
      final barcodeImage = pw.BarcodeWidget(
        barcode: barcode,
        data: getProductBarcodeFromId(item.invRecProduct),
        width: 100,
        height: 40,
      );

      return [
        getProductNameFromId(item.invRecProduct!),
        barcodeImage, // عرض الباركود كصورة
        '${item.invRecQuantity}',
        ((((item.invRecTotal! / item.invRecQuantity!)) - (item.invRecTotal! * 0.05)).toStringAsFixed(2)),
        ((item.invRecTotal! * 0.05).toStringAsFixed(2)),
        ((item.invRecTotal!).toStringAsFixed(2)),
      ];
    }).toList();

    // استخدام Table.fromTextArray لتنسيق الجدول
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        0: const pw.IntrinsicColumnWidth(flex: 10),
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center, // محاذاة الباركود
        2: pw.Alignment.center,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(GlobalModel invoice) {
    final netTotal = invoice.invRecords!.map((item) => item.invRecTotal!).reduce((item1, item2) => item1 + item2);
    const vatPercent = 0.05;
    final vat = netTotal * vatPercent;
    final total = netTotal;

    return Directionality(
        textDirection: TextDirection.ltr,
        child: Container(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              Spacer(flex: 6),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildText(
                      title: 'Net total',
                      value: netTotal.toStringAsFixed(2),
                      unite: true,
                    ),
                    buildText(
                      title: 'Vat 5.0 %',
                      value: vat.toStringAsFixed(2),
                      unite: true,
                    ),
                    Divider(),
                    buildText(
                      title: 'Total amount due',
                      titleStyle: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      value: total.toStringAsFixed(2),
                      unite: true,
                    ),
                    SizedBox(height: 2 * PdfPageFormat.mm),
                    Container(height: 1, color: PdfColors.grey400),
                    SizedBox(height: 0.5 * PdfPageFormat.mm),
                    Container(height: 1, color: PdfColors.grey400),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  static Widget buildFooter(GlobalModel invoice) => Directionality(
      textDirection: TextDirection.ltr,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            buildSimpleText(title: '', value: 'Thank You To Visit:'),
            SizedBox(width: 1 * PdfPageFormat.mm),
            buildSimpleText(title: 'Burj ALArab', value: "Mobile Phone"),
          ])
          // buildSimpleText(title: 'Paypal', value: invoice.supplier.paymentInfo),
        ],
      ));

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    TextStyle? titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
