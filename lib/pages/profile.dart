import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';

import '../main.dart';

class Profile extends StatefulWidget {

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  late Timer _everySecond;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isSigningIn = false;
  late var id = "1";
  late var balance = "100";
  //late Timer _everySecond;


  @override
  void initState() {
    super.initState();

    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        user =  FirebaseAuth.instance.currentUser;
        if(user == null){
          routemaster.push('/');
        }
      });
    });
  }

  @override
  void dispose() {
    _everySecond.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return user != null ?
    Scaffold(
        appBar: AppBar(
          title: Text(''),
          backgroundColor: Colors.black,),
        drawer: SideMenu(),
        backgroundColor: Colors.white70,
        body: SafeArea(
            child: Center(
              child: Column(
                children: [
                  Text("ID: " + user!.email.toString(), style: TextStyle(fontSize: 60)),
                  SizedBox(height: 50),
                  Text("Баланс: " + balance, style: TextStyle(fontSize: 60)),
                ],
              ),
            )
        )
    )
        : Container();
  }
}
