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
        child: ListView(
          children: [
            DrawerHeader(child: new Text(user!.email.toString()),),
            ListTile(
              title: Text('Профиль'),
              onTap: () {routemaster.push('/profile');},
            ),
            ListTile(
              title: Text('Выход'),
              onTap: () async {
                setState(() {
                  _isSigningOut = true;
                });
                await Authentication.signOut(context: context);
                setState(() {
                  _isSigningOut = false;
                });
                //routemaster.push('/');
              },
            ),
          ],
        )
    );
  }
}
//