import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                style: ButtonStyle(
                    side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 3, color: Colors.white)),
                    backgroundColor: const MaterialStatePropertyAll<Color>(Color.fromRGBO(68, 68, 68, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(10),
                        )
                    )
                ),
                onPressed: () {routemaster.push('/profile');},
                child: const Text('Перейти в профиль',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'RobotoCondensed',
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40,),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ButtonStyle(
                    side: MaterialStateBorderSide.resolveWith((states) => const BorderSide(width: 3, color: Colors.white)),
                    backgroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(1),
                        )
                    )
                ),
                onPressed: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    _isSigningOut = false;
                  });
                },
                child: const Text('Выйти',
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'RobotoCondensed',
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),),
              ),
            )
          ],
        )
    );
  }
}
//