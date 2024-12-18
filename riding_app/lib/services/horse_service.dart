import 'package:flutter/material.dart';
import 'package:riding_app/models/horse.dart';

class HorseService extends ChangeNotifier {
  List<Horse> _horses = [];

  void addHorse(String name) {
    _horses.add(Horse(name: name));
    notifyListeners();
  }

  List<Horse> getHorses() {
    return _horses;
  }
}
