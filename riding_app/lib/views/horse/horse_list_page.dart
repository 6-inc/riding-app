import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';
import 'horse_detail_page.dart';
import 'horse_add_page.dart';
import 'dart:io';

class HorseListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Provider.of<HorseService>(context, listen: false).loadHorses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Consumer<HorseService>(
            builder: (context, horseService, child) {
              final horses = horseService.getHorses();
              if (horses.isEmpty) {
                return const Center(
                  child: Text('馬が登録されていません。'),
                );
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HorseDetailPage(horse: horse),
                          ),
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: horse.imageUrl != null &&
                                    horse.imageUrl!.isNotEmpty
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
