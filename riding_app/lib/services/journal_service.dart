import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';

class JournalService extends ChangeNotifier {
  List<JournalEntry> _entries = [];

  void addEntry(String title) {
    _entries.add(JournalEntry(title: title));
    notifyListeners();
  }

  List<JournalEntry> getEntries() {
    return _entries;
  }
}
