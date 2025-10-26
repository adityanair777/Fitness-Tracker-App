import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressScreen extends StatelessWidget {
  // static weekly data for milestone 1
  final List<double> weekData = [2, 3, 4, 5, 3.5, 4, 6];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // chart area (pink)
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(10),
            ),
            child: BarChart(
              BarChartData(
                maxY: 8,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) =>
                          Text(['M','T','W','T','F','S','S'][v.toInt() % 7]),
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
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
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // gray stats box
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('total workouts: 5'),
                Text('calories burned: 1200'),
                Text('goal progress: 80%'),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // purple outline for reminder note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text('next workout: 7:00 am (future reminder)'),
          ),
        ],
      ),
    );
  }
}
