import 'package:flutter/material.dart';
import 'package:riding_app/models/journal_entry.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:riding_app/services/journal_service.dart';

class JournalEditPage extends StatefulWidget {
  final JournalEntry entry;
  JournalEditPage({required this.entry});

  @override
  _JournalEditPageState createState() => _JournalEditPageState();
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
  PickResult? selectedPlace;
  static const LatLng _initialPosition = LatLng(35.6895, 139.6917); // 東京

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
    _horseController = TextEditingController(text: widget.entry.horse);
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

  void _pickLocation() async {
    try {
      final apiKey = dotenv.env['GOOGLE_API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('Google API Key is not set');
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlacePicker(
            apiKey: apiKey,
            initialPosition: _initialPosition,
            useCurrentLocation: true,
            onPlacePicked: (result) {
              setState(() {
                selectedPlace = result;
                _locationController.text = result.formattedAddress ?? '';
              });
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } catch (e) {
      print('Error picking location: $e');
      // エラーメッセージをユーザーに表示するなどの処理を追加
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('編集')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
              decoration: InputDecoration(labelText: 'スタイル'),
            ),
            Row(
              children: [
                Text('日付: ${DateFormat('yyyy-MM-dd').format(_date)}'),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            Row(
              children: [
                Text('開始時間: ${_startTime.format(context)}'),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context, true),
                ),
              ],
            ),
            Row(
              children: [
                Text('終了時間: ${_endTime.format(context)}'),
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () => _selectTime(context, false),
                ),
              ],
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: '場所'),
              readOnly: true,
              onTap: _pickLocation,
            ),
            TextField(
              controller: _horseController,
              decoration: InputDecoration(labelText: '馬'),
            ),
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
                final title = _titleController.text.isNotEmpty
                    ? _titleController.text
                    : 'Untitled';
                final content = _contentController.text.isNotEmpty
                    ? _contentController.text
                    : 'No content';
                final style = _styleController.text.isNotEmpty
                    ? _styleController.text
                    : 'Unknown';
                final location = _locationController.text.isNotEmpty
                    ? _locationController.text
                    : 'Unknown location';
                final horse = _horseController.text.isNotEmpty
                    ? _horseController.text
                    : 'Unknown horse';

                journalService.updateEntry(JournalEntry(
                  title: title,
                  content: content,
                  style: style,
                  date: _date,
                  startTime: DateTime(_date.year, _date.month, _date.day,
                      _startTime.hour, _startTime.minute),
                  endTime: DateTime(_date.year, _date.month, _date.day,
                      _endTime.hour, _endTime.minute),
                  location: location,
                  horse: horse,
                ));
                Navigator.pop(context);
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
