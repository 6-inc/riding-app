import 'package:flutter/material.dart';
import 'package:riding_app/views/journal/journal_timer_page.dart';

class JournalStyleSelectionPage extends StatelessWidget {
  final Function(String) onStyleSelected;

  const JournalStyleSelectionPage({super.key, required this.onStyleSelected});

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
      appBar: AppBar(title: const Text('乗馬スタイルを選択')),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: styles.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final style = styles[index];
            return Card(
              color: Theme.of(context).colorScheme.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  style,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                onTap: () {
                  onStyleSelected(style);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalTimerPage(
                        style: style,
                        onTimeSelected: (start, end) {
                          // 時間選択後の処理
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
