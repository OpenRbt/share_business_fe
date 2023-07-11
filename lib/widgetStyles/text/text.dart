import 'package:flutter/material.dart';

class TextStyles {
  static TextStyle standard () {
    return const TextStyle();
  }

  static TextStyle profileInfoText() {
    return const TextStyle(
      fontSize: 40,
      fontFamily: 'RobotoCondensed',
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle profileText() {
    return const TextStyle(
      fontSize: 30,
      fontFamily: 'RobotoCondensed',
      color: Colors.white,
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle exitText() {
    return const TextStyle(
      fontSize: 25,
      fontFamily: 'RobotoCondensed',
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle postText () {
    return const TextStyle(
      fontSize: 24,
      fontFamily: 'Roboto',
      color: Colors.black,
    );
  }

  static TextStyle enterText () {
    return const TextStyle(
      fontSize: 22,
      fontFamily: 'RobotoCondensed',
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle additionalText () {
    return const TextStyle(
      fontSize: 22,
      fontFamily: 'RobotoCondensed',
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle balanceText () {
    return const TextStyle(
      fontSize: 18,
      fontFamily: 'Roboto',
      color: Colors.black,
    );
  }

  static TextStyle withdrawText () {
    return const TextStyle(
      fontSize: 18,
      fontFamily: 'RobotoCondensed',
      color: Colors.white,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle cancelText () {
    return const TextStyle(
      fontSize: 18,
      fontFamily: 'RobotoCondensed',
      color: Colors.black,
      fontWeight: FontWeight.w700,
    );
  }

  static TextStyle infoText () {
    return const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline,
    );
  }

}