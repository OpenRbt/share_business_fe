import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late var id = "1";
  late var balance = "100";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.black,),
        drawer: SideMenu(),
        backgroundColor: Colors.white70,
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text("ID: " + id, style: TextStyle(fontSize: 60)),
                SizedBox(height: 50),
                Text("Баланс: " + balance, style: TextStyle(fontSize: 60)),
              ],
            ),
          )
        )
    );
  }
}
