class Horse {
  final String name;
  final String? breed;
  final String? description;
  final DateTime? birthDate;
  final String? color;

  Horse({
    required this.name,
    this.breed,
    this.description,
    this.birthDate,
    this.color,
  });
}
