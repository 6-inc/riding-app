class JournalEntry {
  final String title;
  final String? content;
  final String? style;
  final String? horse;
  final String? location;
  final DateTime? startTime;
  final DateTime? endTime;

  JournalEntry({
    required this.title,
    this.content,
    this.style,
    this.horse,
    this.location,
    this.startTime,
    this.endTime,
  });
}
