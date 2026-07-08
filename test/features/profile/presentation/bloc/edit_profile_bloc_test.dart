import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yemengram/core/error/failures.dart';
import 'package:yemengram/features/profile/domain/usecases/check_username_availability.dart';
import 'package:yemengram/features/profile/domain/usecases/edit_profile.dart';
import 'package:yemengram/features/profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:yemengram/features/profile/presentation/bloc/edit_profile_event.dart';
import 'package:yemengram/features/profile/presentation/bloc/edit_profile_state.dart';

class MockEditProfile extends Mock implements EditProfile {}

class MockCheckUsernameAvailability extends Mock
    implements CheckUsernameAvailability {}

void main() {
  late EditProfileBloc editProfileBloc;
  late MockEditProfile mockEditProfile;
  late MockCheckUsernameAvailability mockCheckUsernameAvailability;

  setUpAll(() {
    registerFallbackValue(const EditProfileParams());
  });

  setUp(() {
    mockEditProfile = MockEditProfile();
    mockCheckUsernameAvailability = MockCheckUsernameAvailability();
    editProfileBloc = EditProfileBloc(
      editProfile: mockEditProfile,
      checkUsernameAvailability: mockCheckUsernameAvailability,
    );
  });

  tearDown(() {
    editProfileBloc.close();
  });

  test('initial state should be EditProfileInitial', () {
    expect(editProfileBloc.state, isA<EditProfileInitial>());
  });

  group('EditProfileUsernameChanged tracking lookups', () {
    blocTest<EditProfileBloc, EditProfileState>(
      'emits EditProfileInitial instantly when incoming text parameter is empty',
      build: () => editProfileBloc,
      act: (bloc) =>
          bloc.add(const EditProfileUsernameChanged(username: '   ')),
      wait: const Duration(milliseconds: 600),
      expect: () => [isA<EditProfileInitial>()],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [EditProfileUsernameChecking, EditProfileUsernameAvailable] when checked handle is available',
      build: () {
        when(
          () => mockCheckUsernameAvailability(any(that: isA<String>())),
        ).thenAnswer((_) async => const Right(true));
        return editProfileBloc;
      },
      act: (bloc) =>
          bloc.add(const EditProfileUsernameChanged(username: 'yemen_dev')),
      // Forces the stream clock frame ahead of the 500ms debounce threshold
      wait: const Duration(milliseconds: 600),
      expect: () => [
        isA<EditProfileUsernameChecking>(),
        isA<EditProfileUsernameAvailable>(),
      ],
      verify: (_) {
        verify(() => mockCheckUsernameAvailability('yemen_dev')).called(1);
      },
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [EditProfileUsernameChecking, EditProfileUsernameTaken] when checked handle is already claimed',
      build: () {
        when(
          () => mockCheckUsernameAvailability(any(that: isA<String>())),
        ).thenAnswer((_) async => const Right(false));
        return editProfileBloc;
      },
      act: (bloc) =>
          bloc.add(const EditProfileUsernameChanged(username: 'taken_handle')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        isA<EditProfileUsernameChecking>(),
        isA<EditProfileUsernameTaken>(),
      ],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [EditProfileUsernameChecking, EditProfileFailure] when availability check drops offline',
      build: () {
        when(
          () => mockCheckUsernameAvailability(any(that: isA<String>())),
        ).thenAnswer((_) async => const Left(ServerFailure('Timeout error')));
        return editProfileBloc;
      },
      act: (bloc) =>
          bloc.add(const EditProfileUsernameChanged(username: 'error_trigger')),
      wait: const Duration(milliseconds: 600),
      expect: () => [
        isA<EditProfileUsernameChecking>(),
        isA<EditProfileFailure>().having(
          (s) => s.errorMessage,
          'error details matching',
          'Timeout error',
        ),
      ],
    );
  });

  group('EditProfileSubmitted updates execution block', () {
    const tSubmittedEvent = EditProfileSubmitted(
      username: 'new_name',
      fullName: 'New Full Name',
      bio: 'New Bio Details',
      imageFile: null,
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [EditProfileSubmitting, EditProfileSuccess] when use case updates successfully',
      build: () {
        when(
          () => mockEditProfile(any(that: isA<EditProfileParams>())),
        ).thenAnswer((_) async => const Right(unit));
        return editProfileBloc;
      },
      act: (bloc) => bloc.add(tSubmittedEvent),
      expect: () => [isA<EditProfileSubmitting>(), isA<EditProfileSuccess>()],
    );

    blocTest<EditProfileBloc, EditProfileState>(
      'emits [EditProfileSubmitting, EditProfileFailure] when submission payload is rejected by repository layers',
      build: () {
        when(
          () => mockEditProfile(any(that: isA<EditProfileParams>())),
        ).thenAnswer(
          (_) async => const Left(ServerFailure('Invalid profile inputs')),
        );
        return editProfileBloc;
      },
      act: (bloc) => bloc.add(tSubmittedEvent),
      expect: () => [
        isA<EditProfileSubmitting>(),
        isA<EditProfileFailure>().having(
          (s) => s.errorMessage,
          'error message validation matches',
          'Invalid profile inputs',
        ),
      ],
    );
  });
}
