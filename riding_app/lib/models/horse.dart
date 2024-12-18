class Horse {
  final String name;
  final String? breed;
  final String? description;
  final DateTime? birthDate;

  Horse({
    required this.name,
    this.breed,
    this.description,
    this.birthDate,
  });
}
