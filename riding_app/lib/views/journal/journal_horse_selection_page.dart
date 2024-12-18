import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';
import 'package:riding_app/views/journal/journal_entry_page.dart';
import 'package:riding_app/views/horse/horse_add_page.dart';

class JournalHorseSelectionPage extends StatelessWidget {
  final Function(String) onHorseSelected;

  JournalHorseSelectionPage({required this.onHorseSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('馬を選択')),
      body: Consumer<HorseService>(
        builder: (context, horseService, child) {
          return ListView.builder(
            itemCount: horseService.getHorses().length,
            itemBuilder: (context, index) {
              final horse = horseService.getHorses()[index];
              return ListTile(
                title: Text(horse.name),
                onTap: () {
                  onHorseSelected(horse.name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalEntryPage(
                        location: 'Selected Location',
                        horse: horse.name,
                        style: 'Selected Style',
                        startTime: DateTime.now(),
                        endTime: DateTime.now(),
                        onSave: (title, content) {
                          // 保存処理をここに追加
                        },
                      ),
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
            MaterialPageRoute(builder: (context) => HorseAddPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
