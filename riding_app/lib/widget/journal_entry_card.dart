import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';

class JournalEntryCard extends StatelessWidget {
  final JournalEntry entry;

  JournalEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(entry.title),
      ),
    );
  }
}
