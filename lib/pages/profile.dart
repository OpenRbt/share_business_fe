import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_buisness_front_end/api_client/api.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';
import 'package:share_buisness_front_end/utils/common.dart';

import '../main.dart';

class ProfilePage extends StatefulWidget {

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  User? user = FirebaseAuth.instance.currentUser;
  bool _isSigningIn = false;

  final ValueNotifier<String> _id = ValueNotifier("Loading...");
  final ValueNotifier<String> _balance = ValueNotifier("Loading...");
  late Timer _profileRefresh;

  @override
  void initState() {
    super.initState();
    _refreshProfile();
    _profileRefresh = Timer(const Duration(seconds: 1), _refreshProfile);
  }

  @override
  void dispose() {
    _profileRefresh.cancel();
    super.dispose();
  }

  Future<void> _refreshProfile() async {
    Profile? prof = await Common.userApi!.callGet();
    _id.value = prof?.id ?? "";
    _balance.value = prof?.balance ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return user != null ?
    Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            title: Image.asset(
              "assets/wash_logo.png",
              width: 200,
              height: 200,
            ),
            elevation: 0,
            centerTitle: false,
            shadowColor: Colors.white,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
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
                          ValueListenableBuilder<String>(valueListenable: _id, builder: (context, value, child) {
                            return Text(value,
                              style: TextStyle(
                                fontSize: 35,
                                fontFamily: 'RobotoCondensed',
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          })

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
                          ValueListenableBuilder<String>(valueListenable: _balance, builder: (context, value, child) {
                            return Text(
                              value + ' р.',
                              style: TextStyle(
                                fontSize: 35,
                                fontFamily: 'RobotoCondensed',
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                            );
                          })
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