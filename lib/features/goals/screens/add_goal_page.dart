/*
lib/features/goals/screens/add_goal_page.dart
*/
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/goal_provider.dart';
import '../../../data/models/goals/goal_model.dart';

class AddGoalPage extends ConsumerStatefulWidget {
  const AddGoalPage({super.key});
  @override
  _AddGoalPageState createState() => _AddGoalPageState();
}
class _AddGoalPageState extends ConsumerState<AddGoalPage> {
  final _formKey = GlobalKey<FormState>();
  late String title, description, period = 'Daily', importance = 'Normal';
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Hedef')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Başlık'),
                onSaved: (v) => title = v!,
                validator: (v) => v!.isEmpty ? 'Boş bırakılamaz' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Açıklama'),
                onSaved: (v) => description = v!,
                validator: (v) => v!.isEmpty ? 'Boş bırakılamaz' : null,
              ),
              DropdownButtonFormField<String>(
                value: period,
                items: const [
                  DropdownMenuItem(value: 'Daily', child: Text('Günlük')),
                  DropdownMenuItem(value: 'Weekly', child: Text('Haftalık')),
                ],
                onChanged: (v) => period = v!,
                decoration: const InputDecoration(labelText: 'Periyot'),
              ),
              DropdownButtonFormField<String>(
                value: importance,
                items: const [
                  DropdownMenuItem(value: 'Low', child: Text('Düşük')),
                  DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                  DropdownMenuItem(value: 'High', child: Text('Yüksek')),
                ],
                onChanged: (v) => importance = v!,
                decoration: const InputDecoration(labelText: 'Önem'),
              ),
              SwitchListTile(
                title: const Text('Aktif'),
                value: isActive,
                onChanged: (v) => setState(() => isActive = v),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final goal = Goal(
                      id: 0,
                      title: title,
                      description: description,
                      period: period,
                      importance: importance,
                      isActive: isActive,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    await ref.read(goalServiceProvider).addGoal(goal);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}