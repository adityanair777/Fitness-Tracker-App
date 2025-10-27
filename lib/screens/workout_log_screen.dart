import 'package:flutter/material.dart';
import '../data/db_helper.dart';

class WorkoutLogScreen extends StatefulWidget {
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
    await DBHelper.insert(DBHelper.workoutTable, {
      'exercise': exCtrl.text,
      'duration': durCtrl.text,
      'reps': repCtrl.text,
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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(controller: exCtrl, decoration: const InputDecoration(labelText: 'Exercise Type')),
          TextField(controller: durCtrl, decoration: const InputDecoration(labelText: 'Duration (mins)'), keyboardType: TextInputType.number),
          TextField(controller: repCtrl, decoration: const InputDecoration(labelText: 'Repetitions'), keyboardType: TextInputType.number),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _add,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[300]),
            child: const Text('Add Workout'),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: _rows.length,
              itemBuilder: (c, i) {
                final it = _rows[i];
                return Card(
                  child: ListTile(
                    title: Text(it['exercise'] ?? ''),
                    subtitle: Text('Duration: ${it['duration']} mins | Reps: ${it['reps']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _remove(it['id'] as int),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
