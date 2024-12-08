import 'package:flutter/material.dart';
import 'views/home.dart';
import 'router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      initialRoute: '/',
      onGenerateRoute: RouterClass.generateRoute,
    );
  }
}
