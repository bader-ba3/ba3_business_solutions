

import 'package:ba3_business_solutions/controller/product/product_view_model.dart';
import 'package:ba3_business_solutions/controller/seller/sellers_view_model.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<Uint8List> generate(GlobalModel invoice) async {
    final data = await rootBundle.load('assets/NotoSansArabic-Regular.ttf');

    // final file=await File('assets/NotoSansArabic-Regular.ttf').readAsBytes();
    final font = Font.ttf(data.buffer.asByteData());
    final image = await rootBundle.load('assets/logo.jpg');
    final pdf = Document();
    print(invoice.invRecords);
    print(invoice.invSeller);
    pdf.addPage(MultiPage(
      build: (context) => [
        // buildHeader(invoice),
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
                getSellerNameFromId(invoice.invSeller)??"",
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
    final headers = [
      'Item Name',
      // 'Date',
      'Quantity',
      'Unit Price',
      'VAT',
      'Total'
    ];
    List<List<String?>>? data = invoice.invRecords?.map((item) {
      // final total = item.unitPrice * item.quantity * (1 + item.vat);

      return [
        getProductNameFromId(item.invRecProduct!),
        // Utils.formatDate(item.date),
        '${item.invRecQuantity}',
        ((((item.invRecTotal! / item.invRecQuantity!)) - (item.invRecTotal! * 0.05)).toStringAsFixed(2)),
        ((item.invRecTotal! * 0.05).toStringAsFixed(2)),
        ((item.invRecTotal!).toStringAsFixed(2)),
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data!,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        0: const IntrinsicColumnWidth(flex: 10),
      },
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        // 5: Alignment.centerRight,
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
