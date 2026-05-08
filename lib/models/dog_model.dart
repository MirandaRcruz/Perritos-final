class Comentario {
  String texto;
  String reaccion;

  Comentario({
    required this.texto,
    this.reaccion = '',
  });
}

class Dog {
  final String nombre;
  final String raza;
  final String edad;
  final String color;
  final String imageUrl;

  List<Comentario> comentarios;

  int likes;
  int risas;
  int tristes;

  Dog({
    required this.nombre,
    required this.raza,
    required this.edad,
    required this.color,
    required this.imageUrl,
    this.comentarios = const [],
    this.likes = 0,
    this.risas = 0,
    this.tristes = 0,
  });
}