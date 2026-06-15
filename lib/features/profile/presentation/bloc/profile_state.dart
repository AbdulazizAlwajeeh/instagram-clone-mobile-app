import '../../domain/entities/user_profile.dart';

sealed class ProfileState {
  const ProfileState();
}

/// Initial state of the state machine upon structural instantiation.
class ProfileInitial extends ProfileState {}

/// Core visual blocker state while async processing channels execute.
class ProfileLoading extends ProfileState {}

/// Success milestone holding full public profile values.
class ProfileLoadSuccess extends ProfileState {
  final UserProfile profile;
  final bool isMe;

  const ProfileLoadSuccess({required this.profile, required this.isMe});
}

/// Failure boundary capturing operational exceptions.
class ProfileLoadFailure extends ProfileState {
  final String errorMessage;

  const ProfileLoadFailure({required this.errorMessage});
}
