class Horse {
  final String name;
  final String? breed;
  final String? description;
  final DateTime? birthDate;
  final String? color;
  final String? imageUrl;

  Horse({
    required this.name,
    this.breed,
    this.description,
    this.birthDate,
    this.color,
    this.imageUrl,
  });
}
