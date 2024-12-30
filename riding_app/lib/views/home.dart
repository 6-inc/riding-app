import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/database_helper.dart';
import 'package:riding_app/widget/grid_lines.dart';
import 'package:riding_app/views/journal/journal_list_page.dart';
import 'package:riding_app/widget/app_bar.dart';
import 'package:riding_app/views/horse/horse_list_page.dart';
import 'package:riding_app/services/horse_service.dart';
import 'package:riding_app/services/journal_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<StatefulWidget> createState() => _MyHomePageWidgetState();
}

class _MyHomePageWidgetState extends State<MyHomePage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = <Widget>[
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () async {
                  await Provider.of<DatabaseHelper>(context, listen: false)
                      .resetDatabase();
                  await Provider.of<HorseService>(context, listen: false)
                      .resetHorses();
                  await Provider.of<JournalService>(context, listen: false)
                      .resetEntries();
                  await Provider.of<HorseService>(context, listen: false)
                      .reloadHorses();
                  await Provider.of<JournalService>(context, listen: false)
                      .reloadEntries();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('データベースがリセットされました。')),
                  );
                },
                child: Text('データベースをリセット'),
              ),
            ],
          ),
        ),
      ),
      JournalListPage(),
      HorseListPage(),
    ];

    return Scaffold(
      appBar: CustomAppBar(
          title: _selectedIndex == 0
              ? 'ホーム'
              : _selectedIndex == 1
                  ? '記録'
                  : '馬'),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'ホーム',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: '記録',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.horseHead),
            label: '馬',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
