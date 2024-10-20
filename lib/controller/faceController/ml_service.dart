// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// import 'package:ba3_business_solutions/model/user_model.dart';
// import 'package:camera/camera.dart';
// import 'package:get/get.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:tflite_flutter/tflite_flutter.dart';
// import 'package:image/image.dart' as imglib;
//
// import '../../utils/image_converter.dart';
// import '../user_management_controller.dart';
//
//
//
// class MLService extends GetxController{
//   Interpreter? _interpreter;
//   double threshold = 0.5;
//
//   List predictedData = [];
//  // List? get predictedData => _predictedData;
//   MLService(){
//     loadModel();
//   }
//   Future loadModel() async {
//     Delegate? delegate;
//     try {
//       if (Platform.isAndroid) {
//         delegate = GpuDelegateV2(
//             options: GpuDelegateOptionsV2(
//           false,
//           TfLiteGpuInferenceUsage.fastSingleAnswer,
//           TfLiteGpuInferencePriority.minLatency,
//           TfLiteGpuInferencePriority.auto,
//           TfLiteGpuInferencePriority.auto,
//         ));
//       } else if (Platform.isIOS) {
//         delegate = GpuDelegate(
//           options: GpuDelegateOptions(true, TFLGpuDelegateWaitType.active),
//         );
//       }
//       var interpreterOptions = InterpreterOptions()..addDelegate(delegate!);
//
//       _interpreter = await Interpreter.fromAsset('mobilefacenet.tflite', options: interpreterOptions);
//       print('model loaded successfully');
//     } catch (e) {
//       print('Failed to load model.');
//       print(e);
//     }
//   }
//
//   setCurrentPrediction(CameraImage cameraImage, Face face) {
//     List input = _preProcess(cameraImage, face);
//
//     input = input.reshape([1, 112, 112, 3]);
//     List output = List.generate(1, (index) => List.filled(192, 0));
//
//     _interpreter?.run(input, output);
//     output = output.reshape([192]);
//
//     predictedData = List.from(output);
//   }
//
//   Future<bool> predict() async {
//     return _searchResult(predictedData!);
//   }
//
//   List _preProcess(CameraImage image, Face faceDetected) {
//     imglib.Image croppedImage = _cropFace(image, faceDetected);
//     imglib.Image img = imglib.copyResizeCropSquare(croppedImage, 112);
//
//     Float32List imageAsList = imageToByteListFloat32(img);
//     return imageAsList;
//   }
//
//   imglib.Image _cropFace(CameraImage image, Face faceDetected) {
//     imglib.Image convertedImage = _convertCameraImage(image);
//     double x = faceDetected.boundingBox.left - 10.0;
//     double y = faceDetected.boundingBox.top - 10.0;
//     double w = faceDetected.boundingBox.width + 10.0;
//     double h = faceDetected.boundingBox.height + 10.0;
//     return imglib.copyCrop(convertedImage, x.round(), y.round(), w.round(), h.round());
//   }
//
//   imglib.Image _convertCameraImage(CameraImage image) {
//     var img = convertToImage(image);
//     var img1 = imglib.copyRotate(img!, -90);
//     return img1;
//   }
//
//   Float32List imageToByteListFloat32(imglib.Image image) {
//     var convertedBytes = Float32List(1 * 112 * 112 * 3);
//     var buffer = Float32List.view(convertedBytes.buffer);
//     int pixelIndex = 0;
//
//     for (var i = 0; i < 112; i++) {
//       for (var j = 0; j < 112; j++) {
//         var pixel = image.getPixel(j, i);
//         buffer[pixelIndex++] = (imglib.getRed(pixel) - 128) / 128;
//         buffer[pixelIndex++] = (imglib.getGreen(pixel) - 128) / 128;
//         buffer[pixelIndex++] = (imglib.getBlue(pixel) - 128) / 128;
//       }
//     }
//     return convertedBytes.buffer.asFloat32List();
//   }
//
//   Future<bool> _searchResult(List predictedData) async {
//     UserManagementViewModel userManagementViewController = Get.find<UserManagementViewModel>();
//
//     UserModel users = userManagementViewController.myUserModel!;
//
//     double minDist = 999;
//     double currDist = 0.0;
//
//
//       // print(users.userFaceId);
//       // print(predictedData);
//       currDist = _euclideanDistance(users.userFaceId!, predictedData);
//     print("0000000000000000000000");
//     print(currDist);
//     print(minDist);
//     print(threshold);
//     print(currDist <= threshold && currDist < minDist);
//     print("0000000000000000000000");
//      if (currDist <= threshold && currDist < minDist) {
//     // if(currDist>0.95){
//      //   minDist = currDist;
//        // predictedResult = users;
//         return true;
//       }else{
//         return false;
//       }
//
//
//
//   }
//
//   double _euclideanDistance(List? e1, List? e2) {
//     if (e1 == null || e2 == null) throw Exception("Null argument");
//
//     double sum = 0.0;
//     for (int i = 0; i < e1.length; i++) {
//       sum += pow((e1[i] - e2[i]), 2);
//     }
//     return sqrt(sum);
//   }
//
//   void setPredictedData(value) {
//     predictedData = value;
//   }
//
// }
