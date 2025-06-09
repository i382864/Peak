class Exercise {
  final String name;
  final String type;
  final int sets;
  final String reps;
  final String weight;
  final String imageUrl;
  final String description;

  Exercise({
    required this.name,
    required this.type,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.imageUrl,
    required this.description,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      name: json['name'] as String,
      type: json['type'] as String,
      sets: json['sets'] as int,
      reps: json['reps'].toString(),
      weight: json['weight'] as String,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'type': type,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
} 