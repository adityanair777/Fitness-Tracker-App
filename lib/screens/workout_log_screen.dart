import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import 'levels_screen.dart';

class WorkoutLogScreen extends StatefulWidget {
  const WorkoutLogScreen({super.key});

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final exCtrl = TextEditingController();
  final durCtrl = TextEditingController();
  final repCtrl = TextEditingController();
  List<Map<String, dynamic>> _rows = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DBHelper.all(DBHelper.workoutTable);
    setState(() => _rows = data);
  }

  Future<void> _add() async {
    if (exCtrl.text.isEmpty) return;
    final dateString = DateTime.now().toIso8601String();
    await DBHelper.insert(DBHelper.workoutTable, {
      'exercise': exCtrl.text,
      'duration': durCtrl.text,
      'reps': repCtrl.text,
      'date': dateString,
    });
    exCtrl.clear();
    durCtrl.clear();
    repCtrl.clear();
    await _load();
  }

  Future<void> _remove(int id) async {
    await DBHelper.delete(DBHelper.workoutTable, id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text(
                'Workout Log',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink[400],
                ),
              ),
              const SizedBox(height: 20),

              // Levels navigation button
              ElevatedButton.icon(
                icon: const Icon(Icons.fitness_center),
                label: const Text('Preset Levels (Beginner / Intermediate / Advanced)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[300],
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LevelsScreen()),
                  );
                },
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              // Input fields
              TextField(
                controller: exCtrl,
                decoration: const InputDecoration(
                  labelText: 'Exercise Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: durCtrl,
                decoration: const InputDecoration(
                  labelText: 'Duration (mins)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: repCtrl,
                decoration: const InputDecoration(
                  labelText: 'Repetitions',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: _add,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[400],
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text(
                  'Add Workout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),

              // Workout list
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _rows.length,
                itemBuilder: (c, i) {
                  final it = _rows[i];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(it['exercise'] ?? ''),
                      subtitle: Text(
                        'Duration: ${it['duration']} mins | Reps: ${it['reps']}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _remove(it['id'] as int),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
