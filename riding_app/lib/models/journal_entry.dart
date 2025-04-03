class JournalEntry {
  int? id;
  final String title;
  final String content;
  final String style;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final int horseId;
  final String? horseImageUrl;

  JournalEntry({
    this.id,
    required this.title,
    required this.content,
    required this.style,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.horseId,
    this.horseImageUrl,
  });

  // 他のメソッドやフィールドがある場合はここに追加
}
