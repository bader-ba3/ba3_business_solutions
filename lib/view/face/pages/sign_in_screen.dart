// import 'dart:async';
// import 'dart:io';
// import 'package:ba3_business_solutions/controller/faceController/face_detector_service.dart';
// import 'package:ba3_business_solutions/view/home/home_view.dart';
// import 'package:camera/camera.dart';
// import 'package:get/get.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:flutter/material.dart';
// import 'dart:math' as math;
// import '../../controller/faceController/camera.service.dart';
// import '../../controller/faceController/ml_service.dart';
// import 'widgets/face_painter_widget.dart';
// import 'widgets/camera_header_widget.dart';
//
//
// class SignIn extends StatefulWidget {
//   const SignIn({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   SignInState createState() => SignInState();
// }
//
// class SignInState extends State<SignIn> {
//   CameraService _cameraService = Get.find<CameraService>();
//   FaceDetectorService _faceDetectorService = Get.find<FaceDetectorService>();
//   MLService _mlService = Get.find<MLService>();
//
//   Future? _initializeControllerFuture;
//
//   bool cameraInitializated = false;
//   bool _detectingFaces = false;
//   bool pictureTaked = false;
//
//   // switchs when the user press the camera
//   bool _saving = true;
//   bool _bottomSheetVisible = false;
//
//   String? imagePath;
//   Size? imageSize;
//   Face? faceDetected;
//
//   @override
//   void initState() {
//     super.initState();
//     _start();
//   }
//
//   @override
//   void dispose() {
//     _cameraService.dispose();
//     _mlService.dispose();
//     _faceDetectorService.dispose();
//     super.dispose();
//   }
//
//   _start() async {
//     await availableCameras().then((value) async {
//       var _ = value.firstWhere(
//             (CameraDescription camera) =>
//         camera.lensDirection == CameraLensDirection.front,
//       );
//       _initializeControllerFuture = _cameraService.startService(_);
//       await _initializeControllerFuture;
//     });
//
//
//     setState(() {
//       cameraInitializated = true;
//     });
//
//     _frameFaces();
//   }
//
//   _frameFaces() {
//     imageSize = _cameraService.getImageSize();
//
//     _cameraService.cameraController?.startImageStream((image) async {
//       if (_cameraService.cameraController != null) {
//         if (_detectingFaces) return;
//
//         _detectingFaces = true;
//
//         try {
//           List<Face> faces = await _faceDetectorService.getFacesFromImage(image);
//
//           if (faces != null) {
//             print("1");
//             if (faces.isNotEmpty) {
//               print("2");
//               setState(() {
//                 faceDetected = faces[0];
//                 print(faceDetected?.trackingId);
//                 print("kadsjfsdkjfkjsdf");
//               });
//               _mlService.setCurrentPrediction(image, faceDetected!);
//               var u = await _mlService.predict();
//               // print("-------------");
//               // print(u.user);
//               // print(u.password);
//               // print(u.modelData);
//               // print(u.modelData?.length);
//               // print(u.toMap());
//               // print("-------------");
//
//               if (u) {
//                 print("3");
//                 _cameraService.cameraController?.stopImageStream();
//                 Get.off(()=>HomeView());
//                 //////////////////////////////////////////////////////////////
//                 //Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome(name: u.user!)));
//               } else {
//                 _saving = true;
//               }
//
//               if (_saving) {
//                 _saving = false;
//                 print("get photo");
//                 _mlService.setCurrentPrediction(image, faceDetected!);
//               }
//             } else {
//               setState(() {
//                 faceDetected = null;
//               });
//             }
//           }
//
//           _detectingFaces = false;
//         } catch (e) {
//           print(e);
//           _detectingFaces = false;
//         }
//       }
//     });
//   }
//
//   Future<bool> onShot() async {
//     if (faceDetected == null) {
//       showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             content: Text('No face detected!'),
//           );
//         },
//       );
//
//       return false;
//     } else {
//       _saving = true;
//
//       await Future.delayed(Duration(milliseconds: 500));
//       await _cameraService.cameraController?.stopImageStream();
//       await Future.delayed(Duration(milliseconds: 200));
//       XFile file = await _cameraService.takePicture();
//
//       setState(() {
//         _bottomSheetVisible = true;
//         pictureTaked = true;
//         imagePath = file.path;
//       });
//
//       return true;
//     }
//   }
//
//   _onBackPressed() {
//     Navigator.of(context).pop();
//   }
//
//   _reload() {
//     setState(() {
//       _bottomSheetVisible = false;
//       cameraInitializated = false;
//       pictureTaked = false;
//     });
//     this._start();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     const double mirror = math.pi;
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: Stack(
//         children: [
//           FutureBuilder<void>(
//               future: _initializeControllerFuture,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done) {
//                   if (pictureTaked) {
//                     return Container(
//                       width: width,
//                       height: height,
//                       child: Transform(
//                           alignment: Alignment.center,
//                           child: FittedBox(
//                             fit: BoxFit.cover,
//                             child: Image.file(File(imagePath!)),
//                           ),
//                           transform: Matrix4.rotationY(mirror)),
//                     );
//                   } else {
//                     return Transform.scale(
//                       scale: 1.0,
//                       child: AspectRatio(
//                         aspectRatio: MediaQuery.of(context).size.aspectRatio,
//                         child: OverflowBox(
//                           alignment: Alignment.center,
//                           child: FittedBox(
//                             fit: BoxFit.fitHeight,
//                             child: Container(
//                               width: width,
//                               height: width * _cameraService.cameraController!.value.aspectRatio,
//                               child: Stack(
//                                 fit: StackFit.expand,
//                                 children: <Widget>[
//                                   CameraPreview(_cameraService.cameraController!),
//                                   CustomPaint(
//                                     painter: FacePainter(face: faceDetected, imageSize: imageSize!),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   }
//                 } else {
//                   return Center(child: CircularProgressIndicator());
//                 }
//               }),
//           CameraHeader(
//             "LOGIN",
//             onBackPressed: _onBackPressed,
//           )
//         ],
//       ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//       // floatingActionButton: !_bottomSheetVisible
//       //     ? AuthActionButtonWidget(
//       //         _initializeControllerFuture!,
//       //         onPressed: onShot,
//       //         isLogin: true,
//       //         reload: _reload,
//       //       )
//       //     : Container(),
//     );
//   }
// }
