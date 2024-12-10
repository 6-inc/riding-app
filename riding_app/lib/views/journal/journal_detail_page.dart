import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';

class JournalDetailPage extends StatelessWidget {
  final JournalEntry entry;

  JournalDetailPage({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Journal Entry')),
      body: Center(
        child: Text(entry.title),
      ),
    );
  }
}
