import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'lib/localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// No description provided for @copiedToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copied to Clipboard'**
  String get copiedToClipboard;

  /// No description provided for @userid.
  ///
  /// In en, this message translates to:
  /// **'User Identifier'**
  String get userid;

  /// No description provided for @useridDescription.
  ///
  /// In en, this message translates to:
  /// **'Your unique user identifier'**
  String get useridDescription;

  /// No description provided for @useridInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid user identifier with a minimum length of 3 characters'**
  String get useridInvalid;

  /// No description provided for @userNotUnique.
  ///
  /// In en, this message translates to:
  /// **'User Id or Email is already taken'**
  String get userNotUnique;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameDescription.
  ///
  /// In en, this message translates to:
  /// **'Your display username'**
  String get usernameDescription;

  /// No description provided for @usernameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid username'**
  String get usernameInvalid;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailDescription.
  ///
  /// In en, this message translates to:
  /// **'Your email address'**
  String get emailDescription;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'password'**
  String get password;

  /// No description provided for @passwordDescription.
  ///
  /// In en, this message translates to:
  /// **'Your super-secret password'**
  String get passwordDescription;

  /// No description provided for @passwordInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid password with a minimum length of 6 characters'**
  String get passwordInvalid;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @tagsDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your interests:'**
  String get tagsDesc;

  /// No description provided for @noTagsSpecified.
  ///
  /// In en, this message translates to:
  /// **'Please specify at least one of your interests'**
  String get noTagsSpecified;

  /// No description provided for @verifyEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify your Email'**
  String get verifyEmail;

  /// No description provided for @verifyEmailBody.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification email to {email}'**
  String verifyEmailBody(Object email);

  /// No description provided for @emailTokenLabel.
  ///
  /// In en, this message translates to:
  /// **'Your verification code'**
  String get emailTokenLabel;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'Unexpected error'**
  String get unexpectedError;

  /// No description provided for @unauthorizedLoginError.
  ///
  /// In en, this message translates to:
  /// **'Credentials are invalid. Please try again.'**
  String get unauthorizedLoginError;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logout;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Log out of Aura?'**
  String get confirmLogout;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @allowInvites.
  ///
  /// In en, this message translates to:
  /// **'Allow Invites'**
  String get allowInvites;

  /// No description provided for @allowInvitesDesc.
  ///
  /// In en, this message translates to:
  /// **'Allow invites and DMs from other users.'**
  String get allowInvitesDesc;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Toggle dark mode theme.'**
  String get darkModeDesc;

  /// No description provided for @animations.
  ///
  /// In en, this message translates to:
  /// **'Animations'**
  String get animations;

  /// No description provided for @animationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable animations.'**
  String get animationsDesc;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notifyInvites.
  ///
  /// In en, this message translates to:
  /// **'Notify for Invites'**
  String get notifyInvites;

  /// No description provided for @notifyInvitesDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications for invites.'**
  String get notifyInvitesDesc;

  /// No description provided for @notifyMessages.
  ///
  /// In en, this message translates to:
  /// **'Notify for Messages'**
  String get notifyMessages;

  /// No description provided for @notifyMessagesDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications for direct messages.'**
  String get notifyMessagesDesc;

  /// No description provided for @notifyComments.
  ///
  /// In en, this message translates to:
  /// **'Notify for Comments'**
  String get notifyComments;

  /// No description provided for @notifyCommentsDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications for comments on your posts.'**
  String get notifyCommentsDesc;

  /// No description provided for @algorithm.
  ///
  /// In en, this message translates to:
  /// **'Algorithm'**
  String get algorithm;

  /// No description provided for @algoLikeWeight.
  ///
  /// In en, this message translates to:
  /// **'Algorithm Like Weight'**
  String get algoLikeWeight;

  /// No description provided for @algoLikeWeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Weight of likes in the algorithm. Higher values can get you into filter bubbles.'**
  String get algoLikeWeightDesc;

  /// No description provided for @algoDislikeWeight.
  ///
  /// In en, this message translates to:
  /// **'Algorithm Dislike Weight.'**
  String get algoDislikeWeight;

  /// No description provided for @algoDislikeWeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Weight of dislikes in the algorithm. Lower values can get you into filter bubbles.'**
  String get algoDislikeWeightDesc;

  /// No description provided for @algoCommentWeight.
  ///
  /// In en, this message translates to:
  /// **'Algorithm Comment Weight'**
  String get algoCommentWeight;

  /// No description provided for @algoCommentWeightDesc.
  ///
  /// In en, this message translates to:
  /// **'Weight of comments in the algorithm. Higher values can recommend you rage-bait posts.'**
  String get algoCommentWeightDesc;

  /// No description provided for @algoTimeDecay.
  ///
  /// In en, this message translates to:
  /// **'Algorithm Time Decay'**
  String get algoTimeDecay;

  /// No description provided for @algoTimeDecayDesc.
  ///
  /// In en, this message translates to:
  /// **'Time weight decay of posts. Higher values will give you more recent posts.'**
  String get algoTimeDecayDesc;

  /// No description provided for @resetAlgo.
  ///
  /// In en, this message translates to:
  /// **'Reset Algorithm'**
  String get resetAlgo;

  /// No description provided for @resetAlgoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Algorithm Reset'**
  String get resetAlgoConfirm;

  /// No description provided for @resetAlgoConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reset your algorithm? This action cannot be undone.'**
  String get resetAlgoConfirmBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
