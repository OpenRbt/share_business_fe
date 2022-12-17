import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import '../service/authentication.dart';

class SideMenu extends StatefulWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  State<SideMenu> createState() => _SideMenuState(this.user);
}

class _SideMenuState extends State<SideMenu> {

  late User? user;
  bool _isSigningOut = false;

  _SideMenuState(User? user){
    this.user = user;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30)),
      ),
      backgroundColor: Color.fromRGBO(68, 68, 68, 1),
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
            SizedBox(height: 100,),
            SizedBox(
              height: 100,
              width: 200,
              child: ElevatedButton(
                style: ButtonStyle(
                    side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 3, color: Colors.white)),
                    backgroundColor: MaterialStatePropertyAll<Color>(Color.fromRGBO(68, 68, 68, 1)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(

                          borderRadius: BorderRadius.circular(10),
                        )
                    )
                ),
                onPressed: () {routemaster.push('/profile');},
                child: Text('Перейти в профиль',
                  style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'RobotoCondensed',
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40,),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ButtonStyle(
                    side: MaterialStateBorderSide.resolveWith((states) => BorderSide(width: 3, color: Colors.white)),
                    backgroundColor: MaterialStatePropertyAll<Color>(Colors.white),
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
                  //routemaster.push('/');
                },
                child: Text('Выйти',
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