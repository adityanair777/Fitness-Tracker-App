import 'package:flutter/material.dart';

class CalorieTrackerScreen extends StatefulWidget {
  @override
  State<CalorieTrackerScreen> createState() => _CalorieTrackerScreenState();
}

class _CalorieTrackerScreenState extends State<CalorieTrackerScreen> {
  final foodCtrl = TextEditingController();
  final calCtrl = TextEditingController();

  // temp list for milestone 1
  final List<Map<String, String>> _meals = [];

  void addMeal() {
    if (foodCtrl.text.isEmpty || calCtrl.text.isEmpty) return;
    setState(() {
      _meals.add({'food': foodCtrl.text, 'cal': calCtrl.text});
      foodCtrl.clear();
      calCtrl.clear();
    });
  }

  void remove(int i) => setState(() => _meals.removeAt(i));

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // pink "day" box to match your wireframe
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.pink[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'day: today',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 10),

          TextField(
            controller: foodCtrl,
            decoration: const InputDecoration(labelText: 'meal name'),
          ),
          TextField(
            controller: calCtrl,
            decoration: const InputDecoration(labelText: 'calories'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: addMeal,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink[300]),
            child: const Text('add meal'),
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
                    subtitle: Text('${m['cal']} cal'),
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
