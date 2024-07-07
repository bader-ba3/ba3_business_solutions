// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/material.dart';
// import 'package:print_bluetooth_thermal/post_code.dart';
// import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
// import 'package:image/image.dart' as img;
// import 'package:print_bluetooth_thermal/print_bluetooth_thermal_windows.dart';
// import 'package:print_bluetooth_thermal_example/image.dart';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   String _info = "";
//   String _msj = '';
//   bool connected = false;
//   List<BluetoothInfo> items = [];
//   List<String> _options = ["permission bluetooth granted", "bluetooth enabled", "connection status", "update info"];
//
//   String _selectSize = "2";
//   final _txtText = TextEditingController(text: "Hello developer");
//   bool _progress = false;
//   String _msjprogress = "";
//
//   String optionprinttype = "58 mm";
//   List<String> options = ["58 mm", "80 mm"];
//   late GlobalKey aKey;
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//           actions: [
//           ],
//         ),
//         body: SingleChildScrollView(
//           scrollDirection: Axis.vertical,
//           child: Container(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 WidgetToImage(builder: (GlobalKey<State<StatefulWidget>> key) {
//                   aKey = key;
//                   double width = 260;
//                   return Container(
//                     width: width,
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         Center(
//                           child: Text(
//                             "فاتورة ضريبية",
//                             style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Image.asset("assets/logo.jpg",  width: 125,),
//                         SizedBox(height: 5,),
//                         Text("TRN: 10036 93114 00003",style: TextStyle(fontWeight: FontWeight.w700),),
//                         SizedBox(height: 10,),
//                         Container(
//                           width: width,
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(" Date: "+DateTime.now().toString().split(".")[0]),
//                               SizedBox(height: 5,),
//                               Text(" IN NO: INV6584897564"),
//                               // Text(" Mobile Number: 0562064458"),
//                               // SizedBox(height: 5,),
//                               // Text(" Name of Seller: Badr Aldin Almasri"),
//                               // SizedBox(height: 5,),
//                               // Text(" des: "),
//                             ],
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Container(
//                           width: width,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               for(var i in List.generate(5, (index) => index,))
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(vertical: 4.0),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Text("Iphone "*(i+1)*5,maxLines: 2,overflow: TextOverflow.ellipsis,),
//                                       Text.rich(
//                                         TextSpan(
//                                           children: [
//                                             TextSpan(text: '10'),
//                                             TextSpan(text: '  '),
//                                             TextSpan(
//                                               text: 'X',
//                                               style: TextStyle(fontWeight: FontWeight.bold),
//                                             ),
//                                             TextSpan(text: '  '),
//                                             TextSpan(text: '140 AED'),
//                                           ],
//                                         ),
//                                       ),
//
//                                     ],
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         // Container(
//                         //   color: Colors.grey.shade300,
//                         //   child: Table(
//                         //     columnWidths: {0: FlexColumnWidth(3.5)},
//                         //     children: [
//                         //       TableRow(children: [
//                         //         Text(
//                         //           "Item Name",
//                         //           style: TextStyle(fontWeight: FontWeight.bold),
//                         //         ),
//                         //         Text(
//                         //           " Q",
//                         //           style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
//                         //         ),
//                         //         Text(
//                         //           "Unit",
//                         //           style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
//                         //         ),
//                         //         Text(
//                         //           "VAT",
//                         //           style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
//                         //         ),
//                         //         Text(
//                         //           "Total",
//                         //           style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
//                         //         ),
//                         //       ]),
//                         //     ],
//                         //   ),
//                         // ),
//                         // SizedBox(
//                         //   height: 5,
//                         // ),
//                         // Padding(
//                         //   padding: const EdgeInsets.symmetric(horizontal: 2.0),
//                         //   child: Table(
//                         //     columnWidths: {0: FlexColumnWidth(3.5)},
//                         //     children: [
//                         //       for(String i in List.generate(6, (index) => index.toString(),))
//                         //         TableRow(children: [
//                         //           Padding(
//                         //             padding: const EdgeInsets.symmetric(vertical: 4.0,horizontal: 0),
//                         //             child: Text("Iphone aijhhjdsfkjdsflkdfjk sdfkjhdskjfhkdfh "+i.toString()),
//                         //           ),
//                         //           Text("10"),
//                         //           Text("30"),
//                         //           Text("50"),
//                         //           Text("2000"),
//                         //         ]),
//                         //     ],
//                         //   ),
//                         // ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Container(
//                             height: 2,
//                             color: Colors.black,
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                           child: Row(
//                             children: [
//                               Expanded(flex: 1, child: SizedBox()),
//                               Expanded(
//                                   child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [Text("Net total"), Spacer(), Text("5")],
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [Text("VAT 5.0 %"), Spacer(), Text("5")],
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Container(
//                                     color: Colors.black,
//                                     height: 2,
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         "Total amount",
//                                         style: TextStyle(fontWeight: FontWeight.bold),
//                                       ),
//                                       Spacer(),
//                                       Text("5")
//                                     ],
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Container(
//                                     color: Colors.grey,
//                                     height: 1,
//                                   ),
//                                   SizedBox(
//                                     height: 1,
//                                   ),
//                                   Container(
//                                     color: Colors.grey,
//                                     height: 1,
//                                   ),
//                                 ],
//                               )),
//                             ],
//                           ),
//                         ),
//                         Container(
//                           width: width,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               SizedBox(height: 10,),
//                               Text(
//                                 " Mobile Number: 0568666411",
//                                 style: TextStyle(fontSize: 14, color: Colors.black),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 10,),
//                         Text(
//                           " Thanks for visiting BA3",
//                           style: TextStyle(fontSize: 14, color: Colors.black,fontWeight: FontWeight.bold),
//                         ),
//                         Container(
//                           color: Colors.white,
//                           height: 100,
//                         ),
//                       ],
//                     ),
//                   );
//                 }),
//                 Text('info: $_info\n '),
//                 Text(_msj),
//                 // Row(
//                 //   children: [
//                 //     Text("Type print"),
//                 //     SizedBox(width: 10),
//                 //     DropdownButton<String>(
//                 //       value: optionprinttype,
//                 //       items: options.map((String option) {
//                 //         return DropdownMenuItem<String>(
//                 //           value: option,
//                 //           child: Text(option),
//                 //         );
//                 //       }).toList(),
//                 //       onChanged: (String? newValue) {
//                 //         setState(() {
//                 //           optionprinttype = newValue!;
//                 //         });
//                 //       },
//                 //     ),
//                 //   ],
//                 // ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         this.getBluetoots();
//                       },
//                       child: Row(
//                         children: [
//                           Visibility(
//                             visible: _progress,
//                             child: SizedBox(
//                               width: 25,
//                               height: 25,
//                               child: CircularProgressIndicator.adaptive(strokeWidth: 1, backgroundColor: Colors.white),
//                             ),
//                           ),
//                           SizedBox(width: 5),
//                           Text(_progress ? _msjprogress : "Search"),
//                         ],
//                       ),
//                     ),
//                     ElevatedButton(
//                       onPressed: connected ? this.disconnect : null,
//                       child: Text("Disconnect"),
//                     ),
//                     ElevatedButton(
//                       onPressed: this.printFunction ,
//                       child: Text("Test"),
//                     ),
//                   ],
//                 ),
//                 // Container(
//                 //     height: 200,
//                 //     decoration: BoxDecoration(
//                 //       borderRadius: BorderRadius.all(Radius.circular(10)),
//                 //       color: Colors.grey.withOpacity(0.3),
//                 //     ),
//                 //     child: ListView.builder(
//                 //       itemCount: items.length > 0 ? items.length : 0,
//                 //       itemBuilder: (context, index) {
//                 //         return ListTile(
//                 //           onTap: () {
//                 //             String mac = items[index].macAdress;
//                 //             this.connect(mac);
//                 //           },
//                 //           title: Text('Name: ${items[index].name}'),
//                 //           subtitle: Text("macAddress: ${items[index].macAdress}"),
//                 //         );
//                 //       },
//                 //     )),
//                 // SizedBox(height: 10),
//                 // Container(
//                 //   padding: EdgeInsets.all(10),
//                 //   decoration: BoxDecoration(
//                 //     borderRadius: BorderRadius.all(Radius.circular(10)),
//                 //     color: Colors.grey.withOpacity(0.3),
//                 //   ),
//                 //   child: Column(children: [
//                 //     Text("Text size without the library without external packets, print images still it should not use a library"),
//                 //     SizedBox(height: 10),
//                 //     Row(
//                 //       children: [
//                 //         Expanded(
//                 //           child: TextField(
//                 //             controller: _txtText,
//                 //             decoration: InputDecoration(
//                 //               border: OutlineInputBorder(),
//                 //               labelText: "Text",
//                 //             ),
//                 //           ),
//                 //         ),
//                 //         SizedBox(width: 5),
//                 //         DropdownButton<String>(
//                 //           hint: Text('Size'),
//                 //           value: _selectSize,
//                 //           items: <String>['1', '2', '3', '4', '5'].map((String value) {
//                 //             return DropdownMenuItem<String>(
//                 //               value: value,
//                 //               child: new Text(value),
//                 //             );
//                 //           }).toList(),
//                 //           onChanged: (String? select) {
//                 //             setState(() {
//                 //               _selectSize = select.toString();
//                 //             });
//                 //           },
//                 //         )
//                 //       ],
//                 //     ),
//                 //     ElevatedButton(
//                 //       onPressed: connected ? this.printWithoutPackage : null,
//                 //       child: Text("Print"),
//                 //     ),
//                 //   ]),
//                 // ),
//                 // SizedBox(height: 10),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> printFunction() async {
//     List<BluetoothInfo> allBluetooth = await getBluetoots();
//     print(allBluetooth.map((e) => e.name+"   "+e.macAdress,));
//     if(allBluetooth.map((e) => e.macAdress,).toList().contains("66:32:8D:F3:FF:7E")){
//       await connect("66:32:8D:F3:FF:7E");
//       await printTest();
//       await disconnect();
//     }else{
//       print("Cant find the printer");
//     }
//   }
//
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     int porcentbatery = 0;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       platformVersion = await PrintBluetoothThermal.platformVersion;
//       //print("patformversion: $platformVersion");
//       porcentbatery = await PrintBluetoothThermal.batteryLevel;
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }
//
//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;
//
//     final bool result = await PrintBluetoothThermal.bluetoothEnabled;
//     print("bluetooth enabled: $result");
//     if (result) {
//       _msj = "Bluetooth enabled, please search and connect";
//     } else {
//       _msj = "Bluetooth not enabled";
//     }
//
//     setState(() {
//       _info = platformVersion + " ($porcentbatery% battery)";
//     });
//   }
//
//
//   Future<List<BluetoothInfo>> getBluetoots() async {
//     setState(() {
//       _progress = true;
//       _msjprogress = "Wait";
//       items = [];
//     });
//     final List<BluetoothInfo> listResult = await PrintBluetoothThermal.pairedBluetooths;
//
//     /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
//       String name = bluetooth.name;
//       String mac = bluetooth.macAdress;
//     });*/
//
//     setState(() {
//       _progress = false;
//     });
//
//     if (listResult.length == 0) {
//       _msj = "There are no bluetoohs linked, go to settings and link the printer";
//     } else {
//       _msj = "Touch an item in the list to connect";
//     }
//
//     setState(() {
//       items = listResult;
//     });
//     return items;
//   }
//
//   Future<void> connect(String mac) async {
//     setState(() {
//       _progress = true;
//       _msjprogress = "Connecting...";
//       connected = false;
//     });
//     final bool result = await PrintBluetoothThermal.connect(macPrinterAddress: mac);
//     print("state conected $result");
//     if (result) connected = true;
//     setState(() {
//       _progress = false;
//     });
//   }
//
//   Future<void> disconnect() async {
//     final bool status = await PrintBluetoothThermal.disconnect;
//     setState(() {
//       connected = false;
//     });
//     print("status disconnect $status");
//   }
//
//   Future<void> printTest() async {
//     /*if (kDebugMode) {
//       bool result = await PrintBluetoothThermalWindows.writeBytes(bytes: "Hello \n".codeUnits);
//       return;
//     }*/
//
//     bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
//     //print("connection status: $conexionStatus");
//     if (conexionStatus) {
//       bool result = false;
//       if (Platform.isWindows) {
//         //List<int> ticket = await testWindows();
//         // result = await PrintBluetoothThermalWindows.writeBytes(bytes: ticket);
//       } else {
//         // List<int> ticket = await testImage();
//         List<int> ticket = await testText();
//         result = await PrintBluetoothThermal.writeBytes(ticket);
//       }
//       print("print test result:  $result");
//     } else {
//       print("print test conexionStatus: $conexionStatus");
//       setState(() {
//         disconnect();
//       });
//       //throw Exception("Not device connected");
//     }
//   }
// //
// //   Future<void> printString() async {
// //     bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
// //     if (conexionStatus) {
// //       String enter = '\n';
// //       await PrintBluetoothThermal.writeBytes(enter.codeUnits);
// //       //size of 1-5
// //       String text = "Hello";
// //       await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 1, text: text));
// //       await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 2, text: text + " size 2"));
// //       await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: 3, text: text + " size 3"));
// //     } else {
// //       //desconectado
// //       print("desconectado bluetooth $conexionStatus");
// //     }
// //   }
// //
//   Future<List<int>> testImage() async {
//     List<int> bytes = [];
//     final profile = await CapabilityProfile.load();
//     final generator = Generator(optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
//     bytes += generator.reset();
//     Uint8List? a = await Utils.capture(aKey);
//     bytes += generator.imageRaster(img.decodeImage(a!)!);
//     bytes += generator.feed(2);
//     return bytes;
//   }
//
//   Future<List<int>> testText() async {
//     List<int> bytes = [];
//     // Using default profile
//     final profile = await CapabilityProfile.load();
//     final generator = Generator(optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
//     //bytes += generator.setGlobalFont(PosFontType.fontA);
//     bytes += generator.reset();
//
//     bytes += generator.text('Tax Invoice', styles: PosStyles(align: PosAlign.center),linesAfter: 1);
//
//
//     final ByteData data = await rootBundle.load('assets/logo.jpg');
//     final Uint8List bytesImg = data.buffer.asUint8List();
//     img.Image? image = img.decodeImage(bytesImg);
//    // bytes += generator.imageRaster(image!);
//
//
//     bytes += generator.text("Burj AlArab Mobile Phone", styles: PosStyles(align: PosAlign.center,bold: true));
//     bytes += generator.text("Date: "+DateTime.now().toString().split(".")[0], styles: PosStyles(align: PosAlign.left));
//     bytes += generator.text("IN NO: INV6584897564", styles: PosStyles(align: PosAlign.left),linesAfter: 1);
//
//     for(var i in List.generate(5, (index) => index,)){
//       String text ="Iphone "*(i+1)*5;
//       bytes += generator.text (text.length<64?text:text.substring(0,64), styles: PosStyles(align: PosAlign.left));
//       bytes += generator.text ("000000000000000", styles: PosStyles(align: PosAlign.left));
//       bytes += generator.text('10'+'X'+'140 AED      Total:2000', styles: PosStyles(align: PosAlign.left),linesAfter: 1);
//     }
//
//     bytes += generator.text('-'*30, styles: PosStyles(align: PosAlign.right));
//
//
//
//     bytes += generator.text('Sub: 100', styles: PosStyles(align: PosAlign.right));
//     bytes += generator.text('VAT: 100', styles: PosStyles(align: PosAlign.right));
//     bytes += generator.text('Total: 100', styles: PosStyles(align: PosAlign.right,bold: true));
//     bytes += generator.text("UAE, Rak, Sadaf Roundabout", styles: PosStyles(align: PosAlign.center));
//     bytes += generator.text("0568666411", styles: PosStyles(align: PosAlign.center));
//     bytes += generator.text("Thanks For Visiting BA3", styles: PosStyles(align: PosAlign.center,bold: true));
//     // final file = base64Encode(a!.toList());
//     // print(a.length);
//     // bytes +=  generator.image(decodeImage(a)!);
// // Using `GS v 0` (obsolete)
// // Using `GS ( L`
// //     bytes +=  generator.imageRaster(img.decodeImage(a)!, imageFn: PosImageFn.graphics);
//     //Using `ESC *`
//     //bytes += generator.image(image!);
//     // bytes += generator.text('مرحبا', styles: PosStyles(codeTable: 'WPC1256'));
//     //  const utf8Encoder = Utf8Encoder();
//     //  final encodedStr = utf8Encoder.convert('مرحبا');
//
//     //  generator.textEncoded(Uint8List.fromList([
//
//     //  ]));
//     //  bytes += generator.text('Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
//     // bytes += generator.text('Special 1: ñÑ àÀ èÈ éÉ üÜ çÇ ôÔ', styles: PosStyles(codeTable: 'CP1252'));
//     // bytes += generator.text('Special 2: blåbærgrød', styles: PosStyles(codeTable: 'CP1252'));
//     //
//     // bytes += generator.text('Bold text', styles: PosStyles(bold: true));
//     // bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
//     // bytes += generator.text('Underlined text', styles: PosStyles(underline: true), linesAfter: 1);
//     // bytes += generator.text('Align left', styles: PosStyles(align: PosAlign.left));
//     // bytes += generator.text('Align center', styles: PosStyles(align: PosAlign.center));
//     // bytes += generator.text('Align right', styles: PosStyles(align: PosAlign.right), linesAfter: 1);
//
//     // bytes += generator.row([
//     //   PosColumn(
//     //     text: 'col3',
//     //     width: 3,
//     //     styles: PosStyles(align: PosAlign.center, underline: true),
//     //   ),
//     //   PosColumn(
//     //     text: 'col6',
//     //     width: 6,
//     //     styles: PosStyles(align: PosAlign.center, underline: true),
//     //   ),
//     //   PosColumn(
//     //     text: 'col3',
//     //     width: 3,
//     //     styles: PosStyles(align: PosAlign.center, underline: true),
//     //   ),
//     // ]);
//
//     //barcode
//
//     // final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
//     // bytes += generator.barcode(Barcode.upcA(barData));
//     //
//     // //QR code
//     // bytes += generator.qrcode('example.com');
//     //
//     // bytes += generator.text(
//     //   'Text size 50%',
//     //   styles: PosStyles(
//     //     fontType: PosFontType.fontB,
//     //   ),
//     // );
//     // bytes += generator.text(
//     //   'Text size 100%',
//     //   styles: PosStyles(
//     //     fontType: PosFontType.fontA,
//     //   ),
//     // );
//
//     bytes += generator.feed(2);
//     //bytes += generator.cut();
//     return bytes;
//   }
//
// //   Future<List<int>> testWindows() async {
// //     List<int> bytes = [];
// //
// //     bytes += PostCode.text(text: "Size compressed", fontSize: FontSize.compressed);
// //     bytes += PostCode.text(text: "Size normal", fontSize: FontSize.normal);
// //     bytes += PostCode.text(text: "Bold", bold: true);
// //     bytes += PostCode.text(text: "Inverse", inverse: true);
// //     bytes += PostCode.text(text: "AlignPos right", align: AlignPos.right);
// //     bytes += PostCode.text(text: "Size big", fontSize: FontSize.big);
// //     bytes += PostCode.enter();
// //
// //     //List of rows
// //     bytes += PostCode.row(texts: ["PRODUCT", "VALUE"], proportions: [60, 40], fontSize: FontSize.compressed);
// //     for (int i = 0; i < 3; i++) {
// //       bytes += PostCode.row(texts: ["Item $i", "$i,00"], proportions: [60, 40], fontSize: FontSize.compressed);
// //     }
// //
// //     bytes += PostCode.line();
// //
// //     bytes += PostCode.barcode(barcodeData: "123456789");
// //     bytes += PostCode.qr("123456789");
// //
// //     bytes += PostCode.enter(nEnter: 5);
// //
// //     return bytes;
// //   }
// //
// //   Future<void> printWithoutPackage() async {
// //     //impresion sin paquete solo de PrintBluetoothTermal
// //     bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
// //     if (connectionStatus) {
// //       String text = _txtText.text.toString() + "\n";
// //       bool result = await PrintBluetoothThermal.writeString(printText: PrintTextSize(size: int.parse(_selectSize), text: text));
// //       print("status print result: $result");
// //       setState(() {
// //         _msj = "printed status: $result";
// //       });
// //     } else {
// //       //no conectado, reconecte
// //       setState(() {
// //         _msj = "no connected device";
// //       });
// //       print("no conectado");
// //     }
// //   }
// }
