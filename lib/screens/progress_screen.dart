import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../data/db_helper.dart';

class ProgressScreen extends StatefulWidget {
  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  Map<String, int> dailyWorkoutCounts = {};
  int totalWorkouts = 0;
  int totalCalories = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final workouts = await DBHelper.all(DBHelper.workoutTable);
    final meals = await DBHelper.all(DBHelper.mealTable);

    totalWorkouts = workouts.length;
    totalCalories = meals.fold<int>(
      0,
      (sum, m) => sum + (int.tryParse(m['calories'] ?? '0') ?? 0),
    );

    final Map<String, int> counts = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0,
    };

    final now = DateTime.now();
    final startOfWeek = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));

    for (final w in workouts) {
      final raw = w['date'];
      if (raw is String) {
        final dt = DateTime.tryParse(raw);
        if (dt != null && !dt.isBefore(startOfWeek)) {
          final key = DateFormat('E').format(dt);
          if (counts.containsKey(key)) counts[key] = counts[key]! + 1;
        }
      }
    }

    setState(() => dailyWorkoutCounts = counts);
  }

  double _weeklyGoalPercent() {
    final done = dailyWorkoutCounts.values.fold(0, (a, b) => a + b);
    return ((done / 5) * 100).clamp(0, 100);
  }

  Color _goalColor(double p) {
    if (p >= 100) return Colors.green;
    if (p >= 50) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final bars = days.map((d) => (dailyWorkoutCounts[d] ?? 0).toDouble()).toList();
    final percent = _weeklyGoalPercent();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(16),
            child: BarChart(
              BarChartData(
                maxY: 5,
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) => Text(days[v.toInt() % 7]),
                    ),
                  ),
                ),
                barGroups: bars.asMap().entries.map((e) {
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
                Text(
                  'Weekly Goal Progress: ${percent.toStringAsFixed(0)}%',
                  style: TextStyle(fontWeight: FontWeight.bold, color: _goalColor(percent)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
