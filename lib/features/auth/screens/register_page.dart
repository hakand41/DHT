import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dht/core/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthDateController = TextEditingController();

  DateTime? _birthDate;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate() || _birthDate == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Tarih formatını düzeltip API'ye uygun hale getiriyoruz
    final formattedBirthDate = DateFormat('yyyy-MM-dd').format(_birthDate!);

    final success = await _authService.register({
      "fullName": _fullNameController.text.trim(),
      "email": _emailController.text.trim(),
      "passwordHash": _passwordController.text.trim(),
      "birthDate": formattedBirthDate,
    });

    if (success) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Kayıt Başarılı"),
            content: const Text("Lütfen e-postanı kontrol et ve giriş yap."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("Tamam"),
              ),
            ],
          ),
        );
      }
    } else {
      setState(() {
        _errorMessage = _authService.lastErrorMessage ?? "Kayıt işlemi başarısız. Bilgileri kontrol edin.";
      });
    }

    setState(() => _isLoading = false);
  }

  Future<void> _selectBirthDate() async {
    DateTime now = DateTime.now();
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kayıt Ol")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                ),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(labelText: "Ad Soyad"),
                validator: (value) =>
                value!.isEmpty ? "Ad soyad giriniz" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "E-posta"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "E-posta giriniz";
                  }
                  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                  if (!emailRegex.hasMatch(value)) {
                    return "Geçerli bir e-posta giriniz";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Parola"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Parola giriniz";
                  }
                  if (value.length < 8) {
                    return "Parola en az 8 karakter olmalı";
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Parola Tekrar"),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Parolalar eşleşmiyor";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _selectBirthDate,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _birthDateController,
                    decoration: const InputDecoration(
                      labelText: "Doğum Tarihi",
                      hintText: "Seçiniz",
                    ),
                    validator: (_) =>
                    _birthDate == null ? "Doğum tarihi seçiniz" : null,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Kayıt Ol"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("Zaten hesabın var mı? Giriş yap"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}