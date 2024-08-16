import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget customTextFieldWithIcon(TextEditingController controller, void Function(String) onSubmitted, {Function()? onIconPressed, void Function(String _)? onChanged,List<TextInputFormatter>? inputFormatters,TextInputType? keyboardType}) {
  return TextFormField(

    // validator: validator,
    onFieldSubmitted: onSubmitted,
    onChanged: onChanged,
    // onSubmitted: onSubmitted,
    controller: controller,
inputFormatters: inputFormatters,
    // onTapOutside: onTapOutside,
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
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
  );
}

Widget customTextFieldWithoutIcon(TextEditingController controller, bool enabled, {void Function(String)? onChanged ,List<TextInputFormatter>? inputFormatters,TextInputType? keyboardType}) {
  return TextFormField(
    onChanged: onChanged,
    enabled: enabled,
    controller: controller,
    keyboardType:keyboardType,
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
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
      contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
      // Center the text vertically
    ),
    textAlign: TextAlign.center,
    // Center the text horizontally
  );
}
