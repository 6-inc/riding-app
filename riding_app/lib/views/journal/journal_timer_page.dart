import 'package:flutter/material.dart';
import 'dart:async';
import 'package:riding_app/views/journal/journal_location_page.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:riding_app/widget/app_bar.dart';

class JournalTimerPage extends StatefulWidget {
  final String style;
  final Function(DateTime, DateTime) onTimeSelected;

  const JournalTimerPage({
    super.key,
    required this.style,
    required this.onTimeSelected,
  });

  @override
  State<JournalTimerPage> createState() => _JournalTimerPageState();
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
      initialTime: initialDateTime ?? TimeOfDay.now(),
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
      appBar: CustomAppBar(title: widget.style),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 日付セクション
              Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDate(startDate!),
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => _selectDate(context),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // タイマーセクション（背景なし）
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 10.0,
                    percent: elapsedTime.inSeconds / 3600.0 > 1
                        ? 1
                        : elapsedTime.inSeconds / 3600.0,
                    center: Text(
                      _formatElapsedTime(elapsedTime),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    progressColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 開始時間セクション（編集可能なので背景あり）
              if (startTime != null)
                Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '開始時間',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(startTime!),
                              style: const TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.access_time,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _selectDateTime(context, true),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // 終了時間セクション（編集可能なので背景あり）
              if (endTime != null)
                Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '終了時間',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatTime(endTime!),
                              style: const TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.access_time,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _selectDateTime(context, false),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // ボタンセクション
              if (endTime == null)
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onPressed: _stopTimer,
                      child: const Text('乗馬終了'),
                    ),
                  ),
                ),
              if (endTime != null)
                Center(
                  child: SizedBox(
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        widget.onTimeSelected(DateTime.parse(startDate!),
                            DateTime.parse(endDate!));
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
