import 'package:flutter/material.dart';
import 'package:riding_app/models/horse.dart';
import 'package:riding_app/widget/app_bar.dart';
import 'package:intl/intl.dart';

class HorseDetailPage extends StatelessWidget {
  final Horse horse;

  const HorseDetailPage({super.key, required this.horse});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: horse.name),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('名前: ${horse.name}', style: TextStyle(fontSize: 18)),
            if (horse.breed != null)
              Text('品種: ${horse.breed}', style: TextStyle(fontSize: 18)),
            if (horse.color != null)
              Text('毛色: ${horse.color}', style: TextStyle(fontSize: 18)),
            if (horse.birthDate != null)
              Text('誕生日: ${DateFormat('yyyy-MM-dd').format(horse.birthDate!)}',
                  style: TextStyle(fontSize: 18)),
            if (horse.description != null)
              Text('メモ: ${horse.description}', style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
