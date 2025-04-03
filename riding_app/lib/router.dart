import 'package:flutter/material.dart';
import 'package:riding_app/views/home.dart';
import 'package:riding_app/views/about.dart';
import 'package:riding_app/views/horse/horse_detail_page.dart';
import 'package:riding_app/models/horse.dart';

class RouterClass {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => MyHomePage());
      case '/about':
        return MaterialPageRoute(builder: (context) => AboutPageWidget());
      case '/horseDetail':
        final Horse horse = settings.arguments as Horse;
        return MaterialPageRoute(
            builder: (context) => HorseDetailPage(horse: horse));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
