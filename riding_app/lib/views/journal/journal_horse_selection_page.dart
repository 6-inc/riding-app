import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';
import 'package:riding_app/views/journal/journal_entry_page.dart';
import 'package:riding_app/views/horse/horse_add_page.dart';
import 'dart:io';

class JournalHorseSelectionPage extends StatelessWidget {
  final String location;
  final String style;
  final Function(String) onHorseSelected;

  JournalHorseSelectionPage({
    required this.location,
    required this.style,
    required this.onHorseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('馬を選択')),
      body: Consumer<HorseService>(
        builder: (context, horseService, child) {
          final horses = horseService.getHorses();
          if (horses.isEmpty) {
            return Center(child: Text('馬の登録がありません。'));
          }
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: horses.length,
            itemBuilder: (context, index) {
              final horse = horses[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    onHorseSelected(horse.name);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JournalEntryPage(
                          location: location,
                          horse: horse.name,
                          style: style,
                          startTime: DateTime.now(),
                          endTime: DateTime.now(),
                          onSave: (title, content) {
                            // 保存処理をここに追加
                          },
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            horse.imageUrl != null && horse.imageUrl!.isNotEmpty
                                ? FileImage(File(horse.imageUrl!))
                                : const AssetImage('assets/images/icon.png')
                                    as ImageProvider,
                        onBackgroundImageError: (exception, stackTrace) {
                          print('Error loading image: $exception');
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        horse.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HorseAddPage(
                onHorseAdded: (horseName) {
                  // 馬が追加された後にリストを更新
                  Navigator.pop(context);
                  onHorseSelected(horseName);
                  // 追加した馬を選択してエントリー詳細画面に遷移
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalEntryPage(
                        location: location,
                        horse: horseName,
                        style: style,
                        startTime: DateTime.now(),
                        endTime: DateTime.now(),
                        onSave: (title, content) {
                          // 保存処理をここに追加
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ).then((_) {
            // 戻ってきたときにリストを更新
            Provider.of<HorseService>(context, listen: false).reloadHorses();
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
