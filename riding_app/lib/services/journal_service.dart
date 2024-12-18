import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';

class JournalService extends ChangeNotifier {
  List<JournalEntry> _entries = [];

  void addEntry(String title, String content, String style, String horse,
      String location, DateTime startTime, DateTime endTime) {
    _entries.add(JournalEntry(
      title: title,
      content: content,
      style: style,
      horse: horse,
      location: location,
      startTime: startTime,
      endTime: endTime,
    ));
    notifyListeners();
  }

  List<JournalEntry> getEntries() {
    return _entries;
  }
}
