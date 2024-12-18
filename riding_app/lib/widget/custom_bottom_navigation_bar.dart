import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: currentIndex,
      onTap: onTap,
    );
  }
}
