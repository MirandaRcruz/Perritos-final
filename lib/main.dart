import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(PerritosApp());
}

class PerritosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perritos',
      debugShowCheckedModeBanner: false,
      home: PantallaPerritos(),
    );
  }
}

class PantallaPerritos extends StatefulWidget {
  @override
  _PantallaPerritosState createState() => _PantallaPerritosState();
}

class _PantallaPerritosState extends State<PantallaPerritos> {
  final nombreController = TextEditingController();
  final razaController = TextEditingController();
  final edadController = TextEditingController();
  final colorController = TextEditingController();

  File? imagen;
  final picker = ImagePicker();

  Future<void> seleccionarImagen() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagen = File(pickedFile.path);
      });
    }
  }

  void guardar() {
    print("Nombre: ${nombreController.text}");
    print("Raza: ${razaController.text}");
    print("Edad: ${edadController.text}");
    print("Color: ${colorController.text}");
    print("Imagen: $imagen");
  }

  Widget tarjetaPregunta(String titulo, TextEditingController controller) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(titulo,
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Escribe aquí...",
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

  Widget tarjetaImagen() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 15),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Text("Sube una foto de tu perrito 📸",
                style: TextStyle(fontWeight: FontWeight.bold)),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: seleccionarImagen,
              child: Text("Seleccionar imagen"),
            ),

            SizedBox(height: 10),

            imagen != null
                ? Image.file(imagen!, height: 150)
                : Text("No hay imagen"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A1B9A),
      appBar: AppBar(
        title: Text("Perritos 🐶"),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            tarjetaPregunta("¿Cómo se llama tu perrito?", nombreController),
            tarjetaPregunta("¿Qué raza es?", razaController),
            tarjetaPregunta("¿Qué edad tiene?", edadController),
            tarjetaPregunta("¿De qué color es?", colorController),

            tarjetaImagen(),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: guardar,
              child: Text("Guardar"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}