// lib/features/notes/screens/add_note_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/notes/note_model.dart';
import '../../notes/provider/note_provider.dart';

class AddNotePage extends ConsumerStatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends ConsumerState<AddNotePage> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  XFile? _pickedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? img =
    await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (img != null) {
      setState(() => _pickedImage = img);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Not Ekle')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Açıklama'),
                maxLines: 3,
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Açıklama girin' : null,
                onSaved: (v) => _description = v!.trim(),
              ),
              const SizedBox(height: 16),
              if (_pickedImage != null)
                Image.file(
                  File(_pickedImage!.path),
                  height: 180,
                  fit: BoxFit.cover,
                ),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Resim Seç'),
                onPressed: _pickImage,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState!.save();

                  final newNote = Note(
                    id: 0,
                    userId: 0,
                    description: _description,
                    imagePath: _pickedImage?.path,
                    createdAt: DateTime.now(),
                  );

                  await ref
                      .read(noteServiceProvider)
                      .addNote(newNote);

                  if (mounted) Navigator.pop(context);
                },
                child: const Text('Kaydet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
