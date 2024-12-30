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
              id: map['id'],
              name: map['name'] ?? '',
              breed: map['breed'] ?? '',
              description: map['note'] ?? '',
              birthDate: map['birthDate'] != null
                  ? DateTime.tryParse(map['birthDate'])
                  : null,
              color: map['color'] ?? '',
              imageUrl: map['imageUrl'] ?? '',
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
      imageUrl: horseData['imageUrl'],
    );
    _horses.add(horse);
    await _dbHelper.insertHorse(horseData);
    notifyListeners();
    await _loadHorsesFromDatabase();
  }

  List<Horse> getHorses() {
    print('Retrieving horses: $_horses');
    return _horses;
  }

  Future<void> resetHorses() async {
    _horses.clear();
    notifyListeners();
  }

  Future<void> reloadHorses() async {
    await _loadHorsesFromDatabase();
  }

  Future<void> updateHorse(Horse horse) async {
    if (horse.id == null) {
      throw ArgumentError('Horse ID cannot be null for update operation');
    }
    print('Updating horse with ID: \\${horse.id}');
    await _dbHelper.updateHorse({
      'id': horse.id,
      'name': horse.name,
      'breed': horse.breed,
      'note': horse.description,
      'birthDate': horse.birthDate?.toIso8601String(),
      'color': horse.color,
      'imageUrl': horse.imageUrl,
    });
    print('Horse updated: \\${horse.toString()}');
    await _loadHorsesFromDatabase();
    notifyListeners();
  }

  Future<void> loadHorses() async {
    await _loadHorsesFromDatabase();
  }
}
