import 'package:flutter/material.dart';

class WorkoutLogScreen extends StatefulWidget {
  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final exCtrl = TextEditingController();
  final durCtrl = TextEditingController();
  final repCtrl = TextEditingController();

  // temp list for milestone 1
  final List<Map<String, String>> _list = [];

  void addWorkout() {
    if (exCtrl.text.isEmpty) return;
    setState(() {
      _list.add({
        'exercise': exCtrl.text,
        'duration': durCtrl.text,
        'reps': repCtrl.text,
      });
      exCtrl.clear();
      durCtrl.clear();
      repCtrl.clear();
    });
  }

  void remove(int i) => setState(() => _list.removeAt(i));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: exCtrl,
            decoration: const InputDecoration(labelText: 'exercise type'),
          ),
          TextField(
            controller: durCtrl,
            decoration: const InputDecoration(labelText: 'duration (mins)'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: repCtrl,
            decoration: const InputDecoration(labelText: 'repetitions'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: addWorkout,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[300]),
            child: const Text('add workout'),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (c, i) {
                final item = _list[i];
                return Card(
                  child: ListTile(
                    title: Text(item['exercise'] ?? ''),
                    subtitle: Text(
                      'duration: ${item['duration']} mins | reps: ${item['reps']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => remove(i),
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
