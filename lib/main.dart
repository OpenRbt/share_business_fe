import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:share_buisness_front_end/pages/login.dart';

final routes = RouteMap(
    routes: {
      '/': (_) => MaterialPage(child: Login()),
    }
);

void main() {
  runApp(MaterialApp.router(
    routerDelegate: RoutemasterDelegate(routesBuilder: (context) => routes),
    routeInformationParser: RoutemasterParser(),
  ));
}