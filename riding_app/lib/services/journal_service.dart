import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:riding_app/database_helper.dart';

class JournalService extends ChangeNotifier {
  List<JournalEntry> _entries = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  JournalService() {
    _loadEntriesFromDatabase();
  }

  Future<void> _loadEntriesFromDatabase() async {
    final entryMaps = await _dbHelper.getJournalEntries();
    _entries = entryMaps
        .map((map) => JournalEntry(
              title: map['title'],
              content: map['content'],
              style: map['style'],
              date: DateTime.parse(map['date']),
              startTime: DateTime.parse(map['startTime']),
              endTime: DateTime.parse(map['endTime']),
              location: map['location'],
              horse: map['horse'],
            ))
        .toList();
    notifyListeners();
  }

  Future<void> addEntry(JournalEntry entry) async {
    _entries.add(entry);
    await _dbHelper.insertJournalEntry({
      'title': entry.title,
      'content': entry.content,
      'style': entry.style,
      'date': entry.date.toIso8601String(),
      'startTime': entry.startTime.toIso8601String(),
      'endTime': entry.endTime.toIso8601String(),
      'location': entry.location,
      'horse': entry.horse,
    });
    notifyListeners();
  }

  List<JournalEntry> getEntries() {
    return _entries;
  }

  Future<void> resetEntries() async {
    _entries.clear();
    notifyListeners();
  }

  Future<void> reloadEntries() async {
    await _loadEntriesFromDatabase();
  }
}
