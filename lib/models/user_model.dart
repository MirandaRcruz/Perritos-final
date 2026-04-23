class UserModel {
  final String nombre;
  final String password;
  final String rol; // 'admin', 'usuario', 'moderador'

  UserModel({
    required this.nombre,
    required this.password,
    required this.rol,
  });
}
