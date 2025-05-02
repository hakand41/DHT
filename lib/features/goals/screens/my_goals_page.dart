// lib/features/goals/screens/my_goals_page.dart

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/goals/goal_model.dart';
import '../provider/goal_provider.dart';
import '../../../core/services/goal_service.dart';

class MyGoalsPage extends ConsumerWidget {
  const MyGoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(goalsListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Hedeflerim')),
      body: goalsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Hata: ${e.toString()}')),
        data: (List<Goal> goals) {
          if (goals.isEmpty) {
            return const Center(child: Text('Henüz hedef eklenmemiş.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: goals.length,
            itemBuilder: (context, index) {
              final g = goals[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(g.title),
                  subtitle: Text(g.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Hedefi Sil',
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Hedefi sil?'),
                          content: const Text(
                            'Bu hedef ve ona ait tüm durum kayıtları silinecek. Emin misiniz?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(_, false),
                              child: const Text('Hayır'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(_, true),
                              child: const Text('Evet'),
                            ),
                          ],
                        ),
                      );
                      if (confirm != true) return;

                      try {
                        // force: true ile bağlı health record'lar da silinsin
                        final ok = await ref
                            .read(goalServiceProvider)
                            .deleteGoal(g.id, force: true);
                        if (!ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Silme başarısız.')),
                          );
                        } else {
                          ref.refresh(goalsListProvider);
                        }
                      } on DioError catch (e) {
                        final msg = e.response?.data?.toString() ?? e.message;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Hata: $msg')),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/goals/add')
            .then((_) => ref.refresh(goalsListProvider)),
        child: const Icon(Icons.add),
        tooltip: 'Yeni Hedef Ekle',
      ),
    );
  }
}
