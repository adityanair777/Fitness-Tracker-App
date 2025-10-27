import 'package:flutter/material.dart';
import '../data/db_helper.dart';

class CalorieTrackerScreen extends StatefulWidget {
  @override
  State<CalorieTrackerScreen> createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  final foodCtrl = TextEditingController();
  final calCtrl = TextEditingController();

  List<Map<String, dynamic>> _meals = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await DBHelper.all(DBHelper.mealTable);
    setState(() => _meals = data);
  }

  Future<void> _add() async {
    if (foodCtrl.text.isEmpty || calCtrl.text.isEmpty) return;
    await DBHelper.insert(DBHelper.mealTable, {
      'food': foodCtrl.text,
      'calories': calCtrl.text,
    });
    foodCtrl.clear();
    calCtrl.clear();
    await _load();
  }

  Future<void> _remove(int id) async {
    await DBHelper.delete(DBHelper.mealTable, id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text('Day: Today', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 10),
          TextField(controller: foodCtrl, decoration: const InputDecoration(labelText: 'Meal Name')),
          TextField(controller: calCtrl, decoration: const InputDecoration(labelText: 'Calories'), keyboardType: TextInputType.number),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _add,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[300]),
            child: const Text('Add Meal'),
          ),
          const SizedBox(height: 15),
          Expanded(
            child: ListView.builder(
              itemCount: _meals.length,
              itemBuilder: (c, i) {
                final m = _meals[i];
                return Card(
                  child: ListTile(
                    title: Text(m['food'] ?? ''),
                    subtitle: Text('${m['calories']} cal'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _remove(m['id'] as int),
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
