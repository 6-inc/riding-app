import 'package:flutter/material.dart';
import 'package:riding_app/models/horse.dart';
import 'package:riding_app/database_helper.dart';

class HorseService extends ChangeNotifier {
  List<Horse> _horses = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  HorseService() {
    _loadHorsesFromDatabase();
  }

  Future<void> _loadHorsesFromDatabase() async {
    final horseMaps = await _dbHelper.getHorses();
    _horses = horseMaps
        .map((map) => Horse(
              name: map['name'],
              breed: map['breed'],
              description: null, // データベースに保存されていない場合
              birthDate: null, // データベースに保存されていない場合
            ))
        .toList();
    notifyListeners();
  }

  Future<void> addHorse(String name) async {
    final horse = Horse(name: name);
    _horses.add(horse);
    await _dbHelper.insertHorse({'name': name});
    notifyListeners();
  }

  List<Horse> getHorses() {
    return _horses;
  }
}
