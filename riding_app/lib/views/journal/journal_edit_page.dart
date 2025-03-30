import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riding_app/services/journal_service.dart';
import 'dart:developer';
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
    _horseController = TextEditingController(
        text: Provider.of<HorseService>(context, listen: false)
                .getHorseById(widget.entry.horseId)
                ?.name ??
            '');
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

  void _updateEntry() {
    if (widget.entry.id == null) {
      log('エントリーIDがnullです。更新操作を実行できません。');
      return;
    }

    final horse = Horse(
      name: _horseController.text,
    );

    journalService.updateEntry(JournalEntry(
      id: widget.entry.id,
      title: _titleController.text,
      content: _contentController.text,
      style: _styleController.text,
      date: _date,
      startTime: DateTime(_date.year, _date.month, _date.day, _startTime.hour,
          _startTime.minute),
      endTime: DateTime(
          _date.year, _date.month, _date.day, _endTime.hour, _endTime.minute),
      location: _locationController.text,
      horseId: horse.id!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('編集')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
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
                decoration: const InputDecoration(labelText: 'スタイル'),
              ),
              Row(
                children: [
                  Text('日付: ${DateFormat('yyyy-MM-dd').format(_date)}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('開始時間: ${_startTime.format(context)}'),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectTime(context, true),
                  ),
                ],
              ),
              Row(
                children: [
                  Text('終了時間: ${_endTime.format(context)}'),
                  IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () => _selectTime(context, false),
                  ),
                ],
              ),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: '場所'),
                readOnly: false,
              ),
              TextField(
                controller: _horseController,
                decoration: const InputDecoration(labelText: '馬'),
              ),
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'タイトル'),
              ),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: '内容'),
              ),
              ElevatedButton(
                onPressed: _updateEntry,
                child: const Text('保存'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
