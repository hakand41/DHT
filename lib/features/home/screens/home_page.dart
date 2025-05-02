import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/health_records/health_record_model.dart';
import '../../../data/models/health_suggestions/health_suggestion_model.dart';
import '../../health_records/provider/health_record_provider.dart';
import '../../health_suggestions/provider/health_suggestion_provider.dart';
import '../../auth/provider/auth_provider.dart';
import '../../profile/provider/profile_provider.dart'; // <-- eklendi

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Profilden kullanıcı adı almak için
    final profileAsync = ref.watch(userProfileProvider);
    final recsAsync    = ref.watch(healthRecordsProvider);
    final sugAsync     = ref.watch(randomSuggestionProvider);

    return profileAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:   (e, _) => Scaffold(body: Center(child: Text('Profil hatası: $e'))),
      data: (user) => recsAsync.when(
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error:   (e, _) => Scaffold(body: Center(child: Text('Kayıt hatası: $e'))),
        data: (recs) => sugAsync.when(
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error:   (e, _) => Scaffold(body: Center(child: Text('Öneri hatası: $e'))),
          data: (sug) {
            final total     = recs.length;
            final completed = recs.where((r) => r.isCompleted).length;
            final pending   = total - completed;

            return Scaffold(
              appBar: AppBar(
                title: Text('Merhaba, ${user.fullName}'), // kullanıcı adı eklendi
                actions: [
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Yenile',
                    onPressed: () {
                      ref.refresh(userProfileProvider);
                      ref.refresh(healthRecordsProvider);
                      ref.refresh(randomSuggestionProvider);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Çıkış Yap',
                    onPressed: () async {
                      await ref.read(authServiceProvider).logout();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
                    },
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.person),
                          label: const Text('Profil'),
                          onPressed: () => Navigator.pushNamed(context, '/profile'),
                        ),
                        const SizedBox(width: 8),
                        TextButton.icon(
                          icon: const Icon(Icons.health_and_safety),
                          label: const Text('Ağız & Diş'),
                          onPressed: () => Navigator.pushNamed(context, '/oral-health'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Son 7 Gün Özeti',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _SummaryCard(label: 'Toplam',     value: '$total'),
                            _SummaryCard(label: 'Tamamlandı', value: '$completed'),
                            _SummaryCard(label: 'Bekleyen',   value: '$pending'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Text(
                              'Öneri',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Card(
        margin: const EdgeInsets.only(right: 8),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    label, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(value, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
        ),
      );
}
