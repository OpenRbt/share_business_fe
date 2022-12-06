import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: new Text(''),),
            ListTile(
              title: Text('Профиль'),
              onTap: () {routemaster.push('/profile');},
            ),
            ListTile(
              title: Text('Выход'),
              onTap: () {routemaster.push('/');},
            ),
          ],
        )
    );
  }
}
