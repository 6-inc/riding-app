import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'views/home.dart';
import 'router.dart';
import 'models/app_state_model.dart';
import 'services/journal_service.dart';
import 'services/horse_service.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
