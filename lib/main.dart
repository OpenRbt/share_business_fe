import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart' as auth;
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
      '/': (route) => const MaterialPage(child: Login()),
      '/debit': (route) => const MaterialPage(child: Debit()),
      '/profile': (route) => const MaterialPage(child: ProfilePage()),
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

  Common.initializeApis('https://dev.openwashing.com/api');

  auth.FirebaseAuth.instance.authStateChanges().listen((auth.User? user) {
    if (user == null) {
      routemaster.popUntil((RouteData data) {
        if (data.fullPath == "/") {
          return true;
        }
        return false;
      });
    }
  });

  auth.FirebaseAuth.instance.idTokenChanges().listen((auth.User? user) async {
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
          theme: ThemeData(
            brightness: Brightness.light,
            primaryColor: Colors.white
          ),
          darkTheme: ThemeData(
              brightness: Brightness.light,
              primaryColorDark: Colors.white
          ),
          themeMode: ThemeMode.system,
          routeInformationParser: const RoutemasterParser(),
          debugShowCheckedModeBanner: false,
        ),
      ),
  );
}