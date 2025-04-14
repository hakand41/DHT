import 'package:flutter/material.dart';
import 'package:dht/core/services/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _submitForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final newPassword = _newPasswordController.text.trim();

    final success = await _authService.forgotPassword(email, newPassword);

    if (success) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("İşlem Başarılı"),
            content: const Text("Parola sıfırlama işlemi başarılı. Lütfen giriş yapmayı deneyin."),
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
        _errorMessage = _authService.lastErrorMessage ?? "Parola sıfırlama işlemi başarısız.";
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Parola giriniz";
    }
    // Parola en az 8 karakter, en az bir büyük harf, bir küçük harf ve bir rakam içermeli
    final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
    if (!passwordRegex.hasMatch(value)) {
      return "Parola en az 8 karakter, büyük harf, küçük harf ve rakam içermelidir";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parola Sıfırlama"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
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
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Yeni Parola"),
                validator: _validatePassword,
              ),
              TextFormField(
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Yeni Parola Tekrar"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Parola tekrarını giriniz";
                  }
                  if (value != _newPasswordController.text) {
                    return "Parolalar eşleşmiyor";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForgotPassword,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Parolayı Sıfırla"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("Girişe dön"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
