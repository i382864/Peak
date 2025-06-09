import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:convert';
import '../models/workout.dart';
import 'generated_workout_screen.dart';

class CustomWorkoutScreen extends StatefulWidget {
  const CustomWorkoutScreen({super.key});

  @override
  State<CustomWorkoutScreen> createState() => _CustomWorkoutScreenState();
}

class _CustomWorkoutScreenState extends State<CustomWorkoutScreen> {
  String selectedLocation = 'Gym';
  String selectedWorkoutType = 'Strength';
  String selectedTime = '60 min';
  String selectedMuscleFocus = 'Full Body';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A1B5D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Custom Workout',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Location'),
            _buildToggleButtons(
              options: const ['Gym', 'Home'],
              selected: selectedLocation,
              onSelected: (value) => setState(() => selectedLocation = value),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Workout Type'),
            _buildToggleButtons(
              options: const ['Strength', 'HIIT', 'Calisthenics', 'Stretching', 'Recovery'],
              selected: selectedWorkoutType,
              onSelected: (value) => setState(() => selectedWorkoutType = value),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Time'),
            _buildToggleButtons(
              options: const ['20 min', '30 min', '40 min', '50 min', '60 min', '90 min'],
              selected: selectedTime,
              onSelected: (value) => setState(() => selectedTime = value),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Muscle Focus'),
            _buildToggleButtons(
              options: const ['Full Body', 'Upper Body', 'Lower Body', 'Back', 'Core'],
              selected: selectedMuscleFocus,
              onSelected: (value) => setState(() => selectedMuscleFocus = value),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white))
                  : ElevatedButton(
                      onPressed: generateWorkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF2A1B5D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create New Session',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> generateWorkout() async {
    setState(() {
      _isLoading = true;
    });

    int numberOfExercises;
    switch (selectedTime) {
      case '20 min':
        numberOfExercises = 3;
        break;
      case '30 min':
        numberOfExercises = 4;
        break;
      case '40 min':
        numberOfExercises = 5;
        break;
      case '50 min':
        numberOfExercises = 6;
        break;
      case '60 min':
        numberOfExercises = 7;
        break;
      case '90 min':
        numberOfExercises = 10;
        break;
      default:
        numberOfExercises = 5; // Default if somehow no time is selected
    }

    String prompt = '''
Genereer een workout sessie in JSON formaat op basis van deze wensen:
- Locatie: $selectedLocation
- Type workout: $selectedWorkoutType
- Duur: $selectedTime
- Spierfocus: $selectedMuscleFocus

De workout moet EEN warming-up oefening, $numberOfExercises hoofd oefeningen, en EEN cool-down oefening bevatten. Zorg ervoor dat de oefeningen passend zijn voor de gekozen locatie, type workout, duur en spierfocus.

Geef ALLEEN de JSON output, ZONDER extra tekst, uitleg of codeblok markers (zoals ```json).

Elke oefening moet de volgende eigenschappen hebben:
- "name": De naam van de oefening (string).
- "type": Het type oefening (string). Dit moet "warm-up", "cool-down" of "main" zijn.
- "sets": Het aantal sets (integer)
- "reps": Het aantal herhalingen per set (string). Dit moet een nummer zijn (bijv. "10") of tekst zoals "AMRAP" of "30 seconden".
- "weight": Het aanbevolen gewicht of "Lichaamsgewicht" (string)
- "description": Duidelijke instructies voor de oefening (string)
- "imageUrl": Een placeholder URL voor een afbeelding van de oefening (string). Gebruik voor nu "https://via.placeholder.com/150"

De JSON structuur moet een enkel object zijn met een "workout" key die een array van oefening objecten bevat, met de warming-up eerst (type "warm-up"), dan de hoofd oefeningen (type "main"), en de cool-down als laatste (type "cool-down"):
{
  "workout": [
    {
      "name": "Warming Up Oefening Naam",
      "type": "warm-up",
      "sets": 1,
      "reps": "5-10",
      "weight": "Lichaamsgewicht",
      "description": "Instructies voor warming up.",
      "imageUrl": "https://via.placeholder.com/150"
    },
    {
      "name": "Hoofd Oefening 1 Naam",
      "type": "main",
      "sets": 3,
      "reps": "10",
      "weight": "20 kg",
      "description": "Instructies voor hoofd oefening 1",
      "imageUrl": "https://via.placeholder.com/150"
    },
    {
      "name": "Cool Down Oefening Naam",
      "type": "cool-down",
      "sets": 1,
      "reps": "30 seconden",
      "weight": "Lichaamsgewicht",
      "description": "Instructies voor cool down.",
      "imageUrl": "https://via.placeholder.com/150"
    }
  ]
}
''';

    try {
      final response = await Gemini.instance.text(prompt);

      if (response != null &&
          response.content != null &&
          response.content!.parts != null &&
          response.content!.parts!.isNotEmpty) {
        final firstPart = response.content!.parts!.first;
        if (firstPart is TextPart) {
          String jsonString = firstPart.text;
          // Remove any markdown code block markers if present
          jsonString = jsonString.replaceAll('```json', '').replaceAll('```', '').trim();

          // --- Added robust parsing for reps field ---
          // This regex looks for "reps": followed by a value that is NOT
          // a quoted string, number, boolean, null, or object/array, and quotes it.
          final RegExp repsRegex = RegExp(r'("reps":\s*)([^"\d\{\[\]tfnal][^,\}]*)([,\}])');
          jsonString = jsonString.replaceAllMapped(repsRegex, (match) {
            // Get the parts: the start ("reps": ), the value (unquoted part), and the end (, or }).
            final String start = match.group(1)!;
            final String value = match.group(2)!.trim(); // Trim whitespace from value
            final String end = match.group(3)!;

            // Return the corrected string with the value quoted.
            // Escape any existing quotes within the value if necessary (though unlikely from AI output).
            final String quotedValue = value.replaceAll('"', '\\"');
            return '$start"$quotedValue"$end';
          });
          // --- End robust parsing ---

          try {
            final Map<String, dynamic> decodedJson = jsonDecode(jsonString);
            final Workout workout = Workout.fromJson(decodedJson);

            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeneratedWorkoutScreen(workout: workout),
              ),
            );
          } catch (e) {
            print('Error parsing JSON: $e');
            if (!mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GeneratedWorkoutScreen(
                  workoutText: 'Fout bij het parsen van de workout data: $e\nOntvangen data: $jsonString',
                ),
              ),
            );
          }
        } else {
          if (!mounted) return;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GeneratedWorkoutScreen(
                workoutText: 'De respons van Gemini bevatte geen tekstuele inhoud.',
              ),
            ),
          );
        }
      } else {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GeneratedWorkoutScreen(
              workoutText: 'Geen bruikbare respons ontvangen van Gemini.',
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GeneratedWorkoutScreen(
            workoutText: 'Fout bij het genereren van de workout: $e',
          ),
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildToggleButtons({
    required List<String> options,
    required String selected,
    required Function(String) onSelected,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = option == selected;
        return InkWell(
          onTap: () => onSelected(option),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              option,
              style: TextStyle(
                color: isSelected ? const Color(0xFF2A1B5D) : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}