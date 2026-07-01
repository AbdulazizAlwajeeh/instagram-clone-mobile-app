import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_user.dart';

part 'current_user_state.dart';

/// A global presentation-layer Cubit that manages and exposes the current user's session state.
///
/// This resides in core because authenticated user details are consumed reactively
/// across almost all features to update the UI or guard routes.
class CurrentUserCubit extends Cubit<CurrentUserState> {
  /// Initializes the Cubit with an unauthenticated [CurrentUserInitial] state.
  CurrentUserCubit() : super(const CurrentUserInitial());

  /// Updates the global session state with the authenticated user data.
  ///
  /// Emits [CurrentUserInitial] if the [user] parameter is null (indicating no active session).
  /// Emits [CurrentUserLoggedIn] with the provided user details if authentication is valid.
  void updateUser(AppUser? user) {
    if (user == null) {
      emit(const CurrentUserInitial());
    } else {
      emit(CurrentUserLoggedIn(user));
    }
  }

  /// Explicit convenience method to instantly clear runtime identity states.
  ///
  /// Reverts the application back to the unauthenticated [CurrentUserInitial] state (e.g., during logout).
  void clearUser() {
    emit(const CurrentUserInitial());
  }
}
