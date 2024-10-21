import 'package:ba3_business_solutions/controller/user/user_management_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_window_close/flutter_window_close.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isExitDialogShowing = false;

  @override
  void initState() {
    super.initState();
    _setupWindowCloseHandler();
  }

  void _setupWindowCloseHandler() {
    FlutterWindowClose.setWindowShouldCloseHandler(() async {
      if (_isExitDialogShowing) return false;

      _isExitDialogShowing = true;
      bool shouldCloseWindow = await _showExitConfirmationDialog();
      _isExitDialogShowing = false;

      return shouldCloseWindow;
    });
  }

  Future<bool> _showExitConfirmationDialog() async {
    bool? shouldExit = await Get.defaultDialog(
      content: const Text('Do you really want to quit?'),
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(result: true);
        },
        child: const Text("YES"),
      ),
      cancel: ElevatedButton(
        onPressed: () {
          Get.back(result: false);
        },
        child: const Text("NO"),
      ),
    );
    return shouldExit ?? false;
  }

  @override
  Widget build(BuildContext context) {
    _checkUserStatus();

    return const Scaffold(
      body: Center(
        child: Text("يتم تسجيل الدخول"), // "Logging in" in Arabic
      ),
    );
  }

  void _checkUserStatus() {
    UserManagementController userManagementController = Get.find<UserManagementController>();
    userManagementController.checkUserStatus();
  }
}
