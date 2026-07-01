import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/app_user/presentation/cubit/current_user_cubit.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/user_sign_in.dart';
import '../../domain/usecases/user_sign_out.dart';
import '../../domain/usecases/user_sign_up.dart';
import '/core/usecase/usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Presentation layer coordinator orchestrating account security sessions and state streams.
///
/// Intercepts inbound [AuthEvent] user interactions, executes targeted domain business rules
/// via injected use cases, and surfaces unmodifiable [AuthState] profiles to the UI layer.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final GetCurrentUser _getCurrentUser;
  final UserSignOut _userSignOut;
  final CurrentUserCubit _currentUserCubit;

  /// Instantiates the core authentication supervisor framework and registers granular event mappings.
  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required GetCurrentUser getCurrentUser,
    required UserSignOut userSignOut,
    required CurrentUserCubit currentUserCubit,
  }) : _userSignUp = userSignUp,
       _userSignIn = userSignIn,
       _getCurrentUser = getCurrentUser,
       _userSignOut = userSignOut,
       _currentUserCubit = currentUserCubit,
       super(AuthInitial()) {
    on<AuthSignUp>(_onSignUp);
    on<AuthSignIn>(_onSignIn);
    on<AuthCheckSession>(_onCheckSession);
    on<AuthSignOut>(_onSignOut);
  }

  /// Manages registration intents by packaging field variables into a domain use case challenge.
  Future<void> _onSignUp(AuthSignUp event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _userSignUp(
      SignUpParams(
        email: event.email,
        password: event.password,
        username: event.username,
      ),
    );

    result.fold((failure) => emit(AuthFailure(failure.message)), (user) {
      emit(
        SignUpSuccess(),
      ); // Signals presentation widgets to show verification or advance forms.
    });
  }

  /// Processes credential verification lookups and handles synchronization with the global identity cubit.
  Future<void> _onSignIn(AuthSignIn event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _userSignIn(
      SignInParams(email: event.email, password: event.password),
    );

    result.fold((failure) => emit(AuthFailure(failure.message)), (user) {
      // Hydrates the long-running application-wide session scope tracker.
      _currentUserCubit.updateUser(user);
      emit(AuthSuccess(user));
    });
  }

  /// Evaluates local token storage metrics during system cold boots to determine onboarding routing targets.
  Future<void> _onCheckSession(
    AuthCheckSession event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await _getCurrentUser(NoParams());

    result.fold((failure) => emit(AuthFailure(failure.message)), (user) {
      if (user == null) {
        _currentUserCubit
            .clearUser(); // Evicts stale user records if the session verification check returns empty.
        emit(AuthInitial());
      } else {
        _currentUserCubit.updateUser(
          user,
        ); // Restores verified profile parameters safely back into runtime context lines.
        emit(AuthSuccess(user));
      }
    });
  }

  /// Triggers a complete network session tear-down and flushes locally active credentials matrices.
  Future<void> _onSignOut(AuthSignOut event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    final result = await _userSignOut(NoParams());

    result.fold(
      (failure) => emit(AuthFailure(failure.message)),
      (_) {
        _currentUserCubit
            .clearUser(); // Flushes long-running memory state variables.
        emit(AuthInitial());
      }, // Successful sign-out routes back to Initial/Unauthenticated state
    );
  }
}
