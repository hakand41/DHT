import 'package:flutter/material.dart';
import 'package:dht/core/services/auth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _storage = FlutterSecureStorage();
  final _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final token = await _authService.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (token != null) {
      await _storage.write(key: 'jwt_token', value: token);
      // TODO: Ana sayfaya yönlendir
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _errorMessage = "Giriş başarısız. Lütfen bilgilerinizi kontrol edin.";
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş Yap")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              if (_errorMessage != null)
                Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "E-posta"),
                validator: (value) =>
                value!.isEmpty ? "E-posta giriniz" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Parola"),
                validator: (value) =>
                value!.isEmpty ? "Parola giriniz" : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text("Giriş Yap"),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Text("Hesabın yok mu? Kayıt ol"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/forgot-password');
                },
                child: const Text("Parolanı mı unuttun?"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
