import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';
import 'package:riding_app/views/journal/journal_detail_page.dart';
import 'package:riding_app/views/journal/journal_style_selection_page.dart';
import 'package:riding_app/views/journal/journal_add_page.dart';

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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalDetailPage(entry: entry),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalStyleSelectionPage(
                onStyleSelected: (style) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          JournalAddPage(selectedStyle: style),
                    ),
                  );
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
