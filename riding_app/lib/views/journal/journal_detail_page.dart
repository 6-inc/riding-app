import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:riding_app/widget/app_bar.dart';

class JournalDetailPage extends StatelessWidget {
  final JournalEntry entry;

  const JournalDetailPage({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: entry.title),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            // 他の詳細情報をここに追加
          ],
        ),
      ),
    );
  }
}
