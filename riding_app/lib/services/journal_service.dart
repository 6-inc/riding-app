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
              startTime: DateTime.parse(map['startTime']),
              endTime: DateTime.parse(map['endTime']),
              location: map['location'],
              horse: map['horse'],
            ))
        .toList();
    notifyListeners();
  }

  Future<void> addEntry(
      String title,
      String content,
      String style,
      String horse,
      String location,
      DateTime startTime,
      DateTime endTime) async {
    final entry = JournalEntry(
      title: title,
      content: content,
      style: style,
      horse: horse,
      location: location,
      startTime: startTime,
      endTime: endTime,
    );
    _entries.add(entry);
    await _dbHelper.insertJournalEntry({
      'title': title,
      'content': content,
      'style': style,
      'horse': horse,
      'location': location,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
    });
    notifyListeners();
  }

  List<JournalEntry> getEntries() {
    return _entries;
  }
}
