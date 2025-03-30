import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';
import 'package:riding_app/views/journal/journal_entry_page.dart';
import 'package:riding_app/views/horse/horse_add_page.dart';
import 'dart:io';
import 'package:riding_app/widget/app_bar.dart';
import 'package:riding_app/models/horse.dart';

class JournalHorseSelectionPage extends StatelessWidget {
  final String location;
  final String style;
  final DateTime startTime;
  final DateTime endTime;
  final Function(Horse) onHorseSelected;

  const JournalHorseSelectionPage({
    super.key,
    required this.location,
    required this.style,
    required this.startTime,
    required this.endTime,
    required this.onHorseSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '馬を選択'),
      body: Consumer<HorseService>(
        builder: (context, horseService, child) {
          final horses = horseService.getHorses();
          if (horses.isEmpty) {
            return const Center(child: Text('馬の登録がありません。'));
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
                    onHorseSelected(horse);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JournalEntryPage(
                          location: location,
                          horse: horse,
                          style: style,
                          startTime: startTime,
                          endTime: endTime,
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
                onHorseAdded: (String horseName) {
                  // Horse型のインスタンスを生成
                  Horse horse = Horse(name: horseName);
                  Navigator.pop(context);
                  onHorseSelected(horse);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalEntryPage(
                        location: location,
                        horse: horse,
                        style: style,
                        startTime: startTime,
                        endTime: endTime,
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
