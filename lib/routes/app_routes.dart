/*
lib/routes/app_routes.dart
*/
import 'package:dht/features/notes/screens/add_note_page.dart';
import 'package:dht/features/notes/screens/my_notes_page.dart';
import 'package:flutter/material.dart';
import '../features/auth/screens/login_page.dart';
import '../features/auth/screens/register_page.dart';
import '../features/auth/screens/forgot_password_page.dart';
import '../features/home/screens/home_page.dart';
import '../features/profile/screens/profile_page.dart';
import '../features/oral_health/screens/oral_health_page.dart';
import '../features/health_suggestions/screens/random_suggestion_page.dart';
import '../features/health_suggestions/screens/add_suggestion_page.dart';

class Routes {
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const profile = '/profile';
  static const oralHealth = '/oral-health';
  static const notes = '/notes';
  static const addNote = '/notes/add';
  static const suggestions = '/suggestions';
  static const addSuggestion = '/suggestions/add';
}

class AppRoutes {
  static final routes = <String, WidgetBuilder>{
    Routes.login: (_) => const LoginPage(),
    Routes.register: (_) => const RegisterPage(),
    Routes.forgotPassword: (_) => const ForgotPasswordPage(),
    Routes.home: (_) => const HomePage(),
    Routes.profile: (_) => const ProfilePage(),
    Routes.oralHealth: (_) => const OralHealthPage(),
    Routes.notes: (_) => const MyNotesPage(),
    Routes.addNote: (_) => const AddNotePage(),
    Routes.suggestions: (_) => const RandomSuggestionPage(),
    Routes.addSuggestion: (_) => const AddSuggestionPage(),
  };
}