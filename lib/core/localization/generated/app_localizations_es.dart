// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get loginButton => 'Iniciar sesión';

  @override
  String get signupPageLink => '¿No tienes una cuenta? Regístrate';

  @override
  String get signupButton => 'Registrarse';

  @override
  String get loginPageLink => '¿Ya tienes una cuenta? Inicia sesión';

  @override
  String get usernameTextFieldHint => 'Nombre de usuario';

  @override
  String get emailTextFieldHint => 'Correo electrónico';

  @override
  String get passwordTextFieldHint => 'Contraseña';

  @override
  String get invalidCredentialsErrorMessage =>
      'Correo electrónico o contraseña incorrectos.';

  @override
  String get emailAlreadyUsedErrorMessage =>
      'Este correo ya está registrado o necesita confirmación. Revisa tu bandeja de entrada.';

  @override
  String get usernameAlreadyUsedErrorMessage =>
      'Este nombre de usuario ya está registrado.';

  @override
  String successfulLoginMessage(Object username) {
    return '¡Hola de nuevo, $username!';
  }

  @override
  String get likesCounter => 'me gusta';

  @override
  String commentsLink(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ver los $count comentarios',
      one: 'Ver 1 comentario',
      zero: 'Nadie ha comentado aún',
    );
    return '$_temp0';
  }

  @override
  String get commentsSheetTitle => 'Comentarios';

  @override
  String get commentTextFieldHint => 'Añade un comentario...';

  @override
  String get publishCommentButton => 'Publicar';

  @override
  String get singlePostTitle => 'Publicación';

  @override
  String get reportPostOption => 'Reportar publicación';

  @override
  String get reportPostSuccessMessage => 'Publicación reportada con éxito';

  @override
  String get searchTextFieldHint => 'Buscar';

  @override
  String get publishPostPageTitle => 'Nueva publicación';

  @override
  String get publishPostButton => 'Publicar';

  @override
  String get chooseImageOptionsButton => 'Toca para subir fotos o videos';

  @override
  String get postCaptionTextFieldHint => 'Escribe un pie de foto...';

  @override
  String get chooseFromGalleryOption => 'Elegir de la galería';

  @override
  String get takeAPhotoOption => 'Tomar una foto';

  @override
  String get publishPostSuccessMessage => 'Publicación publicada con éxito';

  @override
  String get chatPageTitle => 'Mensajes';

  @override
  String get sendMessageTextFieldHint => 'Mensaje...';

  @override
  String get profilePostsCounter => 'Publicaciones';

  @override
  String get profileFollowersCounter => 'Seguidores';

  @override
  String get profileFollowingCounter => 'Seguidos';

  @override
  String get editProfileButton => 'Editar perfil';

  @override
  String get editProfilePageTitle => 'Editar perfil';

  @override
  String get fullNameTextFieldHint => 'Nombre completo';

  @override
  String get editUsernameTextFieldLabel => 'Nombre de usuario';

  @override
  String get editUsernameErrorMessage =>
      'Este nombre de usuario ya está en uso';

  @override
  String get bioTextFieldHint => 'Biografía';

  @override
  String get saveProfileEditionsButton => 'Guardar';

  @override
  String get settingsPageTitle => 'Configuración';

  @override
  String get preferencesTitle => 'Preferencias';

  @override
  String get accountActionsTitle => 'Acciones de la cuenta';

  @override
  String get darkThemeOption => 'Tema oscuro';

  @override
  String get languageOption => 'Idioma';

  @override
  String get signOutOption => 'Cerrar sesión';

  @override
  String get signOutConfirmationTitle => 'Cerrar sesión';

  @override
  String get signOutConfirmationDescription =>
      '¿Confirmas que quieres cerrar sesión en tu cuenta?';

  @override
  String get signOutConfirmationButton => 'Cerrar sesión';

  @override
  String get cancelButton => 'Cancelar';
}
