import 'package:flutter/material.dart';
import 'package:riding_app/models/horse.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:io';
import 'package:riding_app/views/horse/horse_edit_page.dart';
import 'package:riding_app/services/horse_service.dart';
import 'package:provider/provider.dart';

class HorseDetailPage extends StatefulWidget {
  final Horse horse;

  const HorseDetailPage({super.key, required this.horse});

  @override
  _HorseDetailPageState createState() => _HorseDetailPageState();
}

class _HorseDetailPageState extends State<HorseDetailPage> {
  late Horse updatedHorse;

  @override
  void initState() {
    super.initState();
    updatedHorse = widget.horse;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<HorseService>(context, listen: false).loadHorses(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return Consumer<HorseService>(
          builder: (context, horseService, child) {
            updatedHorse =
                ModalRoute.of(context)!.settings.arguments as Horse? ??
                    horseService.getHorses().firstWhere(
                        (h) => h.id == updatedHorse.id,
                        orElse: () => updatedHorse);
            return Scaffold(
              appBar: AppBar(
                title: const FaIcon(FontAwesomeIcons.horseHead),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HorseEditPage(horse: updatedHorse),
                        ),
                      );
                      if (result != null && result is Horse) {
                        setState(() {
                          updatedHorse = result;
                        });
                      }
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (updatedHorse.imageUrl != null &&
                        updatedHorse.imageUrl!.isNotEmpty)
                      Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: FileImage(File(updatedHorse.imageUrl!)),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                    else
                      Center(
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[300],
                          ),
                          child: const Icon(
                            FontAwesomeIcons.horseHead,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    const SizedBox(height: 26),
                    Text('名前: ${updatedHorse.name}',
                        style: TextStyle(fontSize: 18)),
                    if (updatedHorse.breed != null)
                      Text('品種: ${updatedHorse.breed}',
                          style: TextStyle(fontSize: 18)),
                    if (updatedHorse.color != null)
                      Text('毛色: ${updatedHorse.color}',
                          style: TextStyle(fontSize: 18)),
                    if (updatedHorse.birthDate != null)
                      Text(
                          '誕生日: ${DateFormat('yyyy-MM-dd').format(updatedHorse.birthDate!)}',
                          style: TextStyle(fontSize: 18)),
                    if (updatedHorse.description != null)
                      Text('メモ: ${updatedHorse.description}',
                          style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
