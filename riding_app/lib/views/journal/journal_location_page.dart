import 'package:flutter/material.dart';
import 'package:riding_app/views/journal/journal_horse_selection_page.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:riding_app/services/journal_service.dart';
import 'package:provider/provider.dart';

class JournalLocationPage extends StatelessWidget {
  final String style;
  final DateTime startTime;
  final DateTime endTime;
  final Function(String) onLocationSelected;

  JournalLocationPage({
    required this.style,
    required this.startTime,
    required this.endTime,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController _locationController = TextEditingController();

    void _navigateToHorseSelection(String location) {
      onLocationSelected(location);
      final journalEntry = JournalEntry(
        title: 'Your Title Here',
        content: 'Your Content Here',
        style: style,
        startTime: startTime,
        endTime: endTime,
        location: location,
        horse: '', // 馬の情報は後で追加
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JournalHorseSelectionPage(
            location: location,
            style: style,
            onHorseSelected: (horse) {
              // 馬の選択後の処理を追加
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('場所を入力')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: '場所'),
            ),
            ElevatedButton(
              onPressed: () {
                _navigateToHorseSelection(_locationController.text);
              },
              child: Text('次へ'),
            ),
            ElevatedButton(
              onPressed: () {
                _navigateToHorseSelection('Location Skipped');
              },
              child: Text('スキップ'),
            ),
          ],
        ),
      ),
    );
  }
}
