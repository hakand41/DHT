// lib/features/profile/screens/profile_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/auth/user_model.dart';
import '../provider/profile_provider.dart';
import '../../../core/services/user_service.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _profileFormKey = GlobalKey<FormState>();
  final _pwdFormKey     = GlobalKey<FormState>();

  late TextEditingController _nameCtrl;
  late TextEditingController _birthCtrl;
  late TextEditingController _oldPwdCtrl;
  late TextEditingController _newPwdCtrl;
  late TextEditingController _confirmPwdCtrl;
  late DateTime _birthDate;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl       = TextEditingController();
    _birthCtrl      = TextEditingController();
    _oldPwdCtrl     = TextEditingController();
    _newPwdCtrl     = TextEditingController();
    _confirmPwdCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _birthCtrl.dispose();
    _oldPwdCtrl.dispose();
    _newPwdCtrl.dispose();
    _confirmPwdCtrl.dispose();
    super.dispose();
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Parola giriniz';
    }
    final regex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!regex.hasMatch(value)) {
      return 'En az 8 karakter, bir büyük, bir küçük harf ve rakam';
    }
    return null;
  }

  Future<void> _pickBirthDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthCtrl.text = picked.toIso8601String().split('T').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(userProfileProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        body: Center(child: Text('Profil hatası: $e')),
      ),
      data: (UserModel user) {
        if (!_initialized) {
          _initialized     = true;
          _nameCtrl.text   = user.fullName;
          _birthDate       = user.birthDate;
          _birthCtrl.text  = _birthDate.toIso8601String().split('T').first;
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Profilim')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                // --- Profil Güncelleme Formu ---
                Form(
                  key: _profileFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        initialValue: user.email,
                        decoration: const InputDecoration(labelText: 'E-posta'),
                        readOnly: true,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(labelText: 'Ad Soyad'),
                        validator: (v) =>
                        (v == null || v.isEmpty) ? 'Ad soyad girin' : null,
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () => _pickBirthDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            controller: _birthCtrl,
                            decoration:
                            const InputDecoration(labelText: 'Doğum Tarihi'),
                            validator: (_) =>
                            _birthDate == null ? 'Doğum tarihi seçin' : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_profileFormKey.currentState!.validate()) return;
                          final updated = UserModel(
                            id: user.id,
                            email: user.email,
                            fullName: _nameCtrl.text.trim(),
                            birthDate: _birthDate,
                          );
                          final svc = ref.read(userServiceProvider);
                          await svc.updateProfile(updated);
                          ref.refresh(userProfileProvider);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profil güncellendi')),
                          );
                        },
                        child: const Text('Profil Güncelle'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),

                // --- Parola Güncelleme Formu ---
                Form(
                  key: _pwdFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Parola Güncelle',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _oldPwdCtrl,
                        decoration:
                        const InputDecoration(labelText: 'Eski Parola'),
                        obscureText: true,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Eski parolayı girin'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _newPwdCtrl,
                        decoration:
                        const InputDecoration(labelText: 'Yeni Parola'),
                        obscureText: true,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _confirmPwdCtrl,
                        decoration: const InputDecoration(
                            labelText: 'Yeni Parola (Tekrar)'),
                        obscureText: true,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Yeni parola tekrarını girin';
                          }
                          if (v != _newPwdCtrl.text) {
                            return 'Parolalar eşleşmiyor';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () async {
                          if (!_pwdFormKey.currentState!.validate()) return;
                          final svc = ref.read(userServiceProvider);
                          try {
                            await svc.updatePassword(
                              _oldPwdCtrl.text.trim(),
                              _newPwdCtrl.text.trim(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Parola başarıyla güncellendi')),
                            );
                            _oldPwdCtrl.clear();
                            _newPwdCtrl.clear();
                            _confirmPwdCtrl.clear();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content:
                                  Text('Parola güncellenirken hata: $e')),
                            );
                          }
                        },
                        child: const Text('Parolayı Güncelle'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
