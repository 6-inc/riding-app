import 'package:flutter/material.dart';
import 'package:riding_app/services/journal_service.dart';
import 'journal_add_page.dart';

class JournalListPage extends StatelessWidget {
  final JournalService _journalService = JournalService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _journalService.getEntries().length,
        itemBuilder: (context, index) {
          final entry = _journalService.getEntries()[index];
          return ListTile(
            title: Text(entry.title),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add entry page navigation logic
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JournalAddPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
