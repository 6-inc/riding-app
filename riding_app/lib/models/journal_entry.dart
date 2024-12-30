class JournalEntry {
  final String title;
  final String content;
  final String style;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String horse;
  final int? id;

  JournalEntry({
    required this.title,
    required this.content,
    required this.style,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.horse,
    this.id,
  });

  // 他のメソッドやフィールドがある場合はここに追加
}
