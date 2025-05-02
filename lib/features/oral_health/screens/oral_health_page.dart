// lib/features/oral_health/screens/oral_health_page.dart

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../health_records/provider/health_record_provider.dart';
import '../../notes/provider/note_provider.dart';
import '../../health_suggestions/provider/health_suggestion_provider.dart';
import '../../goals/provider/goal_provider.dart';
import '../../goals/screens/edit_goal_page.dart';

class OralHealthPage extends ConsumerStatefulWidget {
  const OralHealthPage({Key? key}) : super(key: key);

  @override
  ConsumerState<OralHealthPage> createState() => _OralHealthPageState();
}

class _OralHealthPageState extends ConsumerState<OralHealthPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ağız & Diş Sağlığı'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Yenile',
            onPressed: () {
              ref.refresh(healthRecordsProvider);
              ref.refresh(notesListProvider);
              ref.refresh(randomSuggestionProvider);
              ref.refresh(goalsListProvider);
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Durum'),
            Tab(text: 'Hedef'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildStatusTab(),
          _buildGoalsTab(context),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
        onPressed: () =>
            Navigator.pushNamed(context, '/goals/add')
                .then((_) => ref.refresh(goalsListProvider)),
        child: const Icon(Icons.add),
        tooltip: 'Yeni Hedef',
      )
          : null,
    );
  }

  Widget _buildStatusTab() {
    final recsAsync  = ref.watch(healthRecordsProvider);
    final notesAsync = ref.watch(notesListProvider);
    final sugAsync   = ref.watch(randomSuggestionProvider);
    final goalsAsync = ref.watch(goalsListProvider);

    if (recsAsync.isLoading ||
        notesAsync.isLoading ||
        sugAsync.isLoading ||
        goalsAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (recsAsync.hasError)  return Center(child: Text('Kayıt hatası: ${recsAsync.error}'));
    if (notesAsync.hasError) return Center(child: Text('Not hatası: ${notesAsync.error}'));
    if (sugAsync.hasError)   return Center(child: Text('Öneri hatası: ${sugAsync.error}'));
    if (goalsAsync.hasError) return Center(child: Text('Hedef hatası: ${goalsAsync.error}'));

    final recs  = recsAsync.value!;
    final notes = notesAsync.value!;
    final sug   = sugAsync.value!;
    final goals = goalsAsync.value!;

    // Map goalId → title
    final goalMap = {for (var g in goals) g.id: g.title};

    final total     = recs.length;
    final completed = recs.where((r) => r.isCompleted).length;
    final pending   = total - completed;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Son 7 Gün Özeti',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _SummaryCard(label: 'Toplam',     value: '$total'),
            _SummaryCard(label: 'Tamamlandı', value: '$completed'),
            _SummaryCard(label: 'Bekleyen',   value: '$pending'),
          ],
        ),
        const SizedBox(height: 16),

        // Yeni Durum Ekle
        ElevatedButton.icon(
          icon: const Icon(Icons.fiber_manual_record),
          label: const Text('Yeni Durum Ekle'),
          onPressed: () => Navigator.pushNamed(context, '/records/add')
              .then((_) => ref.refresh(healthRecordsProvider)),
        ),
        const SizedBox(height: 24),

        const Text(
          'Geçmiş Durumlar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (recs.isEmpty)
          const Center(child: Text('Henüz durum eklenmemiş.'))
        else
          for (var r in recs)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  '${r.recordDate.toLocal().toIso8601String().split('T').first} – ${r.recordTime.isNotEmpty ? r.recordTime : "-"}',
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hedef: ${goalMap[r.goalId] ?? "-"}'),
                    Text('Süre: ${r.duration} dk, Uygulandı: ${r.isCompleted ? "Evet" : "Hayır"}'),
                  ],
                ),
              ),
            ),

        const SizedBox(height: 24),
        const Text(
          'Notlar',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Yeni Not Ekle (Notlar başlığının hemen altında)
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.note_add),
            label: const Text('Yeni Not Ekle'),
            onPressed: () => Navigator.pushNamed(context, '/notes/add')
                .then((_) => ref.refresh(notesListProvider)),
          ),
        ),
        const SizedBox(height: 8),

        if (notes.isEmpty)
          const Center(child: Text('Henüz not eklenmemiş.'))
        else
          for (var n in notes)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: (n.imagePath != null && n.imagePath!.isNotEmpty)
                    ? (n.imagePath!.startsWith('http')
                    ? Image.network(n.imagePath!, width: 56, height: 56, fit: BoxFit.cover)
                    : Image.file(File(n.imagePath!), width: 56, height: 56, fit: BoxFit.cover))
                    : null,
                title: Text(n.description),
                subtitle: Text(
                  'Oluşturulma: ${n.createdAt.toLocal().toIso8601String().split('T').first}',
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(noteServiceProvider).deleteNote(n.id).then((_) {
                      ref.refresh(notesListProvider);
                    });
                  },
                ),
              ),
            ),

        const SizedBox(height: 24),
        const Text(
          'Öneri',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(sug.content, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Yeni Öneri'),
                  onPressed: () => ref.refresh(randomSuggestionProvider),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalsTab(BuildContext context) {
    final goalsAsync = ref.watch(goalsListProvider);

    return goalsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Hata: $e')),
      data: (goals) {
        if (goals.isEmpty) {
          return const Center(child: Text('Henüz hedef eklenmemiş.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: goals.length,
          itemBuilder: (_, i) {
            final g = goals[i];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(g.title),
                subtitle: Text(g.description),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: 'Düzenle',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => EditGoalPage(goal: g)),
                        ).then((_) => ref.refresh(goalsListProvider));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Sil',
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Hedefi sil?'),
                            content: const Text(
                              'Bu hedef ve ona ait tüm durum kayıtları silinecek.',
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
                          await ref
                              .read(goalServiceProvider)
                              .deleteGoal(g.id, force: true);
                          ref.refresh(goalsListProvider);
                        } on DioError catch (e) {
                          final msg = e.response?.data?.toString() ?? e.message;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Hata: $msg')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: 90,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(value, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
