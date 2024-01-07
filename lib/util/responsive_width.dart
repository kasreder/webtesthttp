import 'package:flutter/material.dart';

class ResponsiveWidth {
  static double getResponsiveWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1320) {
      return screenWidth * 0.55;
    } else if (screenWidth > 960) {
      return screenWidth * 0.7;
    } else {
      return screenWidth * 0.95;
    }
  }
}
