import 'dart:ui';

import 'package:flutter/material.dart';

final double screenWidth = MediaQueryData.fromWindow(window).size.width;
final double screenHeight = MediaQueryData.fromWindow(window).size.height;

final int adaptWidth = 750;

extension intExt on int {
  double get mpx {
    return this.toDouble() * screenWidth / adaptWidth;
  }
}

extension doubleExt on double {
  double get mpx {
    return this * screenWidth / adaptWidth;
  }
}