import 'package:flutter/material.dart';

class LevelDetailScreen extends StatelessWidget {
  final String level;
  final int days;

  const LevelDetailScreen({
    super.key,
    required this.level,
    required this.days,
  });

  List<Map<String, dynamic>> _generateWorkouts() {
    final workouts = [
      ["Push-ups", "Squats", "Sit-ups"],
      ["Jumping Jacks", "Lunges", "Mountain Climbers"],
      ["Plank", "Burpees", "Crunches"],
      ["Pull-ups", "High Knees", "Russian Twists"],
      ["Dips", "Calf Raises", "Bicycle Crunches"]
    ];

    return List.generate(
      days,
      (i) => {
        "day": "Day ${i + 1}",
        "exercises": workouts[i % workouts.length],
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final workouts = _generateWorkouts();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: Text(
          level,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Center(
              child: Text(
                "Week 1",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: workouts.length,
        itemBuilder: (context, index) {
          final w = workouts[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    w["day"],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...w["exercises"].map<Widget>(
                    (ex) => Text(
                      "• $ex",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
