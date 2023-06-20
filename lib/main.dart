import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:routemaster/routemaster.dart';
import 'package:share_buisness_front_end/api_client/api.dart';
import 'package:share_buisness_front_end/pages/debit.dart';
import 'package:share_buisness_front_end/pages/login.dart';
import 'package:share_buisness_front_end/pages/profile.dart';
import 'package:share_buisness_front_end/utils/common.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'service/authProvider.dart';

final routes = RouteMap(
    routes: {
      '/': (route) => MaterialPage(child: Login(sessionID: route.queryParameters['sessionID'])),
      '/debit': (route) => MaterialPage(child: Debit(sessionID: route.queryParameters['sessionID'])),
      '/profile': (route) => MaterialPage(child: ProfilePage(sessionID: route.queryParameters['sessionID'])),
    }
);

final routemaster = RoutemasterDelegate(
  routesBuilder: (context) => routes,
);

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  final String response = await rootBundle.loadString('assets/keys.json');
  Map<String, dynamic> jsonData = json.decode(response);
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: jsonData['apiKey'],
        authDomain: jsonData['authDomain'],
        projectId: jsonData['projectId'],
        storageBucket: jsonData['storageBucket'],
        messagingSenderId: jsonData['messagingSenderId'],
        appId: jsonData['appId'],
        measurementId: jsonData['measurementId']
    ),
  );

  LocalStorage storage = LocalStorage('share_business');
  await storage.ready;

  Common.userApi = UserApi(ApiClient(authentication: HttpBearerAuth()));
  Common.sessionApi = SessionApi(ApiClient(authentication: HttpBearerAuth()));


  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      routemaster.popUntil((RouteData data) {
        if (data.fullPath == "/") {
          return true;
        }
        return false;
      });
    }
  });

  FirebaseAuth.instance.idTokenChanges().listen((User? user) async {
    if (user == null) {
      Common.SetAuthToken("");
    } else {
      Common.SetAuthToken(await user.getIdToken());
    }
  });

  runApp(
      ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        child: MaterialApp.router(
          title: "DIA Electronics",
          routerDelegate: routemaster,
          routeInformationParser: const RoutemasterParser(),
          debugShowCheckedModeBanner: false,
        ),
      ),);
}