import 'package:ba3_business_solutions/controller/account/account_controller.dart';
import 'package:ba3_business_solutions/core/helper/functions/functions.dart';
import 'package:ba3_business_solutions/model/global/global_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfBondApi {
  static Future<Uint8List> generate(GlobalModel bond, {bool? update, GlobalModel? bondOld}) async {
    final data = await rootBundle.load('assets/NotoSansArabic-Regular.ttf');

    final font = Font.ttf(data.buffer.asByteData());
    final image = await rootBundle.load('assets/logo.jpg');
    final pdf = Document();

    pdf.addPage(MultiPage(
      build: (context) => [
        // buildHeader(invoice),
        if (update == true) ...[
          Text("This bond Update"),
          buildTitle(bondOld!, image, font),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Text("bond.info.description"),
          Text(bondOld.bondDescription!,style: TextStyle(font: font)),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          buildInvoice(bondOld, font),
          Divider(),
          Text("**************"),
          Divider(),
        ],
        buildTitle(bond, image, font),
        SizedBox(height: 0.5 * PdfPageFormat.cm),
        Text("bond.info.description"),
        Text(bond.bondDescription!,style: TextStyle(font: font)),

        SizedBox(height: 0.5 * PdfPageFormat.cm),
        buildInvoice(bond, font),
        Divider(),
      ],
    ));
    return await pdf.save();
    // return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildTitle(GlobalModel invoice, image, font) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'BOND',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 0.4 * PdfPageFormat.cm),
            Text("bondCode : ${invoice.bondCode}"),
            SizedBox(height: 0.4 * PdfPageFormat.cm),
            Text(
              "نوع السند : ${getBondTypeFromEnum(invoice.bondType!)}",
              style: TextStyle(font: font),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 0.4 * PdfPageFormat.cm),
            Text("bondId : ${invoice.bondId}"),
            SizedBox(height: 0.4 * PdfPageFormat.cm),

            Text("Date of bond: ${invoice.bondDate}"),
            SizedBox(height: 0.4 * PdfPageFormat.cm),

            // Annotation(builder: AnnotationUrl("${Uri.base.origin}?id=${invoice.invId!}"), child: Text("The Origin Invoice", style: TextStyle(color: PdfColor.fromHex("#0000AA"), decoration: TextDecoration.underline))),
          ],
        ),
        Image(MemoryImage(image.buffer.asUint8List()), width: 5 * PdfPageFormat.cm, height: 5 * PdfPageFormat.cm),
      ]);

  static Widget buildInvoice(GlobalModel invoice, font) {
    final headers = [
      'id',
      "account",
      'debt',
      'credit',
      'nots',
    ];

    List<List<dynamic>> data = invoice.bondRecord!.map((item) {
      return [
        item.bondRecId!,
        getAccountModelFromId(item.bondRecAccount)?.accCode,
        item.bondRecDebitAmount,
        item.bondRecCreditAmount,
        item.bondRecDescription,
      ];
    }).toList();

    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      cellStyle: pw.TextStyle(
        font: font,
      ),

      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      columnWidths: {
        0: const pw.IntrinsicColumnWidth(flex: 10),
      },
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
      },
    );
  }

  static buildSimpleText({
    required String title,
    required String value,
    required var font,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold, font: font);

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
