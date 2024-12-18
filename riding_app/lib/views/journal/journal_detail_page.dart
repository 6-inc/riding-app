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
            if (entry.content != null) Text(entry.content!),
            if (entry.style != null) Text('スタイル: ${entry.style}'),
            if (entry.horse != null) Text('馬: ${entry.horse}'),
            if (entry.location != null) Text('場所: ${entry.location}'),
            if (entry.startTime != null) Text('開始時間: ${entry.startTime}'),
            if (entry.endTime != null) Text('終了時間: ${entry.endTime}'),
          ],
        ),
      ),
    );
  }
}
