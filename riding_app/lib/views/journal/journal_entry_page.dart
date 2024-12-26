import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';
import 'package:riding_app/models/journal_entry.dart';

class JournalEntryPage extends StatefulWidget {
  final String location;
  final String horse;
  final String style;
  final DateTime startTime;
  final DateTime endTime;
  final Function(String, String) onSave;

  // 既存のコンストラクタ
  const JournalEntryPage({
    Key? key,
    required this.location,
    required this.horse,
    required this.style,
    required this.startTime,
    required this.endTime,
    required this.onSave,
  }) : super(key: key);

  @override
  _JournalEntryPageState createState() => _JournalEntryPageState();
}

class _JournalEntryPageState extends State<JournalEntryPage> {
  // 1. タイトル・内容用のコントローラ
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  // 2. 編集可能な変数を State に保持
  late String _style;
  late String _horse;
  late String _location;
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    // 3. 受け取った初期値を State へコピー
    _style = widget.style;
    _horse = widget.horse;
    _location = widget.location;
    _startTime = widget.startTime;
    _endTime = widget.endTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Icon(Icons.edit)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // 内容が多くなった場合にスクロールできるように
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'タイトル'),
              ),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: '内容'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // 5. 保存ボタン押下時に、State にある最新値を addEntry に渡す
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

                  // メイン画面へ戻る
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
