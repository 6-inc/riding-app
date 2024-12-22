import 'package:flutter/material.dart';
import 'dart:async';
import 'package:riding_app/views/journal/journal_location_page.dart';
import 'package:intl/intl.dart';

class JournalTimerPage extends StatefulWidget {
  final String style;
  final Function(DateTime, DateTime) onTimeSelected;

  JournalTimerPage({
    required this.style,
    required this.onTimeSelected,
  });

  @override
  _JournalTimerPageState createState() => _JournalTimerPageState();
}

class _JournalTimerPageState extends State<JournalTimerPage> {
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? startDate;
  String? endDate;
  Duration elapsedTime = Duration.zero;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
    startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  void _startTimer() {
    setState(() {
      startTime = TimeOfDay.now();
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final now = DateTime.now();
        elapsedTime = Duration(
          hours: now.hour - startTime!.hour,
          minutes: now.minute - startTime!.minute,
          seconds: now.second,
        );
      });
    });
  }

  void _stopTimer() {
    setState(() {
      endTime = TimeOfDay.now();
      endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      timer?.cancel();
    });
  }

  void _selectDateTime(BuildContext context, bool isStartTime) async {
    final initialDateTime = isStartTime ? startTime : endTime;
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialDateTime != null ? initialDateTime : TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          startTime = pickedTime;
        } else {
          endTime = pickedTime;
        }
      });
    }
  }

  void _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        startDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('タイマー')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.style,
              style: TextStyle(fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '日付: ${_formatDate(startDate!)}',
                  style: TextStyle(fontSize: 18),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            Text(
              _formatElapsedTime(elapsedTime),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            if (startTime != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '開始時間: ${_formatTime(startTime!)}',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _selectDateTime(context, true),
                  ),
                ],
              ),
            if (endTime != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '終了時間: ${_formatTime(endTime!)}',
                    style: TextStyle(fontSize: 18),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _selectDateTime(context, false),
                  ),
                ],
              ),
            if (endTime == null)
              ElevatedButton(
                onPressed: _stopTimer,
                child: Text('終了'),
              ),
            if (endTime != null)
              ElevatedButton(
                onPressed: () {
                  widget.onTimeSelected(
                      DateTime.parse(startDate!), DateTime.parse(endDate!));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalLocationPage(
                        style: widget.style,
                        startTime: DateTime.parse(startDate!),
                        endTime: DateTime.parse(endDate!),
                        onLocationSelected: (location) {
                          // ロケーション選択後の処理
                        },
                      ),
                    ),
                  );
                },
                child: Text('次へ'),
              ),
          ],
        ),
      ),
    );
  }

  String _formatElapsedTime(Duration elapsedTime) {
    final hours = elapsedTime.inHours.toString().padLeft(2, '0');
    final minutes = (elapsedTime.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (elapsedTime.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(String date) {
    return DateFormat('yyyy年MM月dd日').format(DateTime.parse(date));
  }
}
