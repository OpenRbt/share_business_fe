import 'package:flutter/material.dart';

class ButtonStyles {
  static ButtonStyle standard() {
    return const ButtonStyle();
  }

  static ButtonStyle redButton() {
    return ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        backgroundColor: const MaterialStatePropertyAll<Color>(Color.fromRGBO(227, 1, 15, 1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            )
        )
    );
  }

  static ButtonStyle inactiveRedButton() {
    return ElevatedButton.styleFrom(
      primary: Colors.red.shade200,  // устанавливаем более бледный оттенок красного
      onPrimary: Colors.white,
      minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
    );
  }

  static ButtonStyle whiteButton() {
    return ButtonStyle(
        side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 3, color: Colors.white)),
        backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            )
        )
    );
  }

  static ButtonStyle whiteButtonWithGreyBorder() {
    return ButtonStyle(
        side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 3, color: Colors.white)),
        backgroundColor: const MaterialStatePropertyAll<Color>(Color.fromRGBO(68, 68, 68, 1)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(

              borderRadius: BorderRadius.circular(10),
            )
        )
    );
  }

  static ButtonStyle whiteButtonWithRedBorder() {
    return ButtonStyle(
        side: MaterialStateBorderSide.resolveWith((states) =>
        const BorderSide(
            width: 3,
            color: Color.fromRGBO(227, 1, 15, 1)
        )
        ),
        backgroundColor:
        const MaterialStatePropertyAll<Color>(Colors.white),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(1),
            )
        )
    );
  }
}