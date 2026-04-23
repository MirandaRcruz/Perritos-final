import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'perritos_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nombreController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthService();
  String? _error;
  bool _obscurePassword = true;

  Future<void> _login() async {
    final nombre = _nombreController.text.trim();
    final password = _passwordController.text.trim();

    if (nombre.isEmpty || password.isEmpty) {
      setState(() => _error = 'Por favor, completa todos los campos.');
      return;
    }

    final token = await _auth.login(nombre, password);
    if (token != null) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PerritosScreen()),
      );
    } else {
      setState(() => _error = 'Usuario o contraseña incorrectos.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A1B9A),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 8,
            child: Padding(
              padding: const EdgeInsets.all(28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      '🐶 Perritos App',
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF6A1B9A)),
                    ),
                    const SizedBox(height: 8),
                    const Text('Inicia sesión para continuar', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 24),

                    // Campo usuario
                    TextField(
                      controller: _nombreController,
                      decoration: InputDecoration(
                        labelText: 'Usuario',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo contraseña
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onSubmitted: (_) => _login(),
                    ),
                    const SizedBox(height: 12),

                    // Error
                    if (_error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 13)),
                      ),

                    // Botón login
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A1B9A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Iniciar sesión', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Link a registro
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen()),
                        );
                      },
                      child: const Text(
                        '¿No tienes cuenta? Crear usuario',
                        style: TextStyle(color: Color(0xFF6A1B9A)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
