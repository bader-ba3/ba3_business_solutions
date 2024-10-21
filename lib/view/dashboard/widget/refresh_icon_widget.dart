import 'package:flutter/material.dart';

import '../../../controller/account/account_controller.dart';

class RefreshIconWidget extends StatelessWidget {
  const RefreshIconWidget({super.key, required this.accountController});

  final AccountController accountController;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          accountController.onRefresh();
        },
        icon: const Icon(Icons.refresh));
  }
}
