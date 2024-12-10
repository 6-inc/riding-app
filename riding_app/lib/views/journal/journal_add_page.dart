import 'package:flutter/material.dart';
import 'package:riding_app/widget/app_bar.dart';

class JournalAddPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '記録する'),
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
                // Add entry logic
                Navigator.pop(context);
              },
              child: Text('Add Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
