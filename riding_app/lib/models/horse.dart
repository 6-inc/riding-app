class Horse {
  final String name;
  final String? breed;
  final String? description;
  final DateTime? birthDate;
  final String? color;
  final String? imageUrl;
  final int? id;

  Horse({
    required this.name,
    this.breed,
    this.description,
    this.birthDate,
    this.color,
    this.imageUrl,
    this.id,
  });

  @override
  String toString() {
    return 'Horse{id: $id, name: $name, breed: $breed, description: $description, birthDate: $birthDate, color: $color, imageUrl: $imageUrl}';
  }
}
