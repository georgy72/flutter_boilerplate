import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './pages/second_page/second_page.dart';

import 'components/loader.dart';
import 'pages/first_page/first_page.dart';
import 'pages/home_page/home_page.dart';
import 'pages/login_page/login_page.dart';

class Routes {
  static const root = '/';
  static const login = 'login';
  static const firstPage = '/first_page';
  static const secondPage = '/second_page';
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.root:
      return MaterialPageRoute(
        builder: (context) => HomePage(),
        settings: RouteSettings(name: Routes.root),
      );
    case Routes.login:
      return MaterialPageRoute(
        builder: (context) => LoginPage(),
        settings: RouteSettings(name: Routes.login),
      );
    case Routes.firstPage:
      return MaterialPageRoute(
        builder: (context) => FirstPage(),
        settings: RouteSettings(name: Routes.firstPage),
      );
    case Routes.secondPage:
      return MaterialPageRoute(
        builder: (context) => SecondPage(),
        settings: RouteSettings(name: Routes.secondPage),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => CircularSpinner(),
        settings: RouteSettings(name: Routes.login),
      );
  }
}
