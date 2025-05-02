/// lib/features/health_suggestions/screens/add_suggestion_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/health_suggestion_provider.dart';
import '../../../data/models/health_suggestions/health_suggestion_model.dart';

class AddSuggestionPage extends ConsumerStatefulWidget {
  const AddSuggestionPage({Key? key}) : super(key: key);

  @override
  _AddSuggestionPageState createState() => _AddSuggestionPageState();
}

class _AddSuggestionPageState extends ConsumerState<AddSuggestionPage> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Öneri Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Öneri İçeriği'),
                maxLines: 3,
                onSaved: (v) => _content = v ?? '',
                validator: (v) => v == null || v.isEmpty ? 'Boş bırakmayın' : null,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Kaydet'),
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();
                  final s = HealthSuggestion(
                    id: 0,
                    content: _content,
                    isActive: true,
                    createdAt: DateTime.now(),
                  );
                  await ref.read(healthSuggestionServiceProvider).addSuggestion(s);
                  if (mounted) Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
