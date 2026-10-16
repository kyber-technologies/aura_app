import 'package:aura_dart/user.dart';

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

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+"
    '@[a-zA-Z0-9-]+'
    r'(?:\.[a-zA-Z0-9-]+)*$',
  );

  return emailRegex.hasMatch(email);
}
