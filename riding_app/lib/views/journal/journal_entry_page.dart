import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';

class JournalEntryPage extends StatefulWidget {
  final String location;
  final String horse;
  final String style;
  final DateTime startTime;
  final DateTime endTime;
  final Function(String, String) onSave;

  JournalEntryPage({
    required this.location,
    required this.horse,
    required this.style,
    required this.startTime,
    required this.endTime,
    required this.onSave,
  });

  @override
  _JournalEntryPageState createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('エントリー詳細')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEditableField('スタイル', widget.style, () {
              // スタイルの処理を追加
            }),
            _buildEditableField('馬', widget.horse, () {
              // 馬変更の処理を追加
            }),
            _buildEditableField('場所', widget.location, () {
              // 場所変更の処理を追加
            }),
            _buildEditableField('開始時間', widget.startTime.toString(), () {
              // 開始時間変更の処理を追加
            }),
            _buildEditableField('終了時間', widget.endTime.toString(), () {
              // 終了時間変更の処理を追加
            }),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'タイトル'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '内容'),
            ),
            ElevatedButton(
              onPressed: () {
                // JournalServiceを使用してエントリーを追加
                Provider.of<JournalService>(context, listen: false).addEntry(
                  _titleController.text,
                  _contentController.text,
                  widget.style,
                  widget.horse,
                  widget.location,
                  widget.startTime,
                  widget.endTime,
                );
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, String value, VoidCallback onEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$label: $value', style: TextStyle(fontSize: 16)),
        IconButton(
          icon: Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
      ],
    );
  }
}
