class Player {
  final String name;
  String? role;
  String? word;
  int votes = 0;

  Player({
    required this.name,
    this.role,
    this.word,
  });
} 