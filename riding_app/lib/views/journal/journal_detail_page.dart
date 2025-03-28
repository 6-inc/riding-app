import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:intl/intl.dart';
import 'package:riding_app/views/journal/journal_edit_page.dart';

class JournalDetailPage extends StatelessWidget {
  final JournalEntry entry;

  JournalDetailPage({required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('エントリー詳細'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalEditPage(entry: entry),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('スタイル: ${entry.style}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('タイトル: ${entry.title}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('内容: ${entry.content}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('日付: ${DateFormat('yyyy年MM月dd日').format(entry.date)}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('開始時間: ${DateFormat('HH:mm').format(entry.startTime)}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('終了時間: ${DateFormat('HH:mm').format(entry.endTime)}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('場所: ${entry.location}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('馬: ${entry.horse}', style: const TextStyle(fontSize: 18)),
            ],
          ),
        ),
      ),
    );
  }
}
