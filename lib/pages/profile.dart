import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_buisness_front_end/api_client/api.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';
import 'package:share_buisness_front_end/utils/common.dart';

import '../service/authProvider.dart';

class ProfilePage extends StatefulWidget {

  late String? sessionID;

  ProfilePage({super.key, this.sessionID});

  @override
  State<ProfilePage> createState() => _ProfilePageState(sessionID: sessionID);
}

class _ProfilePageState extends State<ProfilePage> {

  late String? sessionID;
  late User? user;

  late Timer _profileRefresh;

  _ProfilePageState({this.sessionID});

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

  Future<Profile?> _refreshProfile() async {
    try{
      Future<Profile?> prof = Common.userApi!.getProfile();
      return prof;
    } on HttpException {
      if (kDebugMode) {
        print("HttpException");
      }
    } catch(e){
      if (kDebugMode) {
        print("OtherException");
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    user = authProvider.user;
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
        drawer: SideMenu(sessionID: sessionID),
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
                      margin:  const EdgeInsets.fromLTRB(40, 80, 40, 400),
                      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                      child: Column(
                        textDirection: TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Text('ID ${snapshot.data!.id}',
                                style: const TextStyle(
                                  fontSize: 60,
                                  fontFamily: 'RobotoCondensed',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Text(
                                'Баланс ${snapshot.data?.balance.toString() ?? "0"}',
                                style: const TextStyle(
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
              return const Text("Wrong parameters", style: TextStyle(
                fontSize: 30,
                fontFamily: 'Roboto',
                color: Colors.black,
                decoration: TextDecoration.none,
              ));
            }
            else{
              return Column(
                children: const [
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
    Container(
    );
  }
}