import 'package:aura_dart/aura_dart.dart';

String joinPath(String base, String part) {
  String basePath = base;
  final String partPath = part;

  if (base.endsWith('/')) {
    basePath = base.substring(0, base.length - 1);
  }

  if (part.startsWith('/')) {
    basePath = part.substring(1);
  }

  return '$basePath/$partPath';
}

String joinPaths(String base, List<String> paths) {
  String path = base;

  for (final String part in paths) {
    path = joinPath(path, part);
  }

  return path;
}

String displayRole(UserRole role) {
  switch (role) {
    case UserRole.USER_ROLE_USER_UNSPECIFIED:
      return 'User';
    case UserRole.USER_ROLE_MODERATOR:
      return 'Moderator';
    case UserRole.USER_ROLE_ADMIN:
      return 'Admin';
    default:
      throw Exception('Unknown role: $role');
  }
}
