// lib/features/goals/screens/edit_goal_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/goals/goal_model.dart';
import '../provider/goal_provider.dart';

class EditGoalPage extends ConsumerStatefulWidget {
  final Goal goal;
  const EditGoalPage({Key? key, required this.goal}) : super(key: key);

  @override
  ConsumerState<EditGoalPage> createState() => _EditGoalPageState();
}

class _EditGoalPageState extends ConsumerState<EditGoalPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _periodCtrl;
  late TextEditingController _importanceCtrl;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _titleCtrl      = TextEditingController(text: widget.goal.title);
    _descCtrl       = TextEditingController(text: widget.goal.description);
    _periodCtrl     = TextEditingController(text: widget.goal.period);
    _importanceCtrl = TextEditingController(text: widget.goal.importance);
    _isActive       = widget.goal.isActive;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _periodCtrl.dispose();
    _importanceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hedefi Düzenle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(labelText: 'Başlık'),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Başlık girin' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Açıklama'),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Açıklama girin' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _periodCtrl,
                decoration: const InputDecoration(labelText: 'Periyot'),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Periyot girin' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _importanceCtrl,
                decoration: const InputDecoration(labelText: 'Öncelik'),
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Öncelik girin' : null,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Aktif mi?'),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  final updated = Goal(
                    id: widget.goal.id,
                    title: _titleCtrl.text.trim(),
                    description: _descCtrl.text.trim(),
                    period: _periodCtrl.text.trim(),
                    importance: _importanceCtrl.text.trim(),
                    isActive: _isActive,
                    createdAt: widget.goal.createdAt,
                    updatedAt: DateTime.now(),
                  );
                  await ref
                      .read(goalServiceProvider)
                      .updateGoal(updated.id, updated);
                  ref.refresh(goalsListProvider);
                  Navigator.pop(context);
                },
                child: const Text('Güncelle'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
