import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginAppBar extends StatelessWidget {
  const LoginAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        "assets/wash_logo.png",
        width: 200,
        height: 200,
      ),
      shadowColor: Colors.white,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: false,
    );
  }
}
