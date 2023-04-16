import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:share_buisness_front_end/api_client/api.dart';
import 'package:share_buisness_front_end/pages/debit.dart';
import 'package:share_buisness_front_end/pages/login.dart';
import 'package:share_buisness_front_end/pages/profile.dart';
import 'package:share_buisness_front_end/utils/common.dart';
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
  await Firebase.initializeApp(

    options: const FirebaseOptions(
        apiKey: jsonData['apiKey'],
        apiKey: jsonData['authDomain'],
        apiKey:jsonData['projectId'],
        apiKey: jsonData['storageBucket'],
        apiKey: jsonData['messagingSenderId'],
        apiKey: jsonData['appId'],
        apiKey: jsonData['measurementId']
    ),
  );

  Common.userApi = UserApi(ApiClient(basePath: 'http://app.openwashing.com:8071', authentication: HttpBearerAuth()));
  Common.sessionApi = SessionApi(ApiClient(basePath: 'http://app.openwashing.com:8071', authentication: HttpBearerAuth()));
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