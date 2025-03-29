import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:riding_app/widget/app_bar.dart';

class JournalEntryPage extends StatefulWidget {
  final String location;
  final String horse;
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
  late String _horse;
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
        // Allows scrolling if content overflows
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // Title input field in a Card
            Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 4), // reduced vertical padding
                child: TextField(
                  controller: _titleController,
                  textAlign: TextAlign.start,
                  decoration: const InputDecoration(
                    labelText: 'タイトル',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Content input field in a Card with a fixed height
            SizedBox(
              height: 200, // fixed height for the content text box
              child: Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8), // reduced vertical padding
                  child: TextField(
                    controller: _contentController,
                    decoration: const InputDecoration(
                      labelText: '今回の乗馬はどうでしたか？',
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    // Removed expands property so that the height remains fixed
                    textAlignVertical: TextAlignVertical.top,
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
                  onPressed: () {
                    final newEntry = JournalEntry(
                      title: _titleController.text,
                      content: _contentController.text,
                      style: _style,
                      date: _startTime,
                      startTime: _startTime,
                      endTime: _endTime,
                      location: _location,
                      horse: _horse,
                    );
                    Provider.of<JournalService>(context, listen: false)
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
