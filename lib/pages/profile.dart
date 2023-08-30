import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
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
import '../widgets/userBalance/UserBalanceView.dart';

class ProfilePage extends StatefulWidget {

  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? sessionID = "";
  late auth.User? user;
  late List<Wallet>? wallets = [];
  late List<Organization>? organizations = [];
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

  Future<User?> _refreshProfile() async {
    try{
      Future<User?> prof = Common.userApi!.getCurrentUser();
      print("Before get wallets");
      wallets = await Common.walletApi!.getWallets(body: Pagination(limit: 100, offset: 0));
      print("After get wallets");
      List<String> organizationIds = [];
      wallets?.forEach((element) {
        organizationIds.add((element.organizationId) ?? "");
      });
      organizations = await Common.organizationApi!.getOrganizations(ids: organizationIds);
      return prof;
    } on HttpException {
      if (kDebugMode) {
        print("HttpException");
      }
    } catch(e){
      if (kDebugMode) {
        print("OtherException: $e");
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
        body: FutureBuilder<User?> (
          future: _refreshProfile(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot){
            if (snapshot.hasData){
              return SafeArea(
                  child: Center(
                    child: Column(
                      textDirection: TextDirection.ltr,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        (user?.displayName == null || user!.displayName!.isEmpty) ? Container():
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              margin:  const EdgeInsets.fromLTRB(10, 80, 10, 10),
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text('Имя: ${user!.displayName}',
                                          style: TextStyles.profileInfoText(),
                                        ),)
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text('Почта: ${user?.email}',
                                          style: TextStyles.profileInfoText(),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        const SizedBox(height: 5,),
                        Container(
                          margin:  const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: UserBalanceView(
                              wallets: wallets ?? [],
                              organizations: organizations ?? []
                          ),
                        )
                      ],
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