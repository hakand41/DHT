// lib/features/notes/screens/my_notes_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/notes/note_model.dart';
import '../../notes/provider/note_provider.dart';

class MyNotesPage extends ConsumerWidget {
  const MyNotesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Notlarım')),
      body: notesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Not hatası: $e')),
        data: (notes) {
          if (notes.isEmpty) {
            return const Center(child: Text('Henüz not eklenmemiş.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, i) {
              final Note n = notes[i];
              Widget? leading;
              if (n.imagePath != null && n.imagePath!.isNotEmpty) {
                // imagePath URL veya lokal dosya olabilir
                if (n.imagePath!.startsWith('http')) {
                  leading = Image.network(
                    n.imagePath!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  );
                } else {
                  leading = Image.file(
                    File(n.imagePath!),
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                  );
                }
              }
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: leading,
                  title: Text(n.description),
                  subtitle: Text(
                    'Oluşturulma: ${n.createdAt.toLocal().toIso8601String().split("T").first}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await ref.read(noteServiceProvider).deleteNote(n.id);
                      ref.refresh(notesListProvider);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/notes/add')
            .then((_) => ref.refresh(notesListProvider)),
        child: const Icon(Icons.add),
        tooltip: 'Yeni Not Ekle',
      ),
    );
  }
}
