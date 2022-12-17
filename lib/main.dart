import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:share_buisness_front_end/api_client/api.dart';
import 'package:share_buisness_front_end/pages/debit.dart';
import 'package:share_buisness_front_end/pages/login.dart';
import 'package:share_buisness_front_end/pages/profile.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';
import 'package:share_buisness_front_end/utils/common.dart';

final routes = RouteMap(
    routes: {
      '/': (_) => MaterialPage(child: Login()),
      '/debit': (_) => MaterialPage(child: Debit()),
      '/profile': (_) => MaterialPage(child: ProfilePage()),
    }
);

final routemaster = RoutemasterDelegate(
  routesBuilder: (context) => routes,
);

void main() async {
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
        apiKey: jsonData['apiKey'],
        apiKey: jsonData['authDomain'],
        apiKey:jsonData['projectId'],
        apiKey: jsonData['storageBucket'],
        apiKey: jsonData['messagingSenderId'],
        apiKey: jsonData['appId'],
        apiKey: jsonData['measurementId']
    ),
  );

  Common.userApi = UserApi(ApiClient(basePath: 'http://localhost:8080', authentication: HttpBearerAuth()));
  Common.sessionApi = SessionApi(ApiClient(basePath: 'http://localhost:8080', authentication: HttpBearerAuth()));
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
  runApp(MaterialApp.router(
    routerDelegate: routemaster,
    routeInformationParser: RoutemasterParser(),
    debugShowCheckedModeBanner: false,
  ));
}