import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_buisness_front_end/widgetStyles/buttons/button_styles.dart';
import 'package:share_buisness_front_end/widgetStyles/text/text.dart';

import '../main.dart';
import '../service/authentication.dart';

class SideMenu extends StatefulWidget {

  late String? sessionID;

  final User? user = FirebaseAuth.instance.currentUser;

  SideMenu({this.sessionID});

  @override
  State<SideMenu> createState() => _SideMenuState(this.user, this.sessionID);
}

class _SideMenuState extends State<SideMenu> {

  late String? sessionID;
  late User? user;
  bool _isSigningOut = false;

  _SideMenuState(this.user, this.sessionID);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30)),
      ),
      backgroundColor: const Color.fromRGBO(68, 68, 68, 1),
        child:
        Column(
          children: [
            Container(
            height: 32,
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.fromLTRB(85, 18, 85, 0),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
            child: Image.asset("assets/wash_logo.png", width: 200, height: 200,),
        ),
            const SizedBox(height: 100,),
            SizedBox(
              height: 100,
              width: 200,
              child: ElevatedButton(
                style: ButtonStyles.whiteButtonWithGreyBorder(),
                onPressed: () {routemaster.push('/profile');},
                child: Text('Перейти в профиль',
                  style: TextStyles.profileText(),
                ),
              ),
            ),
            const SizedBox(height: 40,),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ButtonStyles.whiteButton(),
                onPressed: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    _isSigningOut = false;
                  });
                },
                child: Text('Выйти',
                  style: TextStyles.exitText(),
                ),
              ),
            )
          ],
        )
    );
  }
}
//