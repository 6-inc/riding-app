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
  DateTime? startTime;
  DateTime? endTime;
  Duration elapsedTime = Duration.zero;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      startTime = DateTime.now();
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime = DateTime.now().difference(startTime!);
      });
    });
  }

  void _stopTimer() {
    setState(() {
      endTime = DateTime.now();
      timer?.cancel();
    });
  }

  Future<void> _selectDateTime(BuildContext context, bool isStartTime) async {
    final initialDateTime = isStartTime ? startTime : endTime;
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: initialDateTime != null
            ? TimeOfDay.fromDateTime(initialDateTime)
            : TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          final selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          if (isStartTime) {
            startTime = selectedDateTime;
          } else {
            endTime = selectedDateTime;
          }
        });
      }
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
              'スタイル: ${widget.style}',
              style: TextStyle(fontSize: 18),
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
                    '開始時間: ${_formatDateTime(startTime!)}',
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
                    '終了時間: ${_formatDateTime(endTime!)}',
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
                  widget.onTimeSelected(startTime!, endTime!);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalLocationPage(
                        style: widget.style,
                        startTime: startTime!,
                        endTime: endTime!,
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

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy年MM月dd日HH時mm分ss秒').format(dateTime);
  }
}
