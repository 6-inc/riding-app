import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';
import 'journal_style_selection_page.dart'; // スタイル選択ページをインポート

class JournalAddPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('新しい日記を追加')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                // スタイル選択ページに遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JournalStyleSelectionPage(
                      onStyleSelected: (style) {
                        // スタイルが選択された後、エントリーを追加
                        Provider.of<JournalService>(context, listen: false)
                            .addEntry(
                          _titleController.text,
                          _contentController.text,
                          style,
                          '馬', // 馬を適切に設定
                          '場所', // 場所を適切に設定
                          DateTime.now(), // 開始時間を適切に設定
                          DateTime.now(), // 終了時間を適切に設定
                        );
                        Navigator.pop(context); // スタイル選択ページを閉じる
                      },
                    ),
                  ),
                );
              },
              child: Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
