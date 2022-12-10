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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            titleSpacing: -50,
              //titleSpacing: 220,
              surfaceTintColor: Colors.white,
              leadingWidth: 120,
              leading: Builder(
                builder: (BuildContext context) {
                  return
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.fromLTRB(0, 18, 60, 0),
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          color: Color.fromRGBO(68,68,68, 1),

                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_forward_ios_sharp,
                            ),
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            color: Colors.white,
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                          ),
                        );
                },
              ),
              title: Container(
                height: 32,
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(0, 18, 200, 0),
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                color: Color.fromRGBO(227,1,15, 1),
                child: Center(
                  child: Text('DIA Electronics',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Teko',
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 30
                    ),
                  ),
                )
              ),
              shadowColor: Colors.white,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              iconTheme: IconThemeData(),
          ),
        ),
        drawer: SideMenu(),
        backgroundColor: Colors.white,
        body: SafeArea(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.red,
                      width: 2,
                    ),
                  ),
                  margin:  EdgeInsets.fromLTRB(40, 80, 40, 400),
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text('ID ',
                            style: TextStyle(
                              fontSize: 60,
                              fontFamily: 'RobotoCondensed',
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(1345.toString(),
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'RobotoCondensed',
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          Text(
                              'Баланс ',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'RobotoCondensed',
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            balance.toString() + ' р.',
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: 'RobotoCondensed',
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              )
            )
    )
        : Container();
  }
}
