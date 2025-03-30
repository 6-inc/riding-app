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
  // DateTimeで開始日時・終了日時を保持するように変更
  DateTime? startDateTime;
  DateTime? endDateTime;
  Duration elapsedTime = Duration.zero;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // 初期状態では開始日時を現在時刻に設定
    startDateTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    // タイマー開始時に開始日時を再設定（ユーザーが変更している可能性があるため）
    setState(() {
      startDateTime = DateTime.now();
    });
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime = DateTime.now().difference(startDateTime!);
      });
    });
  }

  void _stopTimer() {
    setState(() {
      endDateTime = DateTime.now();
      timer?.cancel();
    });
  }

  // 時刻選択：開始か終了かを指定して、現在のDateTimeからTimeOfDayを抽出して編集
  Future<void> _selectTime(bool isStart) async {
    final currentDT = isStart ? startDateTime : (endDateTime ?? DateTime.now());
    final currentTime = TimeOfDay.fromDateTime(currentDT!);
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (pickedTime != null) {
      setState(() {
        if (isStart) {
          startDateTime = DateTime(
            startDateTime!.year,
            startDateTime!.month,
            startDateTime!.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        } else {
          // 終了日時が未設定の場合は、現在の日時をベースにする
          final base = endDateTime ?? DateTime.now();
          endDateTime = DateTime(
            base.year,
            base.month,
            base.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        }
      });
    }
  }

  // 日付選択：開始日時の日付部分（および終了日時がある場合はその日付も）を更新
  Future<void> _selectDate() async {
    final currentDate = startDateTime ?? DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        // 開始日時の新しい日付部分に更新（時刻部分はそのまま）
        final startTime = TimeOfDay.fromDateTime(startDateTime!);
        startDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          startTime.hour,
          startTime.minute,
        );
        // 終了日時がすでにある場合は同じ日付に更新
        if (endDateTime != null) {
          final endTime = TimeOfDay.fromDateTime(endDateTime!);
          endDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            endTime.hour,
            endTime.minute,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    return DateFormat('yyyy年MM月dd日').format(dt);
  }

  String _formatTime(DateTime dt) {
    return DateFormat('HH:mm').format(dt);
  }

  String _formatElapsedTime(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    // 表示用の開始日時。未設定の場合は現在時刻を使用
    final startDT = startDateTime ?? DateTime.now();
    return Scaffold(
      appBar: CustomAppBar(title: widget.style),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 日付選択セクション
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
                        _formatDate(startDT),
                        style: const TextStyle(fontSize: 18),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.calendar_today,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: _selectDate,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // タイマーセクション
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
              // 開始時間セクション
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
                            _formatTime(startDT),
                            style: const TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.access_time,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => _selectTime(true),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 終了時間セクション（終了日時が設定されていれば表示）
              if (endDateTime != null)
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
                              _formatTime(endDateTime!),
                              style: const TextStyle(fontSize: 22),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.access_time,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => _selectTime(false),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              // ボタンセクション
              if (endDateTime == null)
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
              if (endDateTime != null)
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
                        // 保存処理時は、既にDateTime型のstartDateTimeとendDateTimeを使用
                        widget.onTimeSelected(startDateTime!, endDateTime!);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JournalLocationPage(
                              style: widget.style,
                              startTime: startDateTime!,
                              endTime: endDateTime!,
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
}
