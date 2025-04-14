import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/auth/screens/login_page.dart';
import 'features/auth/screens/register_page.dart';
import 'features/auth/screens/forgot_password_page.dart';
// import 'features/home/screens/home_page.dart'; // şimdilik dummy

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DHT',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(), // şimdilik dummy
        '/forgot-password': (context) => const Scaffold(body: Center(child: Text("ForgotPasswordPage"))), // dummy
        '/home': (context) => const Scaffold(body: Center(child: Text("HomePage"))), // dummy
      },
    );
  }
}
