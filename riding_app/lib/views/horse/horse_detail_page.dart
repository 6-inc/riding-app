import 'package:flutter/material.dart';
import 'package:riding_app/models/horse.dart';
import 'package:riding_app/widget/app_bar.dart';

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
          children: [Text(horse.name)],
        ),
      ),
    );
  }
}
