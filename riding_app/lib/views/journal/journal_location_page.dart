import 'package:flutter/material.dart';
import 'package:riding_app/views/journal/journal_horse_selection_page.dart';
import 'package:riding_app/widget/app_bar.dart';

class JournalLocationPage extends StatefulWidget {
  final String style;
  final DateTime startTime;
  final DateTime endTime;
  final Function(String) onLocationSelected;

  const JournalLocationPage({
    Key? key,
    required this.style,
    required this.startTime,
    required this.endTime,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  State<JournalLocationPage> createState() => _JournalLocationPageState();
}

class _JournalLocationPageState extends State<JournalLocationPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToHorseSelection(String location) {
    widget.onLocationSelected(location);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalHorseSelectionPage(
          location: location,
          style: widget.style,
          onHorseSelected: (horse) {
            // 馬の選択後の処理
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'ロケーション'),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // コンテンツの高さに合わせるため、Column の mainAxisSize を min に設定
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 場所入力欄（手動入力）
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: '場所を入力してください',
                    prefixIcon: const Icon(Icons.location_on),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // 「次へ」ボタン
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
                      _navigateToHorseSelection(_searchController.text);
                    },
                    child: const Text('次へ'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
