// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth
import 'features/auth/screens/login_page.dart';
import 'features/auth/screens/register_page.dart';
import 'features/auth/screens/forgot_password_page.dart';
import 'features/auth/screens/reset_password_page.dart';

// Core App with BottomNavigation
import 'app.dart';

// Goals
import 'features/goals/screens/my_goals_page.dart';
import 'features/goals/screens/add_goal_page.dart';

// Health Records
import 'features/health_records/screens/my_records_page.dart';
import 'features/health_records/screens/add_record_page.dart';

// Notes
import 'features/notes/screens/my_notes_page.dart';
import 'features/notes/screens/add_note_page.dart';

// Health Suggestions
import 'features/health_suggestions/screens/random_suggestion_page.dart';
import 'features/health_suggestions/screens/add_suggestion_page.dart';

// Oral Health
import 'features/oral_health/screens/oral_health_page.dart';

// Profile
import 'features/profile/screens/profile_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ağız & Diş Sağlığı Takip Uygulaması',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/login',
      routes: {
        // Authentication
        '/login':        (_) => const LoginPage(),
        '/register':     (_) => const RegisterPage(),
        '/forgot-password': (_) => const ForgotPasswordPage(),

        // Main App (with BottomNavigation)
        '/home':         (_) => const App(),

        // Goals
        '/goals':        (_) => const MyGoalsPage(),
        '/goals/add':    (_) => const AddGoalPage(),

        // Health Records
        '/records':      (_) => const MyRecordsPage(),
        '/records/add':  (_) => const AddRecordPage(),

        // Notes
        '/notes':        (_) => const MyNotesPage(),
        '/notes/add':    (_) => const AddNotePage(),

        // Health Suggestions
        '/suggestions':      (_) => const RandomSuggestionPage(),
        '/suggestions/add':  (_) => const AddSuggestionPage(),

        // Oral Health
        '/oral-health':  (_) => const OralHealthPage(),

        // Profile
        '/profile':      (_) => const ProfilePage(),
      },
    );
  }
}
