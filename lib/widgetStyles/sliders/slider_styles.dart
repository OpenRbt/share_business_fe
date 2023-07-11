import 'package:flutter/material.dart';

class SliderStyles {

  static SliderThemeData moneyAmountSlider() {
    return const SliderThemeData(
      activeTrackColor: Colors.black,
      inactiveTrackColor: Colors.black,
      thumbColor: Color.fromRGBO(227, 1, 15, 1),
      trackHeight: 3,
      trackShape: RectangularSliderTrackShape(),
      thumbShape: RoundSliderThumbShape(
          enabledThumbRadius: 10),
      valueIndicatorShape:
      RectangularSliderValueIndicatorShape(),
      valueIndicatorColor: Colors.black,
    );
  }
}