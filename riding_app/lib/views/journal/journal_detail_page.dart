import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:riding_app/views/journal/journal_edit_page.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';
import 'dart:io';

class JournalDetailPage extends StatelessWidget {
  final JournalEntry entry;

  const JournalDetailPage({super.key, required this.entry});

  // Detail row: label and value in a row with colored label
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.blue, // Label color
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Formatters for date and time
    final dateFormatter = DateFormat('yyyy年MM月dd日');
    final timeFormatter = DateFormat('HH:mm');

    // 馬の情報を取得
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
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Using Card without an overridden background so it uses default styling.
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
                  // Header: Title and Horse Image/Name
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
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
                      // Horse Image and Name
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
                            onBackgroundImageError: (exception, stackTrace) {
                              print('画像の読み込みに失敗しました: $exception');
                            },
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
                  // Content Section
                  const Text(
                    '内容',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    entry.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  // Date, Time, Location, and Style Section
                  _buildDetailRow('日付', dateFormatter.format(entry.date)),
                  _buildDetailRow('開始時間', startTimeString),
                  _buildDetailRow('終了時間', endTimeString),
                  _buildDetailRow('場所', entry.location),
                  _buildDetailRow('スタイル', entry.style),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
