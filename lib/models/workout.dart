import 'exercise.dart';

class Workout {
  final List<Exercise> exercises;

  Workout({required this.exercises});

  factory Workout.fromJson(Map<String, dynamic> json) {
    var exercisesList = json['workout'] as List;
    List<Exercise> exercises = exercisesList.map((i) => Exercise.fromJson(i)).toList();
    return Workout(exercises: exercises);
  }

  Map<String, dynamic> toJson() {
    return {
      'workout': exercises.map((e) => e.toJson()).toList(),
    };
  }
} 