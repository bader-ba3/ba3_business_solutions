// import 'dart:ui';
//
// import 'package:camera/camera.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
//
//
//
//
// class CameraService extends GetxController{
//   CameraController? _cameraController;
//   CameraController? get cameraController => _cameraController;
//
//   CameraDescription? _cameraDescription;
//
//   InputImageRotation? _cameraRotation;
//   InputImageRotation? get cameraRotation => _cameraRotation;
//
//   String? _imagePath;
//   String? get imagePath => _imagePath;
//
//   Future startService(CameraDescription cameraDescription) async {
//     _cameraDescription = cameraDescription;
//     _cameraController = CameraController(
//       _cameraDescription!,
//       ResolutionPreset.low,
//       enableAudio: false,
//     );
//
//     _cameraRotation = rotationIntToImageRotation(
//       _cameraDescription!.sensorOrientation,
//     );
//
//     return _cameraController!.initialize();
//   }
//
//   InputImageRotation rotationIntToImageRotation(int rotation) {
//     switch (rotation) {
//       case 90:
//         return InputImageRotation.Rotation_90deg;
//       case 180:
//         return InputImageRotation.Rotation_180deg;
//       case 270:
//         return InputImageRotation.Rotation_270deg;
//       default:
//         return InputImageRotation.Rotation_0deg;
//     }
//   }
//
//   Future<XFile> takePicture() async {
//     XFile file = await _cameraController!.takePicture();
//     _imagePath = file.path;
//     return file;
//   }
//
//   Size getImageSize() {
//     return Size(
//       _cameraController!.value.previewSize!.height,
//       _cameraController!.value.previewSize!.width,
//     );
//   }
//
//   @override
//   dispose() {
//     _cameraController!.dispose();
//     // super.dispose();
//   }
// }
