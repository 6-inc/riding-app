import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riding_app/services/journal_service.dart';
import 'package:riding_app/models/horse.dart';
import 'package:provider/provider.dart';
import 'package:riding_app/services/horse_service.dart';

class JournalEditPage extends StatefulWidget {
  final JournalEntry entry;
  const JournalEditPage({super.key, required this.entry});

  @override
  State<JournalEditPage> createState() => _JournalEditPageState();
}

class _JournalEditPageState extends State<JournalEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late TextEditingController _styleController;
  late TextEditingController _locationController;
  late TextEditingController _horseController;
  late DateTime _date;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  Horse? _selectedHorse;

  final List<String> _styles = [
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

  final JournalService journalService = JournalService();

  @override
  void initState() {
    super.initState();
    dotenv.load();
    _titleController = TextEditingController(text: widget.entry.title);
    _contentController = TextEditingController(text: widget.entry.content);
    _styleController = TextEditingController(text: widget.entry.style);
    _locationController = TextEditingController(text: widget.entry.location);
    final horseService = Provider.of<HorseService>(context, listen: false);
    _selectedHorse = horseService.getHorseById(widget.entry.horseId);
    _horseController = TextEditingController(text: _selectedHorse?.name ?? '');
    _date = widget.entry.date;
    _startTime = TimeOfDay.fromDateTime(widget.entry.startTime);
    _endTime = TimeOfDay.fromDateTime(widget.entry.endTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _selectHorse() async {
    // まず、HorseServiceから馬一覧を取得
    final horseService = Provider.of<HorseService>(context, listen: false);
    final horses = await horseService.getAllHorses();
    // ダイアログで一覧表示して選択
    final selectedHorse = await showDialog<Horse>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('馬を選択'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: horses.length,
              itemBuilder: (context, index) {
                final horse = horses[index];
                return ListTile(
                  title: Text(horse.name),
                  onTap: () {
                    Navigator.of(context).pop(horse);
                  },
                );
              },
            ),
          ),
        );
      },
    );
    if (selectedHorse != null) {
      setState(() {
        _selectedHorse = selectedHorse;
        _horseController.text = selectedHorse.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('編集'),
        titleTextStyle: const TextStyle(fontSize: 16),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Style Dropdown Field
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: DropdownButtonFormField<String>(
                    value: _styleController.text,
                    items: _styles.map((String style) {
                      return DropdownMenuItem<String>(
                        value: style,
                        child: Text(style),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _styleController.text = newValue!;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'スタイル',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Date and Time Card
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      // Date Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('yyyy-MM-dd').format(_date),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () => _selectDate(context),
                          ),
                        ],
                      ),
                      // Start Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                '開始: ${_startTime.format(context)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () => _selectTime(context, true),
                          ),
                        ],
                      ),
                      // End Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.access_time,
                                  color: Theme.of(context).colorScheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                '終了: ${_endTime.format(context)}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () => _selectTime(context, false),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Location Field
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: '場所',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Horse Field (selectable from list)
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  onTap: _selectHorse,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _horseController.text.isEmpty
                              ? '馬を選択'
                              : _horseController.text,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Title Field
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'タイトル',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Content Field
              SizedBox(
                height: 200,
                child: Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextField(
                      controller: _contentController,
                      decoration: const InputDecoration(
                        labelText: '内容',
                        alignLabelWithHint: true,
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Save Button
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
                    onPressed: () async {
                      // 判定条件：エントリーIDが null または 0 の場合は新規作成、それ以外は更新
                      if (widget.entry.id == null || widget.entry.id == 0) {
                        // 新規エントリーの場合は追加
                        final newEntry = JournalEntry(
                          title: _titleController.text,
                          content: _contentController.text,
                          style: _styleController.text,
                          date: _date,
                          startTime: DateTime(
                            _date.year,
                            _date.month,
                            _date.day,
                            _startTime.hour,
                            _startTime.minute,
                          ),
                          endTime: DateTime(
                            _date.year,
                            _date.month,
                            _date.day,
                            _endTime.hour,
                            _endTime.minute,
                          ),
                          location: _locationController.text,
                          horseId: _selectedHorse?.id ?? 0,
                        );
                        await Provider.of<JournalService>(context,
                                listen: false)
                            .addEntry(newEntry);
                        Navigator.pop(context, newEntry);
                      } else {
                        // 既存エントリーの場合は更新
                        final updatedEntry = JournalEntry(
                          id: widget.entry.id,
                          title: _titleController.text,
                          content: _contentController.text,
                          style: _styleController.text,
                          date: _date,
                          startTime: DateTime(
                            _date.year,
                            _date.month,
                            _date.day,
                            _startTime.hour,
                            _startTime.minute,
                          ),
                          endTime: DateTime(
                            _date.year,
                            _date.month,
                            _date.day,
                            _endTime.hour,
                            _endTime.minute,
                          ),
                          location: _locationController.text,
                          horseId: _selectedHorse?.id ?? widget.entry.horseId,
                        );
                        await Provider.of<JournalService>(context,
                                listen: false)
                            .updateEntry(updatedEntry);
                        Navigator.pop(context, updatedEntry);
                      }
                    },
                    child: const Text('保存'),
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
