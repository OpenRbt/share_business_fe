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
import '../widgetStyles/text/text.dart';
import '../widgets/appBars/main_app_bar.dart';
import '../widgets/progressIndicators/progress_indicators.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? sessionID = "";
  late User? user;

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
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: MainAppBar(),
        ),
        drawer: SideMenu(sessionID: sessionID),
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
                          (user?.displayName == null || user!.displayName!.isEmpty) ? Container():
                          Row(
                            children: [
                              Flexible(
                                child: Text('Имя ${user!.displayName}',
                                style: TextStyles.profileInfoText(),
                              ),)
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Flexible(
                                child: Text('Почта ${user?.email}',
                                  style: TextStyles.profileInfoText(),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                'Баланс ${snapshot.data?.balance ?? "0"}',
                                style: TextStyles.profileInfoText(),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  'Ожидает начисления ${snapshot.data?.balance ?? "0"}',
                                  style: TextStyles.profileInfoText(),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
              );
            }
            else if(snapshot.hasError){
              return Container();
            }
            else{
              return Column(
                children: [
                  const SizedBox(
                    height: 300.0,
                  ),
                  Center(
                    child: ProgressIndicators.black()
                  )
                ],
              );
            }
          },
        )
    ) : Container();
  }
}