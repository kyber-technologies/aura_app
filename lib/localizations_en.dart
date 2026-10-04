// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get copiedToClipboard => 'Copied to Clipboard';

  @override
  String get userid => 'User Identifier';

  @override
  String get useridDescription => 'Your unique user identifier';

  @override
  String get useridInvalid =>
      'Please enter a valid user identifier with a minimum length of 3 characters';

  @override
  String get userNotUnique => 'User Id or Email is already taken';

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
  String get tagsDesc => 'Add your interests:';

  @override
  String get noTagsSpecified => 'Please specify at least one of your interests';

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
  String get unauthorizedLoginError => 'Specified invalid user credentials.';

  @override
  String get rateLimitError =>
      'You are doing things too fast! Please slow down.';

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
  String get close => 'Close';

  @override
  String get submit => 'Submit';

  @override
  String get general => 'General';

  @override
  String get allowInvites => 'Allow Invites';

  @override
  String get allowInvitesDesc => 'Allow invites and DMs from other users.';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeDesc => 'Toggle dark mode theme.';

  @override
  String get animations => 'Animations';

  @override
  String get animationsDesc => 'Enable animations.';

  @override
  String get notifications => 'Notifications';

  @override
  String get notifyInvites => 'Notify for Invites';

  @override
  String get notifyInvitesDesc => 'Enable notifications for invites.';

  @override
  String get notifyMessages => 'Notify for Messages';

  @override
  String get notifyMessagesDesc => 'Enable notifications for direct messages.';

  @override
  String get notifyComments => 'Notify for Comments';

  @override
  String get notifyCommentsDesc =>
      'Enable notifications for comments on your posts.';

  @override
  String get algorithm => 'Algorithm';

  @override
  String get algoLikeWeight => 'Algorithm Like Weight';

  @override
  String get algoLikeWeightDesc =>
      'Weight of likes in the algorithm. Higher values can get you into filter bubbles.';

  @override
  String get algoDislikeWeight => 'Algorithm Dislike Weight.';

  @override
  String get algoDislikeWeightDesc =>
      'Weight of dislikes in the algorithm. Lower values can get you into filter bubbles.';

  @override
  String get algoCommentWeight => 'Algorithm Comment Weight';

  @override
  String get algoCommentWeightDesc =>
      'Weight of comments in the algorithm. Higher values can recommend you rage-bait posts.';

  @override
  String get algoTimeDecay => 'Algorithm Time Decay';

  @override
  String get algoTimeDecayDesc =>
      'Time weight decay of posts. Higher values will give you more recent posts.';

  @override
  String get resetAlgo => 'Reset Algorithm';

  @override
  String get resetAlgoConfirm => 'Confirm Algorithm Reset';

  @override
  String get resetAlgoConfirmBody =>
      'Are you sure you want to reset your algorithm? This action cannot be undone.';
}
