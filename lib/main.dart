import 'package:flutter/material.dart';
import 'screens/progress_screen.dart';
import 'screens/workout_log_screen.dart';
import 'screens/calorie_tracker_screen.dart';

void main() {
  runApp(FitnessApp());
}

class FitnessApp extends StatefulWidget {
  @override
  State<FitnessApp> createState() => _FitnessAppState();
}

class _FitnessAppState extends State<FitnessApp> {
  int _index = 0;

  // pages in bottom nav order: progress, workout, calories
  final List<Widget> _pages = [
    ProgressScreen(),
    WorkoutLogScreen(),
    CalorieTrackerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'fitness tracker',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink[300],
          title: Text(
            _index == 0
                ? 'progress tracker'
                : _index == 1
                    ? 'workout log'
                    : 'calorie tracker',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: _pages[_index],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          selectedItemColor: Colors.pink[400],
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'progress',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center),
              label: 'workout',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_dining),
              label: 'calories',
            ),
          ],
        ),
      ),
    );
  }
}
