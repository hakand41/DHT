// lib/core/services/note_service.dart

import 'base_service.dart';
import '../../data/models/notes/note_model.dart';

class NoteService extends BaseService {
  NoteService() : super('http://10.0.2.2:5288/api/notes');

  Future<List<Note>> fetchMyNotes() async {
    final resp = await dio.get('/my-notes');
    return (resp.data as List)
        .map((j) => Note.fromJson(j))
        .toList();
  }

  Future<Note> addNote(Note n) async {
    final resp = await dio.post('/add', data: n.toJson());
    return Note.fromJson(resp.data);
  }

  Future<bool> deleteNote(int id) async {
    final resp = await dio.delete('/delete/$id');
    return resp.statusCode == 200;
  }
}
