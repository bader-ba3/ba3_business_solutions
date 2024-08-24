import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

PlutoGridStyleConfig buildGridStyleConfig() {
  return PlutoGridStyleConfig(
    evenRowColor: _getEvenRowColor(),
    columnTextStyle: _getColumnTextStyle(),
    activatedColor: _getActivatedColor(),
    cellTextStyle: _getCellTextStyle(),
    gridPopupBorderRadius: _getBorderRadius(),
    gridBorderRadius: _getBorderRadius(),
  );
}

Color _getEvenRowColor() {
  return Colors.blueAccent.withOpacity(0.5);
}

TextStyle _getColumnTextStyle() {
  return const TextStyle(
    color: Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
}

Color _getActivatedColor() {
  return Colors.white.withOpacity(0.5);
}

TextStyle _getCellTextStyle() {
  return const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
}

BorderRadius _getBorderRadius() {
  return const BorderRadius.all(Radius.circular(15));
}
