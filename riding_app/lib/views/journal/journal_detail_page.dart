import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:intl/intl.dart';

class JournalDetailPage extends StatelessWidget {
  final JournalEntry entry;

  JournalDetailPage({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('エントリー詳細')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('スタイル: ${entry.style}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('タイトル: ${entry.title}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('内容: ${entry.content}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('日付: ${DateFormat('yyyy年MM月dd日').format(entry.date)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('開始時間: ${DateFormat('HH:mm').format(entry.startTime)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('終了時間: ${DateFormat('HH:mm').format(entry.endTime)}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('場所: ${entry.location}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('馬: ${entry.horse}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
