// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get loginButton => 'Log In';

  @override
  String get signupPageLink => 'Don\'t have an account? Sign Up';

  @override
  String get signupButton => 'Sign Up';

  @override
  String get loginPageLink => 'Already have an account? Log In';

  @override
  String get usernameTextFieldHint => 'Username';

  @override
  String get emailTextFieldHint => 'Email';

  @override
  String get passwordTextFieldHint => 'Password';

  @override
  String get invalidCredentialsErrorMessage => 'Incorrect email/password.';

  @override
  String get emailAlreadyUsedErrorMessage =>
      'This email is either already reserved or needs confirmation, check your inbox.';

  @override
  String get usernameAlreadyUsedErrorMessage =>
      'This username is already reserved.';

  @override
  String successfulLoginMessage(Object username) {
    return 'Welcome back, $username';
  }

  @override
  String get likesCounter => 'likes';

  @override
  String commentsLink(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'View all $count comments',
      one: 'View 1 comment',
      zero: 'Nobody has commented yet',
    );
    return '$_temp0';
  }

  @override
  String get commentsSheetTitle => 'Comments';

  @override
  String get commentTextFieldHint => 'Add a comment...';

  @override
  String get publishCommentButton => 'Post';

  @override
  String get singlePostTitle => 'Post';

  @override
  String get reportPostOption => 'Report Post';

  @override
  String get reportPostSuccessMessage => 'Post successfully reported';

  @override
  String get searchTextFieldHint => 'Search';

  @override
  String get publishPostPageTitle => 'New Post';

  @override
  String get publishPostButton => 'Publish';

  @override
  String get chooseImageOptionsButton => 'Tap to upload photos or videos';

  @override
  String get postCaptionTextFieldHint => 'Write a caption...';

  @override
  String get chooseFromGalleryOption => 'Choose from Gallery';

  @override
  String get takeAPhotoOption => 'Take a Photo';

  @override
  String get publishPostSuccessMessage => 'Post successfully published';

  @override
  String get chatPageTitle => 'Messages';

  @override
  String get sendMessageTextFieldHint => 'Message...';

  @override
  String get profilePostsCounter => 'Posts';

  @override
  String get profileFollowersCounter => 'Followers';

  @override
  String get profileFollowingCounter => 'Following';

  @override
  String get editProfileButton => 'Edit Profile';

  @override
  String get editProfilePageTitle => 'Edit Profile';

  @override
  String get fullNameTextFieldHint => 'Full Name';

  @override
  String get editUsernameTextFieldLabel => 'Username';

  @override
  String get editUsernameErrorMessage => 'This username is already taken';

  @override
  String get bioTextFieldHint => 'Bio';

  @override
  String get saveProfileEditionsButton => 'Save';

  @override
  String get settingsPageTitle => 'Settings';

  @override
  String get preferencesTitle => 'Preferences';

  @override
  String get accountActionsTitle => 'Account Actions';

  @override
  String get darkThemeOption => 'Dark Theme';

  @override
  String get languageOption => 'Language';

  @override
  String get signOutOption => 'Sign Out';

  @override
  String get signOutConfirmationTitle => 'Sign Out';

  @override
  String get signOutConfirmationDescription =>
      'Are you sure you want to log out of your account?';

  @override
  String get signOutConfirmationButton => 'Sign Out';

  @override
  String get cancelButton => 'Cancel';
}
