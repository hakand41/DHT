/// lib/features/health_suggestions/screens/random_suggestion_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/health_suggestion_provider.dart';

class RandomSuggestionPage extends ConsumerWidget {
  const RandomSuggestionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSug = ref.watch(randomSuggestionProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Sağlık Önerisi')),
      body: asyncSug.when(
        data: (sug) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              sug.content,
              style: const TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.refresh(randomSuggestionProvider),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
