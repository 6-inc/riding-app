import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/theme.dart';
import 'package:riding_app/views/home.dart';
import 'package:riding_app/router.dart';
import 'package:riding_app/models/app_state_model.dart';
import 'package:riding_app/services/journal_service.dart';
import 'package:riding_app/services/horse_service.dart';
import 'package:riding_app/database_helper.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await dotenv.load(fileName: ".env");

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) {
    FlutterNativeSplash.remove();
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AppState()),
          ChangeNotifierProvider(create: (context) => JournalService()),
          ChangeNotifierProvider(create: (context) => HorseService()),
          Provider(create: (context) => DatabaseHelper()),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: MaterialTheme.lightScheme().toColorScheme(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: MaterialTheme.darkScheme().toColorScheme(),
      ),
      themeMode: ThemeMode.system,
      home: const MyHomePage(),
      initialRoute: '/',
      onGenerateRoute: RouterClass.generateRoute,
    );
  }
}
