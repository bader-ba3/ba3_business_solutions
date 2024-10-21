import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class LoginHeaderText extends StatelessWidget {
  const LoginHeaderText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Center(
            child: Text(
          "Ba3 Business Solutions",
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
        )),
        Center(
            child: Text(
          "تسجيل الدخول الى ${AppConstants.dataName}",
          style: const TextStyle(fontSize: 33, fontWeight: FontWeight.bold),
        )),
      ],
    );
  }
}
