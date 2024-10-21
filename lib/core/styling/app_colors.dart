import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';

class AppColors {
  static const Color backGroundColor = Color(0xffE6E6E6);
  static const Color lineColor = Colors.red;
  static const Color indicatorLineColor = Colors.yellow;
  static const Color indicatorTouchedLineColor = Colors.yellow;
  static const Color indicatorTouchedSpotStrokeColor = Colors.black;
  static const Color bottomTextColor = Colors.black;
  static const Color bottomTouchedTextColor = Colors.black;
  static const Color averageLineColor = Colors.green;
  static const Color tooltipBgColor = Colors.grey;
  static const Color tooltipTextColor = Colors.black;
}

final buttonColors = WindowButtonColors(
    iconNormal: const Color(0xFF805306),
    mouseOver: const Color(0xFFF6A00C),
    mouseDown: const Color(0xFF805306),
    iconMouseOver: const Color(0xFF805306),
    iconMouseDown: const Color(0xFFFFD500));

final closeButtonColors = WindowButtonColors(
  mouseOver: const Color(0xFFD32F2F),
  mouseDown: const Color(0xFFB71C1C),
  iconNormal: const Color(0xFF805306),
  iconMouseOver: Colors.white,
);
