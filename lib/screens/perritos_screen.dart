import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class PerritosScreen extends StatefulWidget {
  const PerritosScreen({super.key});

  @override
  State<PerritosScreen> createState() => _PerritosScreenState();
}

class _PerritosScreenState extends State<PerritosScreen> {
  final _nombreController = TextEditingController();
  final _razaController = TextEditingController();
  final _edadController = TextEditingController();
  final _colorController = TextEditingController();
  final _auth = AuthService();
  final _picker = ImagePicker();

  XFile? _imagen;

  Future<void> _seleccionarImagen() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _imagen = pickedFile);
    }
  }

  void _guardar() {
    final nombre = _nombreController.text.trim();
    final raza = _razaController.text.trim();
    final edad = _edadController.text.trim();
    final color = _colorController.text.trim();

    if (nombre.isEmpty || raza.isEmpty || edad.isEmpty || color.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, completa todos los campos.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡$nombre guardado exitosamente! 🐶'),
        backgroundColor: Colors.green,
      ),
    );

    _nombreController.clear();
    _razaController.clear();
    _edadController.clear();
    _colorController.clear();
    setState(() => _imagen = null);
  }

  Future<void> _logout() async {
    await _auth.logout();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  Widget _tarjetaCampo(String titulo, TextEditingController controller, {TextInputType tipo = TextInputType.text}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: tipo,
              decoration: InputDecoration(
                hintText: 'Escribe aquí...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final usuario = _auth.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFF6A1B9A),
      appBar: AppBar(
        title: const Text('Perritos 🐶'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        actions: [
          if (usuario != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Center(
                child: Chip(
                  label: Text('${usuario.nombre} (${usuario.rol})'),
                  backgroundColor: Colors.purple.shade200,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: _logout,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                _tarjetaCampo('¿Cómo se llama tu perrito?', _nombreController),
                _tarjetaCampo('¿Qué raza es?', _razaController),
                _tarjetaCampo('¿Qué edad tiene?', _edadController, tipo: TextInputType.number),
                _tarjetaCampo('¿De qué color es?', _colorController),

                // Foto
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Text('Sube una foto de tu perrito 📸',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _seleccionarImagen,
                          icon: const Icon(Icons.image),
                          label: const Text('Seleccionar imagen'),
                        ),
                        const SizedBox(height: 10),
                        _imagen != null
                            ? Image.network(_imagen!.path, height: 150, errorBuilder: (_, __, ___) =>
                                const Text('Vista previa no disponible en web'))
                            : const Text('No hay imagen seleccionada', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                ),

                // Botón guardar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _guardar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF6A1B9A),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Guardar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
