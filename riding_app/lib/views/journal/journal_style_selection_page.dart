import 'package:flutter/material.dart';
import 'package:riding_app/views/journal/journal_timer_page.dart';

class JournalStyleSelectionPage extends StatelessWidget {
  final Function(String) onStyleSelected;

  JournalStyleSelectionPage({required this.onStyleSelected});

  @override
  Widget build(BuildContext context) {
    final styles = [
      'トレイルライディング',
      '馬場馬術',
      '障害飛越競技',
      'クロスカントリー',
      '耐久乗馬',
      'ウエスタン乗馬',
      '馬上跳び',
      'ポロ',
      '初心者向けレッスン',
      'その他',
    ];

    return Scaffold(
      appBar: AppBar(title: Text('乗馬スタイルを選択')),
      body: ListView.builder(
        itemCount: styles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(styles[index]),
            onTap: () {
              final selectedStyle = styles[index];
              onStyleSelected(selectedStyle);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalTimerPage(
                    style: selectedStyle,
                    onTimeSelected: (start, end) {
                      // 時間選択後の処理
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
