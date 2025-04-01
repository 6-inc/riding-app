import 'package:flutter/material.dart';
import 'package:riding_app/models/horse.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:riding_app/views/horse/horse_edit_page.dart';
import 'package:riding_app/services/horse_service.dart';
import 'package:provider/provider.dart';

class HorseDetailPage extends StatefulWidget {
  final Horse horse;

  const HorseDetailPage({Key? key, required this.horse}) : super(key: key);

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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Consumer<HorseService>(
          builder: (context, horseService, child) {
            updatedHorse = horseService.getHorses().firstWhere(
                  (h) => h.id == updatedHorse.id,
                  orElse: () => updatedHorse,
                );
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  updatedHorse.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
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
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: updatedHorse.imageUrl != null &&
                                  updatedHorse.imageUrl!.isNotEmpty
                              ? FileImage(File(updatedHorse.imageUrl!))
                              : null,
                          child: (updatedHorse.imageUrl == null ||
                                  updatedHorse.imageUrl!.isEmpty)
                              ? const Text(
                                  'No Image',
                                  style: TextStyle(color: Colors.grey),
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow(
                                  label: '名前', value: updatedHorse.name),
                              const Divider(),
                              if (updatedHorse.breed != null &&
                                  updatedHorse.breed!.isNotEmpty) ...[
                                _buildDetailRow(
                                    label: '品種', value: updatedHorse.breed!),
                                const Divider(),
                              ],
                              if (updatedHorse.color != null &&
                                  updatedHorse.color!.isNotEmpty) ...[
                                _buildDetailRow(
                                    label: '毛色', value: updatedHorse.color!),
                                const Divider(),
                              ],
                              if (updatedHorse.birthDate != null) ...[
                                _buildDetailRow(
                                  label: '誕生日',
                                  value: DateFormat('yyyy-MM-dd')
                                      .format(updatedHorse.birthDate!),
                                ),
                                const Divider(),
                              ],
                              if (updatedHorse.description != null &&
                                  updatedHorse.description!.isNotEmpty) ...[
                                const SizedBox(height: 16),
                                Text(
                                  'メモ',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  updatedHorse.description!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            '$label:',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
