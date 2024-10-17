import 'package:ba3_business_solutions/controller/product/product_controller.dart';
import 'package:ba3_business_solutions/data/model/global/global_model.dart';
import 'package:ba3_business_solutions/data/model/invoice/invoice_record_model.dart';
import 'package:ba3_business_solutions/data/model/product/product_model.dart';
import 'package:ba3_business_solutions/data/model/warranty/warranty_model.dart';
import 'package:ba3_business_solutions/data/model/warranty/warranty_record_model.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

import '../../core/helper/functions/functions.dart';

class PrintController extends GetxController {
  Future<void> printFunction(GlobalModel globalModel, {WarrantyModel? warrantyModel}) async {
    List<BluetoothInfo> allBluetooth = await getBluetoots();

    if (allBluetooth
        .map(
          (e) => e.macAdress,
        )
        .toList()
        .contains("66:32:8D:F3:FF:7E")) {
      if (!connected) {
        await connect("66:32:8D:F3:FF:7E");
      }
      if (warrantyModel != null) {
        await printTest(GlobalModel(), warranty: warrantyModel);
      } else {
        await printTest(globalModel);
      }
      //await disconnect();
    } else if (allBluetooth
        .map(
          (e) => e.macAdress,
        )
        .toList()
        .contains("66:32:8d:f3:ff:7e")) {
      if (!connected) {
        await connect("66:32:8d:f3:ff:7e");
      }
      if (warrantyModel != null) {
        await printTest(GlobalModel(), warranty: warrantyModel);
      } else {
        await printTest(globalModel);
      }
      //await disconnect();
    } else {
      print("Cant find the printer");
    }
  }

  // String _info = "";
  //  String _msj = '';
  bool connected = false;
  List<BluetoothInfo> items = [];

  Future<List<BluetoothInfo>> getBluetoots() async {
    items = [];

    final List<BluetoothInfo> listResult = await PrintBluetoothThermal.pairedBluetooths;

    print(await PrintBluetoothThermal.isPermissionBluetoothGranted);

    items = listResult;

    return items;
  }

  Future<void> connect(String mac) async {
    connected = false;
    final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conected $result");
    if (result) connected = true;
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;

    connected = false;

    print("status disconnect $status");
  }

  Future<void> printTest(GlobalModel globalModel, {WarrantyModel? warranty}) async {
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;

    if (conexionStatus) {
      bool result = false;
      if (warranty != null) {
        List<int> ticket = await testTextWarranty(warranty);
        result = await PrintBluetoothThermal.writeBytes(ticket);
      } else {
        List<int> ticket = await invoicePrint(globalModel);
        result = await PrintBluetoothThermal.writeBytes(ticket);
      }

      print("print test result:  $result");
    } else {
      disconnect();
      print("print test conexionStatus: $conexionStatus");
    }
  }

