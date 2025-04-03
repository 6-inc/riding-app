import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:riding_app/views/journal/journal_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';
import 'dart:io';

class JournalDetailPage extends StatefulWidget {
  final JournalEntry entry;

  const JournalDetailPage({Key? key, required this.entry}) : super(key: key);

  @override
  _JournalDetailPageState createState() => _JournalDetailPageState();
}

class _JournalDetailPageState extends State<JournalDetailPage> {
  late JournalEntry entry;

  @override
  void initState() {
    super.initState();
    entry = widget.entry;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy年MM月dd日');
    final timeFormatter = DateFormat('HH:mm');

    // 馬情報の取得（更新があれば最新の情報を反映させる）
    final horse = Provider.of<HorseService>(context, listen: false)
        .getHorseById(entry.horseId);
    final startTimeString = timeFormatter.format(entry.startTime.toLocal());
    final endTimeString = timeFormatter.format(entry.endTime.toLocal());

    return Scaffold(
      appBar: AppBar(
        title: const Text('エントリー詳細', style: TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              // 編集画面へ遷移し、戻り値として更新済みエントリーを受け取る
              final updatedEntry = await Navigator.push<JournalEntry>(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalEditPage(entry: entry),
                ),
              );
              if (updatedEntry != null) {
                setState(() {
                  entry = updatedEntry;
                });
              }
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ヘッダー：タイトルと馬の画像・名前
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          entry.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: (horse != null &&
                                    horse.imageUrl != null &&
                                    horse.imageUrl!.isNotEmpty)
                                ? FileImage(File(horse.imageUrl!))
                                : null,
                            child: (horse == null ||
                                    horse.imageUrl == null ||
                                    horse.imageUrl!.isEmpty)
                                ? const Icon(
                                    FontAwesomeIcons.horseHead,
                                    size: 30,
                                  )
                                : null,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            horse?.name ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // コンテンツ
                  Text(
                    entry.content,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  // 日付＆時間セクション
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            dateFormatter.format(entry.date),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.access_time,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            '$startTimeString - $endTimeString',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // 場所セクション
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          entry.location,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // スタイルセクション
                  Row(
                    children: [
                      Icon(Icons.style,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          entry.style,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
