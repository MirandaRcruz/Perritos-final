import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Clave secreta para JWT
  final String _secretKey = 'mi_clave_secreta_super_segura';

  UserModel? currentUser;

  final List<UserModel> _usuarios = [
    UserModel(nombre: 'admin', password: '12345678', rol: 'admin'),
  ];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null) {
      _verifyAndLoadUser(token);
    }
  }

  void _verifyAndLoadUser(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(_secretKey));
      final payload = jwt.payload as Map<String, dynamic>;
      
      currentUser = UserModel(
        nombre: payload['nombre'],
        password: '', // No guardamos password en sesión local
        rol: payload['rol'],
      );
    } catch (e) {
      currentUser = null;
    }
  }

  Future<String?> login(String nombre, String password) async {
    try {
      final user = _usuarios.firstWhere(
        (u) => u.nombre == nombre && u.password == password,
      );
      
      // Crear JWT
      final jwt = JWT(
        {
          'nombre': user.nombre,
          'rol': user.rol,
        },
        issuer: 'https://perritos.app',
      );

      final token = jwt.sign(SecretKey(_secretKey), expiresIn: const Duration(hours: 24));
      
      // Guardar token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token);

      currentUser = user;
      return token;
    } catch (_) {
      return null;
    }
  }

  bool register(String nombre, String password, String rol) {
    final existe = _usuarios.any((u) => u.nombre == nombre);
    if (existe) return false;
    _usuarios.add(UserModel(nombre: nombre, password: password, rol: rol));
    return true;
  }

  Future<void> logout() async {
    currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }
}
