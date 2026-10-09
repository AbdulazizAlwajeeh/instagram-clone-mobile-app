import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get loginButton;

  /// No description provided for @signupPageLink.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign Up'**
  String get signupPageLink;

  /// No description provided for @signupButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signupButton;

  /// No description provided for @loginPageLink.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Log In'**
  String get loginPageLink;

  /// No description provided for @usernameTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameTextFieldHint;

  /// No description provided for @emailTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailTextFieldHint;

  /// No description provided for @passwordTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordTextFieldHint;

  /// No description provided for @invalidCredentialsErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email/password.'**
  String get invalidCredentialsErrorMessage;

  /// No description provided for @emailAlreadyUsedErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'This email is either already reserved or needs confirmation, check your inbox.'**
  String get emailAlreadyUsedErrorMessage;

  /// No description provided for @usernameAlreadyUsedErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'This username is already reserved.'**
  String get usernameAlreadyUsedErrorMessage;

  /// No description provided for @successfulLoginMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {username}'**
  String successfulLoginMessage(Object username);

  /// No description provided for @likesCounter.
  ///
  /// In en, this message translates to:
  /// **'likes'**
  String get likesCounter;

  /// No description provided for @commentsLink.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Nobody has commented yet} =1{View 1 comment} other{View all {count} comments}}'**
  String commentsLink(num count);

  /// No description provided for @commentsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get commentsSheetTitle;

  /// No description provided for @commentTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get commentTextFieldHint;

  /// No description provided for @publishCommentButton.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get publishCommentButton;

  /// No description provided for @singlePostTitle.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get singlePostTitle;

  /// No description provided for @reportPostOption.
  ///
  /// In en, this message translates to:
  /// **'Report Post'**
  String get reportPostOption;

  /// No description provided for @reportPostSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Post successfully reported'**
  String get reportPostSuccessMessage;

  /// No description provided for @searchTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTextFieldHint;

  /// No description provided for @publishPostPageTitle.
  ///
  /// In en, this message translates to:
  /// **'New Post'**
  String get publishPostPageTitle;

  /// No description provided for @publishPostButton.
  ///
  /// In en, this message translates to:
  /// **'Publish'**
  String get publishPostButton;

  /// No description provided for @chooseImageOptionsButton.
  ///
  /// In en, this message translates to:
  /// **'Tap to upload photos or videos'**
  String get chooseImageOptionsButton;

  /// No description provided for @postCaptionTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Write a caption...'**
  String get postCaptionTextFieldHint;

  /// No description provided for @chooseFromGalleryOption.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGalleryOption;

  /// No description provided for @takeAPhotoOption.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takeAPhotoOption;

  /// No description provided for @publishPostSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Post successfully published'**
  String get publishPostSuccessMessage;

  /// No description provided for @chatPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get chatPageTitle;

  /// No description provided for @sendMessageTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Message...'**
  String get sendMessageTextFieldHint;

  /// No description provided for @profilePostsCounter.
  ///
  /// In en, this message translates to:
  /// **'Posts'**
  String get profilePostsCounter;

  /// No description provided for @profileFollowersCounter.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get profileFollowersCounter;

  /// No description provided for @profileFollowingCounter.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get profileFollowingCounter;

  /// No description provided for @editProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileButton;

  /// No description provided for @editProfilePageTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfilePageTitle;

  /// No description provided for @fullNameTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameTextFieldHint;

  /// No description provided for @editUsernameTextFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get editUsernameTextFieldLabel;

  /// No description provided for @editUsernameErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'This username is already taken'**
  String get editUsernameErrorMessage;

  /// No description provided for @bioTextFieldHint.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bioTextFieldHint;

  /// No description provided for @saveProfileEditionsButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveProfileEditionsButton;

  /// No description provided for @settingsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsPageTitle;

  /// No description provided for @preferencesTitle.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesTitle;

  /// No description provided for @accountActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Actions'**
  String get accountActionsTitle;

  /// No description provided for @darkThemeOption.
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkThemeOption;

  /// No description provided for @languageOption.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageOption;

  /// No description provided for @signOutOption.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutOption;

  /// No description provided for @signOutConfirmationTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutConfirmationTitle;

  /// No description provided for @signOutConfirmationDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get signOutConfirmationDescription;

  /// No description provided for @signOutConfirmationButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOutConfirmationButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;
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
      <String>['ar', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
