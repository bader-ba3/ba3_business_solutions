import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../invoices/widget/custom_Text_field.dart';

class TextForm extends StatelessWidget {
  const TextForm({
    super.key,
    required this.text,
    required this.controller,
    this.onFieldSubmitted,
    this.onChanged,
  });

  final String text;
  final TextEditingController controller;
  final Function(String value)? onFieldSubmitted;
  final Function(String value)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * .45,
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(text)),
          Expanded(
            child: CustomTextFieldWithoutIcon(
              onChanged: onChanged,
              onSubmitted: onFieldSubmitted,
              controller: controller,
              // decoration: InputDecoration.collapsed(hintText: text),
            ),
          ),
        ],
      ),
    );
  }
}
