// Fixtures de datos de usuario para usar en Widgetbook use-cases
//
// Estos fixtures proporcionan datos de ejemplo consistentes y reutilizables
// para demostrar diferentes estados y escenarios de componentes relacionados
// con usuarios.

class UserFixture {
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isVerified;

  const UserFixture({
    required this.name,
    required this.email,
    this.avatarUrl,
    this.isVerified = false,
  });
}

/// Fixtures de usuarios predefinidos
class UserFixtures {
  UserFixtures._();

  /// Usuario típico con todos los datos
  static const UserFixture standard = UserFixture(
    name: 'Ana García',
    email: 'ana.garcia@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    isVerified: false,
  );

  /// Usuario verificado (ej: cuenta premium, verificada)
  static const UserFixture verified = UserFixture(
    name: 'Carlos Rodríguez',
    email: 'carlos.rodriguez@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
    isVerified: true,
  );

  /// Usuario sin avatar (muestra inicial del nombre)
  static const UserFixture noAvatar = UserFixture(
    name: 'María López',
    email: 'maria.lopez@example.com',
    avatarUrl: null,
    isVerified: false,
  );

  /// Usuario con nombre largo (para probar overflow)
  static const UserFixture longName = UserFixture(
    name: 'José Antonio Fernández de la Cruz',
    email: 'jose.fernandez@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=33',
    isVerified: true,
  );

  /// Usuario con email largo (para probar overflow)
  static const UserFixture longEmail = UserFixture(
    name: 'Pedro Martínez',
    email: 'pedro.martinez.desarrollo@empresa-tecnologia.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=15',
    isVerified: false,
  );

  /// Usuario admin o staff
  static const UserFixture admin = UserFixture(
    name: 'Laura Administradora',
    email: 'admin@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    isVerified: true,
  );

  /// Usuario nuevo (sin verificar, sin avatar)
  static const UserFixture newUser = UserFixture(
    name: 'Usuario Nuevo',
    email: 'nuevo@example.com',
    avatarUrl: null,
    isVerified: false,
  );

  /// Lista de todos los usuarios para pruebas de listas
  static const List<UserFixture> all = [
    standard,
    verified,
    noAvatar,
    longName,
    longEmail,
    admin,
    newUser,
  ];

  /// Usuarios verificados solamente
  static const List<UserFixture> verifiedOnly = [
    verified,
    longName,
    admin,
  ];

  /// Usuarios sin avatar solamente
  static const List<UserFixture> noAvatarOnly = [
    noAvatar,
    newUser,
  ];
}
