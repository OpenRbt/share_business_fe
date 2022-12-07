import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:share_buisness_front_end/pages/debit.dart';
import 'package:share_buisness_front_end/pages/login.dart';
import 'package:share_buisness_front_end/pages/profile.dart';
import 'package:share_buisness_front_end/pages/side_menu.dart';

final routes = RouteMap(
    routes: {
      '/': (_) => MaterialPage(child: Login()),
      '/debit': (_) => MaterialPage(child: Debit()),
      '/profile': (_) => MaterialPage(child: Profile()),
      '/side-menu': (_) => MaterialPage(child: SideMenu()),
    }
);

final routemaster = RoutemasterDelegate(
  routesBuilder: (context) => routes,
);

void main() async {
  await Firebase.initializeApp(
    // Replace with actual values
    options: FirebaseOptions(
        apiKey: "AIzaSyBq2HgLyU9y3G68uw_VaTSnxfZpvL8BxIo",
        authDomain: "openwashing.firebaseapp.com",
        projectId: "openwashing",
        storageBucket: "openwashing.appspot.com",
        messagingSenderId: "931729817638",
        appId: "1:931729817638:web:0e6a02d606f0389e1c66e7",
        measurementId: "G-4HD7TZX4BE"
    ),
  );
  runApp(MaterialApp.router(
    routerDelegate: routemaster,
    routeInformationParser: RoutemasterParser(),
    debugShowCheckedModeBanner: false,
  ));
}