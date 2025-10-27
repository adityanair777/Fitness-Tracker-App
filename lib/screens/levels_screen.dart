import 'package:flutter/material.dart';
import 'level_detail_screen.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[300],
        title: const Text(
          'Workout Levels',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              LevelButton(level: "Beginner", days: 3),
              SizedBox(height: 20),
              LevelButton(level: "Intermediate", days: 4),
              SizedBox(height: 20),
              LevelButton(level: "Advanced", days: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class LevelButton extends StatelessWidget {
  final String level;
  final int days;

  const LevelButton({super.key, required this.level, required this.days});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink[300],
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => LevelDetailScreen(level: level, days: days),
          ),
        );
      },
      child: Text(
        level,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
    );
  }
}
