import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/perritos_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authService = AuthService();
  await authService.init();

  runApp(const PerritosApp());
}

class PerritosApp extends StatelessWidget {
  const PerritosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perritos App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A1B9A)),
        useMaterial3: true,
      ),
      home: AuthService().currentUser != null 
          ? const PerritosScreen() 
          : const LoginScreen(),
    );
  }
}