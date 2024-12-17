import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';
import 'journal_add_page.dart';

class JournalListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JournalService>(
        builder: (context, journalService, child) {
          return ListView.builder(
            itemCount: journalService.getEntries().length,
            itemBuilder: (context, index) {
              final entry = journalService.getEntries()[index];
              return ListTile(
                title: Text(entry.title),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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
