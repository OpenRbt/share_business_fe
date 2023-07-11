import 'package:flutter/material.dart';

class ProgressIndicators {
  static Widget standard() {
    return const CircularProgressIndicator();
  }

  static Widget black() {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.black,
      ),
    );
  }

}