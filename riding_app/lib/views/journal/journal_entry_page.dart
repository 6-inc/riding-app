import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/journal_service.dart';
import 'package:intl/intl.dart';

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
      appBar: AppBar(title: const Text('エントリー詳細')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // 内容が多くなった場合にスクロールできるように
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 4. 各項目ごとに編集ボタン付きの行を表示
              _buildEditableField(
                'スタイル',
                _style,
                _editStyle,
              ),
              _buildEditableField(
                '馬',
                _horse,
                _editHorse,
              ),
              _buildEditableField(
                '場所',
                _location,
                _editLocation,
              ),
              _buildEditableField(
                '開始時間',
                _formatDateTime(_startTime),
                _editStartTime,
              ),
              _buildEditableField(
                '終了時間',
                _formatDateTime(_endTime),
                _editEndTime,
              ),
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
                  Provider.of<JournalService>(context, listen: false).addEntry(
                    _titleController.text,
                    _contentController.text,
                    _style,
                    _horse,
                    _location,
                    _startTime,
                    _endTime,
                  );

                  // 必要があれば、onSave コールバックを呼び出す
                  // widget.onSave(_titleController.text, _contentController.text);

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

  /// 編集行として使う共通ウィジェット
  Widget _buildEditableField(String label, String value, VoidCallback onEdit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Expanded で Text が長くなっても折り返しで表示
        Expanded(
          child: Text(
            '$label: $value',
            style: const TextStyle(fontSize: 16),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: onEdit,
        ),
      ],
    );
  }

  // ------------------------
  // 以下、各種編集
  // ------------------------

  /// スタイルを編集する例
  void _editStyle() async {
    final newStyle = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempStyle = _style;
        return AlertDialog(
          title: const Text('スタイルを編集'),
          content: TextField(
            onChanged: (value) => tempStyle = value,
            controller: TextEditingController(text: _style),
            decoration: const InputDecoration(labelText: 'スタイル'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null), // キャンセル
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, tempStyle), // OK
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
    // ユーザーが何か入力して保存した場合に値を更新
    if (newStyle != null && newStyle.isNotEmpty) {
      setState(() {
        _style = newStyle;
      });
    }
  }

  /// 馬を編集する例
  void _editHorse() async {
    final newHorse = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempHorse = _horse;
        return AlertDialog(
          title: const Text('馬を編集'),
          content: TextField(
            onChanged: (value) => tempHorse = value,
            controller: TextEditingController(text: _horse),
            decoration: const InputDecoration(labelText: '馬'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, tempHorse),
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
    if (newHorse != null && newHorse.isNotEmpty) {
      setState(() {
        _horse = newHorse;
      });
    }
  }

  /// 場所を編集する例
  void _editLocation() async {
    final newLocation = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempLocation = _location;
        return AlertDialog(
          title: const Text('場所を編集'),
          content: TextField(
            onChanged: (value) => tempLocation = value,
            controller: TextEditingController(text: _location),
            decoration: const InputDecoration(labelText: '場所'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, null),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, tempLocation),
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
    if (newLocation != null && newLocation.isNotEmpty) {
      setState(() {
        _location = newLocation;
      });
    }
  }

  /// 開始時間の編集例 (DatePicker + TimePicker)
  void _editStartTime() async {
    // 日付の選択
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _startTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null) return; // キャンセル

    // 時間の選択
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_startTime),
    );
    if (selectedTime == null) return;

    final newDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    setState(() {
      _startTime = newDateTime;
    });
  }

  /// 終了時間の編集例
  void _editEndTime() async {
    // 日付の選択
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _endTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selectedDate == null) return; // キャンセル

    // 時間の選択
    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_endTime),
    );
    if (selectedTime == null) return;

    final newDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );
    setState(() {
      _endTime = newDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy年MM月dd日HH時mm分').format(dateTime);
  }
}