  Future<List<int>> testImage() async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();
    // Uint8List? a = await Utils.capture(aKey);
    // bytes += generator.imageRaster(img.decodeImage(a!)!);
    bytes += generator.feed(2);
    return bytes;
  }

  Future<List<int>> invoicePrint(GlobalModel globalModel) async {
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    bytes += generator.text('Tax Invoice', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);

    final ByteData data = await rootBundle.load('assets/logo.jpg');
    final Uint8List bytesImg = data.buffer.asUint8List();
    img.Image? image = img.decodeImage(bytesImg);
    bytes += generator.imageRaster(image!);

    bytes += generator.text("Burj AlArab Mobile Phone", styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text("Date: ${globalModel.invDate}", styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text("IN NO: ${globalModel.invId}", styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text("TRN: 10036 93114 00003", styles: const PosStyles(align: PosAlign.left), linesAfter: 1);
    double total = 0;
    double natTotal = 0;
    double vatTotal = 0;
    for (InvoiceRecordModel model in globalModel.invRecords ?? []) {
      double modelSubTotalWithVat = model.invRecTotal! / model.invRecQuantity!;
      double modelSubVatTotal = modelSubTotalWithVat - (modelSubTotalWithVat / 1.05);
      double modelSubTotal = modelSubTotalWithVat / 1.05;

      ProductModel productModel = getProductModelFromId(model.invRecProduct)!;
      String text = productModel.prodEngName ?? '';
      if (text == '') {
        await setEnglishNameForProduct(productModel..prodEngName = await checkArabicWithTranslate(productModel.prodName!));
        text = await checkArabicWithTranslate(productModel.prodName!);
      }
      bytes += generator.text(text.length < 64 ? text : text.substring(0, 64), styles: const PosStyles(align: PosAlign.left));
      bytes += generator.text(productModel.prodBarcode ?? "", styles: const PosStyles(align: PosAlign.left));
      double totalOfLine = model.invRecTotal!;
      total = totalOfLine + total;
      // natTotal = model.invRecQuantity!* (model.invRecSubTotal!) +natTotal;
      // vatTotal = model.invRecQuantity!* (model.invRecSubTotal!)*0.05 +vatTotal;
      natTotal = model.invRecQuantity! * modelSubTotal + natTotal;
      vatTotal = model.invRecQuantity! * modelSubVatTotal + vatTotal;
      bytes += generator.text('${model.invRecQuantity} X ${modelSubTotalWithVat.toStringAsFixed(2)} -> Total:${totalOfLine.toStringAsFixed(2)}',
          styles: const PosStyles(align: PosAlign.left), linesAfter: 1);
    }

    bytes += generator.text('Total VAT: ${vatTotal.toStringAsFixed(2)}', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text('-' * 30, styles: const PosStyles(align: PosAlign.right));

    // bytes += generator.text('Sub: '+total.toStringAsFixed(2), styles: PosStyles(align: PosAlign.right));
    // bytes += generator.text('VAT: '+(globalModel.invTotal!-total).toStringAsFixed(2), styles: PosStyles(align: PosAlign.right));
    // bytes += generator.text('Total: '+globalModel.invTotal.toString(), styles: PosStyles(align: PosAlign.right,bold: true));
    bytes += generator.text('Sub: ' + natTotal.toStringAsFixed(2) + " AED", styles: const PosStyles(align: PosAlign.right, bold: true));
    bytes += generator.text('VAT: ' + vatTotal.toStringAsFixed(2) + " AED", styles: const PosStyles(align: PosAlign.right, bold: true));
    bytes +=
        generator.text('Total: ' + (natTotal + vatTotal).toStringAsFixed(2) + " AED", styles: const PosStyles(align: PosAlign.right, bold: true));
    bytes += generator.text("UAE, Rak, Sadaf Roundabout", styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("+971568666411", styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("Thanks For Visiting BA3", styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.feed(2);
    return bytes;
  }

  Future<List<int>> testTextWarranty(WarrantyModel globalModel) async {
    List<int> bytes = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    bytes += generator.reset();
    bytes += generator.text('Warranty Invoice', styles: const PosStyles(align: PosAlign.center), linesAfter: 1);
    bytes += generator.text("Burj AlArab Mobile Phone", styles: const PosStyles(align: PosAlign.center, bold: true));
    bytes += generator.text("Date: ${globalModel.invDate}", styles: const PosStyles(align: PosAlign.left));
    bytes += generator.text("IN NO: ${globalModel.invId}", styles: const PosStyles(align: PosAlign.left));

    for (WarrantyRecordModel model in globalModel.invRecords ?? []) {
      ProductModel productModel = getProductModelFromId(model.invRecProduct)!;
      String text = productModel.prodEngName ?? '';
      if (text == '') {
        await setEnglishNameForProduct(productModel..prodEngName = await checkArabicWithTranslate(productModel.prodName!));
        text = await checkArabicWithTranslate(productModel.prodName!);
      }
      bytes += generator.text(text.length < 64 ? text : text.substring(0, 64), styles: const PosStyles(align: PosAlign.left));
      bytes += generator.text(productModel.prodBarcode ?? "", styles: const PosStyles(align: PosAlign.left));
    }

    bytes += generator.text('-' * 30, styles: const PosStyles(align: PosAlign.right));

    bytes += generator.text("UAE, Rak, Sadaf Roundabout", styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("0568666411", styles: const PosStyles(align: PosAlign.center));
    bytes += generator.text("Thanks For Visiting BA3", styles: const PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.feed(2);

    return bytes;
  }

  double computeWithoutVatTotal(records) {
    int quantity = 0;
    double subtotals = 0.0;
    double total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        total += quantity * (subtotals);
      }
    }
    return total;
  }

  double computeAllTotal(records) {
    int quantity = 0;
    double subtotals = 0.0;
    double total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        subtotals = record.invRecSubTotal!;
        total += quantity * (subtotals + record.invRecVat!);
      }
    }
    return total;
  }

  double computeVatTotal(records) {
    int quantity = 0;
    double total = 0.0;
    for (var record in records) {
      if (record.invRecQuantity != null && record.invRecSubTotal != null) {
        quantity = record.invRecQuantity!;
        total += quantity * record.invRecVat!;
      }
    }
    return total;
  }

/*String checkArabicWithTranslate(String data) {
    bool isArabic = false;
    for (var c in data.codeUnits) {
      if (c >= 0x0600 && c <= 0x06E0) {
        isArabic = true;
      }
    }
    if (isArabic) {
      String _ = data
          .replaceAll("ا", "a")
          .replaceAll("ب", "b")
          .replaceAll("ت", "t")
          .replaceAll("ث", "th")
          .replaceAll("ج", "g")
          .replaceAll("ح", "h")
          .replaceAll("خ", "kh")
          .replaceAll("د", "d")
          .replaceAll("ذ", "th")
          .replaceAll("ر", "r")
          .replaceAll("ز", "z")
          .replaceAll("س", "s")
          .replaceAll("ش", "sh")
          .replaceAll("ص", "s")
          .replaceAll("ض", "d")
          .replaceAll("ط", "t")
          .replaceAll("ظ", "Z")
          .replaceAll("ع", "a")
          .replaceAll("غ", "gh")
          .replaceAll("ف", "ph")
          .replaceAll("ق", "k")
          .replaceAll("ك", "k")
          .replaceAll("ل", "l")
          .replaceAll("م", "m")
          .replaceAll("ن", "n")
          .replaceAll("ه", "h")
          .replaceAll("و", "w")
          .replaceAll("ي", "e")
          .replaceAll("ة", "a");
      print(_);
      print("$data  $_");
      return _;
    } else {
      return data;
    }
  }*/
}
