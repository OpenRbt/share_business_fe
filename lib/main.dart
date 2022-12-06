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

void main() {
  runApp(MaterialApp.router(
    routerDelegate: routemaster,
    routeInformationParser: RoutemasterParser(),
    debugShowCheckedModeBanner: false,
  ));
}