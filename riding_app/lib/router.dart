import 'package:flutter/material.dart';
import 'package:riding_app/views/home.dart';
import 'package:riding_app/views/about.dart';

class RouterClass {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => MyHomePage());
      case '/about':
        return MaterialPageRoute(builder: (context) => AboutPageWidget());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
