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
              name: map['name'] ?? '',
              breed: map['breed'] ?? '',
              description: map['note'] ?? '',
              birthDate: map['birthDate'] != null
                  ? DateTime.tryParse(map['birthDate'])
                  : null,
              color: map['color'] ?? '',
            ))
        .toList();
    notifyListeners();
  }

  Future<void> addHorse(Map<String, dynamic> horseData) async {
    final horse = Horse(
      name: horseData['name'],
      breed: horseData['breed'],
      description: horseData['note'],
      birthDate: DateTime.tryParse(horseData['birthDate']),
      color: horseData['color'],
    );
    _horses.add(horse);
    await _dbHelper.insertHorse(horseData);
    notifyListeners();
    await _loadHorsesFromDatabase();
  }

  List<Horse> getHorses() {
    return _horses;
  }

  Future<void> resetHorses() async {
    _horses.clear();
    notifyListeners();
  }

  Future<void> reloadHorses() async {
    await _loadHorsesFromDatabase();
  }
}
