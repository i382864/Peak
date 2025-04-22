import 'package:flutter/material.dart';

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
              child: ElevatedButton(
                onPressed: () {
                  // Handle create session
                },
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