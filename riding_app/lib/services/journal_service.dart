import 'package:riding_app/models/journal_entry.dart';

class JournalService {
  List<JournalEntry> _entries = [];

  void addEntry(String title) {
    _entries.add(JournalEntry(title: title));
  }

  List<JournalEntry> getEntries() {
    return _entries;
  }
}
