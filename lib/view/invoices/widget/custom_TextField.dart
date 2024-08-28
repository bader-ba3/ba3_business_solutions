import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../Const/const.dart';

Widget customTextFieldWithIcon(TextEditingController controller, void Function(String) onSubmitted, {Function()? onIconPressed, void Function(String _)? onChanged, List<TextInputFormatter>? inputFormatters, TextInputType? keyboardType}) {
  return SizedBox(
    height: Const.constHeightTextField,
    child: TextFormField(
      // validator: validator,
      onFieldSubmitted: onSubmitted,
      onChanged: onChanged,

      // onSubmitted: onSubmitted,
      controller: controller,
      inputFormatters: inputFormatters,
      onTap: () => controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length),

      // onTapOutside: onTapOutside,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        disabledBorder:      UnderlineInputBorder(
      borderSide: const BorderSide(
      color: Colors.white, // Change the border color
        width: 2.0, // Change the border width
      ),
      borderRadius: BorderRadius.circular(5.0), // Adjust border radius
    ),
        border: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black, // Change the border color
            width: 2.0, // Change the border width
          ),
          borderRadius: BorderRadius.circular(5.0), // Adjust border radius
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue, // Change the border color when focused
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        suffixIcon: IconButton(
          onPressed: onIconPressed,
          focusNode: FocusNode(skipTraversal: true),
          icon: const Icon(Icons.search),
        ),
        // Add an icon as a prefix

        contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
        // Center the text vertically
      ),
      textAlign: TextAlign.center,
      // Center the text horizontally
    ),
  );
}

Widget customTextFieldWithoutIcon(TextEditingController controller, bool enabled, {void Function(String)? onChanged, List<TextInputFormatter>? inputFormatters, TextInputType? keyboardType,void Function(String)? onFieldSubmitted}) {
  return SizedBox(
    height: Const.constHeightTextField,
    child: TextFormField(
      onChanged: onChanged,
      enabled: enabled,
      onFieldSubmitted:onFieldSubmitted ,
      controller: controller,
      keyboardType: keyboardType,

      onTap: () => controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length),
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        border: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.black, // Change the border color
            width: 2.0, // Change the border width
          ),
          borderRadius: BorderRadius.circular(5.0), // Adjust border radius
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue, // Change the border color when focused
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 0), // Center the text vertically
      ),
      textAlign: TextAlign.center,
      // Center the text horizontally
    ),
  );
}
