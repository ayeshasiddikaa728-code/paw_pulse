import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pet_provider.dart';
import 'screens/main_screen.dart';
import 'utils/app_theme.dart';

void main() async {
  // Local Storage (SharedPreferences) ঠিকমতো কাজ করার জন্য এটি অত্যন্ত জরুরি
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PetProvider()),
      ],
      child: const PawPulseApp(),
    ),
  );
}

class PawPulseApp extends StatelessWidget {
  const PawPulseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PawPulse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}