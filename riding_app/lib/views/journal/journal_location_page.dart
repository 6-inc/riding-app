import 'package:flutter/material.dart';
import 'package:riding_app/views/journal/journal_horse_selection_page.dart';

class JournalLocationPage extends StatelessWidget {
  final Function(String) onLocationSelected;

  JournalLocationPage({required this.onLocationSelected});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _locationController = TextEditingController();

    void _navigateToHorseSelection(String location) {
      onLocationSelected(location);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => JournalHorseSelectionPage(
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
              child: Text('保存'),
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
