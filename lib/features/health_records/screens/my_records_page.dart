import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/health_record_provider.dart';
import '../../../data/models/health_records/health_record_model.dart';

class MyRecordsPage extends ConsumerWidget {
  const MyRecordsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncRecs = ref.watch(healthRecordsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sağlık Kayıtlarım')),
      body: asyncRecs.when(
        data: (recs) => ListView.builder(
          itemCount: recs.length,
          itemBuilder: (_, i) {
            final r = recs[i];
            return ListTile(
              title: Text('${r.recordDate.toLocal().toIso8601String().split("T").first} - ${r.recordTime}'),
              subtitle: Text('Süre: ${r.duration} dk, Uygulandı: ${r.isCompleted ? "Evet" : "Hayır"}'),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/records/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
