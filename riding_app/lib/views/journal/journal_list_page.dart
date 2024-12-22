import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';
import 'package:riding_app/views/journal/journal_detail_page.dart';
import 'package:riding_app/views/journal/journal_style_selection_page.dart';

class JournalListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<JournalService>(
        builder: (context, journalService, child) {
          final entries = journalService.getEntries();
          if (entries.isEmpty) {
            return Center(child: Text('記録がありません'));
          }
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
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
          // 新しいエントリーを追加するためのページに遷移
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalStyleSelectionPage(
                onStyleSelected: (style) {},
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
