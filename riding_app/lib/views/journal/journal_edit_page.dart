import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';

class JournalEditPage extends StatelessWidget {
  final JournalEntry entry;
  final TextEditingController _titleController;

  JournalEditPage({required this.entry})
      : _titleController = TextEditingController(text: entry.title);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Journal Entry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            ElevatedButton(
              onPressed: () {
                // Update entry logic
                Navigator.pop(context);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
