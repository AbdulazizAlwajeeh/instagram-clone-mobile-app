import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/user_sign_in.dart';
import '../../domain/usecases/user_sign_out.dart';
import '../../domain/usecases/user_sign_up.dart';
import '/core/usecase/usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final GetCurrentUser _getCurrentUser;
  final UserSignOut _userSignOut;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required GetCurrentUser getCurrentUser,
    required UserSignOut userSignOut,
  }) : _userSignUp = userSignUp,
       _userSignIn = userSignIn,
       _getCurrentUser = getCurrentUser,
       _userSignOut = userSignOut,
       super(AuthInitial()) {
    on<AuthSignUp>(_onSignUp);
    on<AuthSignIn>(_onSignIn);
    on<AuthCheckSession>(_onCheckSession);
    on<AuthSignOut>(_onSignOut);
  }

  Future<void> _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _userSignUp(
      SignUpParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _userSignIn(
      SignInParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> _onCheckSession(
    AuthCheckSession event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await _getCurrentUser(NoParams());
    result.fold((failure) => emit(AuthFailure(failure.message)), (user) {
      if (user == null) {
        emit(AuthInitial());
      } else {
        emit(AuthSuccess(user));
      }
    });
  }

  Future<void> _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await _userSignOut(NoParams());
    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) => emit(
        AuthInitial(),
      ), // Successful sign-out routes back to Initial/Unauthenticated state
    );
  }
}
