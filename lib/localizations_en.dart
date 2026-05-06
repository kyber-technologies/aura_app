// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get userid => 'User Identifier';

  @override
  String get useridDescription => 'Your unique user identifier';

  @override
  String get useridInvalid => 'Please enter a valid user identifier';

  @override
  String get password => 'password';

  @override
  String get passwordDescription => 'Your super-secret password';

  @override
  String get passwordInvalid => 'Please enter a valid password';

  @override
  String get login => 'Login';

  @override
  String get unexpectedError => 'Unexpected error';

  @override
  String get unauthorizedLoginError =>
      'Credentials are invalid. Please try again.';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Log Out';

  @override
  String get confirmLogout => 'Log out of Aura?';

  @override
  String get about => 'About';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';
}
