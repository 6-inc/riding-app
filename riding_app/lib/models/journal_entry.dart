class JournalEntry {
  final String title;
  final String content;
  final String style;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String horse;

  JournalEntry({
    required this.title,
    required this.content,
    required this.style,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.horse,
  });

  // 他のメソッドやフィールドがある場合はここに追加
}
