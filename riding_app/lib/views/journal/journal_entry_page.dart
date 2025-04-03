import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:riding_app/widget/app_bar.dart';
import 'package:riding_app/models/horse.dart';

class JournalEntryPage extends StatefulWidget {
  final String location;
  final Horse horse;
  final String style;
  final DateTime startTime;
  final DateTime endTime;
  final Function(String, String) onSave;

  const JournalEntryPage({
    super.key,
    required this.location,
    required this.horse,
    required this.style,
    required this.startTime,
    required this.endTime,
    required this.onSave,
  });

  @override
  JournalEntryPageState createState() => JournalEntryPageState();
}

class JournalEntryPageState extends State<JournalEntryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  late String _style;
  late Horse _horse;
  late String _location;
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _style = widget.style;
    _horse = widget.horse;
    _location = widget.location;
    _startTime = widget.startTime;
    _endTime = widget.endTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: '記録'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'タイトル',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: '今回の乗馬はどうでしたか？',
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (_horse.id == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('選択された馬が無効です')),
                      );
                      return;
                    }

                    final newEntry = JournalEntry(
                      title: _titleController.text,
                      content: _contentController.text,
                      style: _style,
                      date: _startTime,
                      startTime: _startTime,
                      endTime: _endTime,
                      location: _location,
                      horseId: _horse.id!, // 修正箇所：正しくHorseのidを渡す
                    );

                    await Provider.of<JournalService>(context, listen: false)
                        .addEntry(newEntry);

                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  },
                  child: const Text('保存'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
