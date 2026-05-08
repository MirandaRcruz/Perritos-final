import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/auth_service.dart';
import '../services/cloudinary_service.dart';
import '../models/dog_model.dart';
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

  List<Dog> perros = [];

  Future<void> _seleccionarImagen() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imagen = pickedFile;
      });
    }
  }

  Future<void> _guardar() async {
    final nombre = _nombreController.text.trim();
    final raza = _razaController.text.trim();
    final edad = _edadController.text.trim();
    final color = _colorController.text.trim();

    if (nombre.isEmpty ||
        raza.isEmpty ||
        edad.isEmpty ||
        color.isEmpty ||
        _imagen == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa todos los campos e imagen.',
          ),
          backgroundColor: Colors.orange,
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Subiendo imagen a Cloudinary ☁️'),
      ),
    );

    // LEER IMAGEN
    Uint8List imageBytes =
        await _imagen!.readAsBytes();

    // SUBIR A CLOUDINARY
    final imageUrl =
        await CloudinaryService.uploadImageWeb(
      imageBytes,
    );

    if (imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error subiendo imagen.',
          ),
          backgroundColor: Colors.red,
        ),
      );

      return;
    }

    final nuevoPerro = Dog(
      nombre: nombre,
      raza: raza,
      edad: edad,
      color: color,
      imageUrl: imageUrl,
      comentarios: [],
    );

    setState(() {
      perros.add(nuevoPerro);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$nombre guardado en Cloudinary ☁️🐶',
        ),
        backgroundColor: Colors.green,
      ),
    );

    _nombreController.clear();
    _razaController.clear();
    _edadController.clear();
    _colorController.clear();

    setState(() {
      _imagen = null;
    });
  }

  Future<void> _logout() async {
    await _auth.logout();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  Widget _tarjetaCampo(
    String titulo,
    TextEditingController controller, {
    TextInputType tipo = TextInputType.text,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: controller,
              keyboardType: tipo,
              decoration: InputDecoration(
                hintText: 'Escribe aquí...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardPerro(Dog perro) {
    final comentarioController = TextEditingController();

    return Card(
      margin: const EdgeInsets.only(top: 20),
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (perro.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  perro.imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 15),

            Text(
              perro.nombre,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text('🐾 Raza: ${perro.raza}'),
            Text('🎂 Edad: ${perro.edad}'),
            Text('🎨 Color: ${perro.color}'),

            const SizedBox(height: 20),

            Wrap(
              spacing: 10,
              children: [
                Chip(label: Text('❤️ ${perro.likes}')),
                Chip(label: Text('😂 ${perro.risas}')),
                Chip(label: Text('😢 ${perro.tristes}')),
              ],
            ),

            const SizedBox(height: 20),

            TextField(
              controller: comentarioController,
              decoration: InputDecoration(
                hintText: 'Escribe un comentario...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (comentarioController.text
                      .trim()
                      .isEmpty) {
                    return;
                  }

                  setState(() {
                    perro.comentarios = [
                      ...perro.comentarios,
                      Comentario(
                        texto:
                            comentarioController.text
                                .trim(),
                      ),
                    ];
                  });

                  comentarioController.clear();
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                ),

                child: const Text(
                  'Comentar',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            ...perro.comentarios.map((comentario) {
              return Container(
                margin: const EdgeInsets.only(
                  bottom: 15,
                ),

                padding: const EdgeInsets.all(12),

                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                      BorderRadius.circular(15),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [
                    Text(
                      comentario.texto,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Wrap(
                      spacing: 10,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              comentario.reaccion =
                                  '❤️';

                              perro.likes++;
                            });
                          },

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.pink.shade100,
                          ),

                          child: const Text('❤️'),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              comentario.reaccion =
                                  '😂';

                              perro.risas++;
                            });
                          },

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.yellow.shade200,
                          ),

                          child: const Text('😂'),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              comentario.reaccion =
                                  '😢';

                              perro.tristes++;
                            });
                          },

                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue.shade100,
                          ),

                          child: const Text('😢'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    if (comentario
                        .reaccion
                        .isNotEmpty)
                      Text(
                        'Reacción: ${comentario.reaccion}',
                        style: const TextStyle(
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),
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
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 8,
              ),

              child: Center(
                child: Chip(
                  label: Text(
                    '${usuario.nombre} (${usuario.rol})',
                  ),

                  backgroundColor:
                      Colors.purple.shade200,
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
            constraints: const BoxConstraints(
              maxWidth: 550,
            ),

            child: Column(
              children: [
                _tarjetaCampo(
                  '¿Cómo se llama tu perrito?',
                  _nombreController,
                ),

                _tarjetaCampo(
                  '¿Qué raza es?',
                  _razaController,
                ),

                _tarjetaCampo(
                  '¿Qué edad tiene?',
                  _edadController,
                  tipo: TextInputType.number,
                ),

                _tarjetaCampo(
                  '¿De qué color es?',
                  _colorController,
                ),

                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),

                  margin:
                      const EdgeInsets.only(
                    bottom: 12,
                  ),

                  child: Padding(
                    padding:
                        const EdgeInsets.all(12),

                    child: Column(
                      children: [
                        const Text(
                          'Sube una foto de tu perrito 📸',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 10),

                        ElevatedButton.icon(
                          onPressed:
                              _seleccionarImagen,

                          icon: const Icon(
                            Icons.image,
                          ),

                          label: const Text(
                            'Seleccionar imagen',
                          ),
                        ),

                        const SizedBox(height: 10),

                        _imagen != null
                            ? Image.network(
                                _imagen!.path,
                                height: 150,
                              )
                            : const Text(
                                'No hay imagen seleccionada',
                                style: TextStyle(
                                  color:
                                      Colors.grey,
                                ),
                              ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: _guardar,

                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.white,

                      foregroundColor:
                          const Color(
                        0xFF6A1B9A,
                      ),

                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 14,
                      ),

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),
                    ),

                    child: const Text(
                      'Guardar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                ...perros.map(
                  (perro) =>
                      _cardPerro(perro),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}