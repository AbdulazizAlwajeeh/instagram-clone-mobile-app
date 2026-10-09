// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get signupPageLink => 'ليس لديك حساب؟ سجل الآن';

  @override
  String get signupButton => 'تسجيل الحساب';

  @override
  String get loginPageLink => 'لديك حساب؟ سجل الدخول';

  @override
  String get usernameTextFieldHint => 'اسم المستخدم';

  @override
  String get emailTextFieldHint => 'البريد الإلكتروني';

  @override
  String get passwordTextFieldHint => 'كلمة المرور';

  @override
  String get invalidCredentialsErrorMessage =>
      'البريد أو كلمة المرور غير صحيحة.';

  @override
  String get emailAlreadyUsedErrorMessage =>
      'هذا البريد إما محجوز أو يحتاج لتأكيد، تأكد من صندوق الوارد.';

  @override
  String get usernameAlreadyUsedErrorMessage => 'اسم المستخدم هذا محجوز.';

  @override
  String successfulLoginMessage(Object username) {
    return 'مرحبا بعودتك، $username';
  }

  @override
  String get likesCounter => 'إعجابات';

  @override
  String commentsLink(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إظهار $count تعليقات',
      one: 'إظهار تعليق 1',
      zero: 'لم يعلق أحد بعد',
    );
    return '$_temp0';
  }

  @override
  String get commentsSheetTitle => 'التعليقات';

  @override
  String get commentTextFieldHint => 'أضف تعليقا...';

  @override
  String get publishCommentButton => 'انشر';

  @override
  String get singlePostTitle => 'المنشور';

  @override
  String get reportPostOption => 'أبلغ عن المنشور';

  @override
  String get reportPostSuccessMessage => 'تم الإبلاغ عن المنشور بنجاح';

  @override
  String get searchTextFieldHint => 'ابحث';

  @override
  String get publishPostPageTitle => 'إنشاء منشور';

  @override
  String get publishPostButton => 'انشر';

  @override
  String get chooseImageOptionsButton => 'اضغط لرفع صورة أو شريط';

  @override
  String get postCaptionTextFieldHint => 'اكتب وصفا...';

  @override
  String get chooseFromGalleryOption => 'اختر من المعرض';

  @override
  String get takeAPhotoOption => 'افتح الكاميرا';

  @override
  String get publishPostSuccessMessage => 'تم رفع المنشور بنجاح';

  @override
  String get chatPageTitle => 'الرسائل';

  @override
  String get sendMessageTextFieldHint => 'اكتب رسالتك...';

  @override
  String get profilePostsCounter => 'المنشورات';

  @override
  String get profileFollowersCounter => 'المتابِعون';

  @override
  String get profileFollowingCounter => 'المتابَعون';

  @override
  String get editProfileButton => 'عدل صفحتك';

  @override
  String get editProfilePageTitle => 'تعديل الصفحة';

  @override
  String get fullNameTextFieldHint => 'الاسم الكامل';

  @override
  String get editUsernameTextFieldLabel => 'اسم المستخدم';

  @override
  String get editUsernameErrorMessage => 'هذا الاسم محجوز';

  @override
  String get bioTextFieldHint => 'نبذة';

  @override
  String get saveProfileEditionsButton => 'احفظ';

  @override
  String get settingsPageTitle => 'الإعدادات';

  @override
  String get preferencesTitle => 'التفضيلات';

  @override
  String get accountActionsTitle => 'إجراءات الحساب';

  @override
  String get darkThemeOption => 'الوضع الليلي';

  @override
  String get languageOption => 'اللغة';

  @override
  String get signOutOption => 'تسجيل الخروج';

  @override
  String get signOutConfirmationTitle => 'تسجيل الخروج';

  @override
  String get signOutConfirmationDescription =>
      'هل أنت متأكد من أنك تريد تسجيل الخروج؟';

  @override
  String get signOutConfirmationButton => 'خروج';

  @override
  String get cancelButton => 'إلغاء';
}
