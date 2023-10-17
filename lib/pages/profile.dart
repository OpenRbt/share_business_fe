import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';
import 'package:share_buisness_front_end/api_client/api.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';
import 'package:share_buisness_front_end/utils/common.dart';

import '../main.dart';
import '../service/authProvider.dart';
import '../widgetStyles/buttons/button_styles.dart';
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

  Future<void> _refreshProfile() async {
    try{
      wallets = await Common.walletApi!.getWallets(limit: 100, offset: 0);
      organizations?.clear();
      wallets?.forEach((element) {
        organizations?.add(element.organization);
      });
    } on HttpException {
      if (kDebugMode) {
        print("HttpException");
      }
    } catch(e){
      if (kDebugMode) {
        print("OtherException: $e");
      }
    }
    return;
  }

  void _showLoginAlert(BuildContext context) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ошибка'),
        content: const Text('Требуется авторизация'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              routemaster.popUntil((RouteData data) {
                if (data.fullPath == "/") {
                  return true;
                }
                return false;
              });
            },
            style: ButtonStyles.redButton(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    user = authProvider.user;

    return FutureBuilder(
        future: authProvider.firstUser,
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _showLoginAlert(context));
            return Container();
          }

          return Scaffold(
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: MainAppBar(),
              ),
              drawer: SideMenu(sessionID: sessionID),
              body: FutureBuilder<void> (
                future: _refreshProfile(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot){
                  if (snapshot.connectionState == ConnectionState.done){
                    return ListView(
                        children: [
                          Center(
                            child: Column(
                              textDirection: TextDirection.ltr,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
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
                                          (user?.displayName == null || user!.displayName!.isEmpty || user?.displayName == 'null') ?
                                          Container() :
                                          Flexible(
                                            child: Text('Имя: ${user!.displayName}',
                                              style: TextStyles.profileInfoText(),
                                            ),
                                          )
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
                        ]
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
          );
        }
    );
  }
}