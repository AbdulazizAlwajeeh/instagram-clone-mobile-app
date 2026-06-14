import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/app_user.dart';
part 'current_user_state.dart';

class CurrentUserCubit extends Cubit<CurrentUserState> {
  CurrentUserCubit() : super(const CurrentUserInitial());

  /// Updates the global session state with the authenticated user data.
  void updateUser(AppUser? user) {
    if (user == null) {
      emit(const CurrentUserInitial());
    } else {
      emit(CurrentUserLoggedIn(user));
    }
  }

  /// Explicit convenience method to instantly clear runtime identity states.
  void clearUser() {
    emit(const CurrentUserInitial());
  }
}
