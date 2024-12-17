import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';
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
                // JournalServiceを使ってエントリーを追加
                Provider.of<JournalService>(context, listen: false)
                    .addEntry(_titleController.text);
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
