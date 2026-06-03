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
  String get useridInvalid =>
      'Please enter a valid user identifier with a minimum length of 3 characters';

  @override
  String get useridNotUnique => 'User Id is already taken';

  @override
  String get username => 'Username';

  @override
  String get usernameDescription => 'Your display username';

  @override
  String get usernameInvalid => 'Please enter a valid username';

  @override
  String get email => 'Email';

  @override
  String get emailDescription => 'Your email address';

  @override
  String get emailInvalid => 'Please enter a valid email address';

  @override
  String get password => 'password';

  @override
  String get passwordDescription => 'Your super-secret password';

  @override
  String get passwordInvalid =>
      'Please enter a valid password with a minimum length of 6 characters';

  @override
  String get login => 'Login';

  @override
  String get signup => 'Signup';

  @override
  String get verifyEmail => 'Verify your Email';

  @override
  String verifyEmailBody(Object email) {
    return 'We\'ve sent a verification email to $email';
  }

  @override
  String get emailTokenLabel => 'Your verification code';

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

  @override
  String get submit => 'Submit';
}
