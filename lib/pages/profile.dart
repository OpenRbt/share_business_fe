import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_buisness_front_end/api_client/api.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';
import 'package:share_buisness_front_end/utils/common.dart';

class ProfilePage extends StatefulWidget {

  late String? sessionID;

  ProfilePage({String? sessionID}){
    this.sessionID = sessionID;
  }

  @override
  State<ProfilePage> createState() => _ProfilePageState(sessionID: this.sessionID);
}

class _ProfilePageState extends State<ProfilePage> {

  late String? sessionID;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isSigningIn = false;

  late Timer _profileRefresh;

  _ProfilePageState({String? sessionID}){
    this.sessionID = sessionID;
  }

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

  Future<Session?> _refreshSession() async {
    if(sessionID != null){
      try{
        Future<Session?> session = Common.sessionApi!.getSession(sessionID!);
        return session;
      } on HttpException catch(e){
        print("HttpException");
      } catch(e){
        print("OtherException");
      }
    }
  }

  Future<Profile?> _refreshProfile() async {
    try{
      Future<Profile?> prof = Common.userApi!.getProfile();
      return prof;
    } on HttpException catch(e){
      print("HttpException");
    } catch(e){
      print("OtherException");
    }
  }

  @override
  Widget build(BuildContext context) {
    return user != null ?
    Scaffold(
        appBar: AppBar(
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
        drawer: SideMenu(sessionID: this.sessionID),
        backgroundColor: Colors.white,
        body: FutureBuilder<Profile?> (
          future: _refreshProfile(),
          builder: (BuildContext context, AsyncSnapshot<Profile?> snapshot){
            if (snapshot.hasData){
              return SafeArea(
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
                              Text('ID ' + snapshot.data!.id.toString(),
                                style: TextStyle(
                                  fontSize: 60,
                                  fontFamily: 'RobotoCondensed',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(
                                'Баланс ' + snapshot.data!.balance.toString(),
                                style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: 'RobotoCondensed',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              );
            }
            else if(snapshot.hasError){
              return Container(
                child: Text("Wrong parametrs", style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Roboto',
                  color: Colors.black,
                  decoration: TextDecoration.none,
                )),
              );
            }
            else{
              return Column(
                children: [
                  SizedBox(
                    height: 300.0,
                  ),
                  Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.black,
                      ),
                    ),
                  )
                ],
              );
            }
          },
        )
    )
        :
    Container();
  }
}