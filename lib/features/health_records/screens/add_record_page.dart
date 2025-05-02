// lib/features/health_records/screens/add_record_page.dart

import 'package:dht/features/health_records/provider/health_record_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/goals/goal_model.dart';
import '../../../data/models/health_records/health_record_model.dart';
import '../../goals/provider/goal_provider.dart';
import '../../../core/services/health_record_service.dart';

final healthRecordServiceProvider = Provider((ref) => HealthRecordService());

class AddRecordPage extends ConsumerStatefulWidget {
  const AddRecordPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends ConsumerState<AddRecordPage> {
  final _formKey = GlobalKey<FormState>();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _duration = 0;
  bool _isCompleted = false;
  Goal? _selectedGoal;

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _selectedDate = d);
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (t != null) setState(() => _selectedTime = t);
  }

  @override
  Widget build(BuildContext context) {
    final goalsAsync = ref.watch(goalsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: goalsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Hedef hatası: $e')),
          data: (goals) {
            // Eğer hiç hedef yoksa önce hedef eklenmesini iste
            if (goals.isEmpty) {
              return const Center(
                child: Text('Önce bir hedef ekleyin.'),
              );
            }
            // Default seçili hedef
            _selectedGoal ??= goals.first;

            return Form(
              key: _formKey,
              child: ListView(
                children: [
                  // Tarih
                  Row(
                    children: [
                      Expanded(
                        child: Text('Tarih: ${_selectedDate.toLocal().toIso8601String().split("T").first}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: _pickDate,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Saat
                  Row(
                    children: [
                      Expanded(
                        child: Text('Saat: ${_selectedTime.format(context)}'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.access_time),
                        onPressed: _pickTime,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Süre
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Süre (dk)'),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _duration = int.tryParse(v ?? '') ?? 0,
                    validator: (v) {
                      final n = int.tryParse(v ?? '');
                      if (n == null || n <= 0) return 'Geçerli süre girin';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Uygulandı mı?
                  SwitchListTile(
                    title: const Text('Uygulandı mı?'),
                    value: _isCompleted,
                    onChanged: (b) => setState(() => _isCompleted = b),
                  ),
                  const SizedBox(height: 16),
                  // Goal seçimi
                  DropdownButtonFormField<Goal>(
                    decoration: const InputDecoration(labelText: 'Hedef Seçin'),
                    value: _selectedGoal,
                    items: goals.map((g) {
                      return DropdownMenuItem(
                        value: g,
                        child: Text(g.title),
                      );
                    }).toList(),
                    onChanged: (g) => setState(() => _selectedGoal = g),
                  ),
                  const SizedBox(height: 24),
                  // Kaydet butonu
                  ElevatedButton(
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      _formKey.currentState!.save();

                      // Date + Time → DateTime
                      final dt = DateTime(
                        _selectedDate.year,
                        _selectedDate.month,
                        _selectedDate.day,
                        _selectedTime.hour,
                        _selectedTime.minute,
                      );
                      // recordTime string formatı: HH:mm:ss
                      final recordTime =
                      _selectedTime.format(context); // e.g. "1:37 PM"
                      // convert to 24h "HH:mm:ss"
                      final rt24 = dt.toIso8601String().split('T')[1].split('.')[0];

                      final newRecord = HealthRecord(
                        id: 0,
                        userId: 0,
                        goalId: _selectedGoal!.id,
                        recordDate: DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                        ),
                        recordTime: rt24,
                        duration: _duration,
                        isCompleted: _isCompleted,
                        createdAt: DateTime.now(),
                      );

                      await ref.read(healthRecordServiceProvider).addRecord(newRecord);

                      if (mounted) {
                        // Geri dön ve listeyi yenile
                        Navigator.pop(context);
                        ref.refresh(healthRecordsProvider);
                      }
                    },
                    child: const Text('Kaydet'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
