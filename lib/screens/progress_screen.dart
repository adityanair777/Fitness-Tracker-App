import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../data/db_helper.dart';

class ProgressScreen extends StatefulWidget {
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<double> weekData = [0, 0, 0, 0, 0, 0, 0];
  int totalWorkouts = 0;
  int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final workouts = await DBHelper.all(DBHelper.workoutTable);
    final meals = await DBHelper.all(DBHelper.mealTable);

    totalWorkouts = workouts.length;
    totalCalories = 0;

    for (final m in meals) {
      final c = int.tryParse('${m['calories']}') ?? 0;
      totalCalories += c;
    }

    final buckets = List<double>.filled(7, 0);
    for (final w in workouts) {
      final idx = (w['id'] as int) % 7;
      final d = double.tryParse('${w['duration']}') ?? 0.0;
      buckets[idx] += d > 0 ? d : 1;
    }

    setState(() => weekData = buckets);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: BarChart(
              BarChartData(
                maxY: (weekData.fold<double>(0, (a, b) => a > b ? a : b) + 2).clamp(6, 12),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) =>
                          Text(['M', 'T', 'W', 'T', 'F', 'S', 'S'][v.toInt() % 7]),
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: weekData.asMap().entries.map((e) {
                  return BarChartGroupData(
                    x: e.key,
                    barRods: [
                      BarChartRodData(
                        toY: e.value,
                        color: Colors.pink[400],
                        width: 18,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Workouts: $totalWorkouts'),
                Text('Calories Consumed: $totalCalories'),
                const Text('Goal Progress: 80%'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('Next Workout: Placeholder (Teammate Feature)'),
          ),
        ],
      ),
    );
  }
}
