// lib/features/notes/provider/note_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/note_service.dart';
import '../../../data/models/notes/note_model.dart';

/// NoteService’i sağlayan provider
final noteServiceProvider = Provider((ref) => NoteService());

/// Kullanıcının notlarını çeken FutureProvider
final notesListProvider = FutureProvider<List<Note>>(
      (ref) => ref.read(noteServiceProvider).fetchMyNotes(),
);
