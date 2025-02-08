import 'package:flutter/material.dart';

extension BuildContextExt on BuildContext {
  double get deviceHeight => MediaQuery.of(this).size.height;

  double get deviceWidth => MediaQuery.of(this).size.width;
}
