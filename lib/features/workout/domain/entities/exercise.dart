class Exercise {
  final int id;
  final String name;
  final String category;
  final int sets;
  final int reps;
  final double defaultWeight;

  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.sets,
    required this.reps,
    required this.defaultWeight,
  });

  Exercise copyWith({
    int? id,
    String? name,
    String? category,
    int? sets,
    int? reps,
    double? defaultWeight,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      defaultWeight: defaultWeight ?? this.defaultWeight,
    );
  }
}
