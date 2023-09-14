// ignore_for_file: prefer_const_constructors, must_be_immutable
import 'package:bloc_firebase_login/app/main/bloc/auth_bloc.dart';
import 'package:bloc_firebase_login/app/main/models/user.dart';
import 'package:bloc_firebase_login/core/repositories/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockUser extends Mock implements User {}

void main() {
  group('AuthBloc', () {
    final user = MockUser();
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.user).thenAnswer(
        (_) => Stream.empty(),
      );
      when(
        () => authenticationRepository.currentUser,
      ).thenReturn(User.empty);
    });

    test('el estado inicial no está autenticado cuando el usuario está vacío',
        () {
      expect(
        AuthBloc(authenticationRepository: authenticationRepository).state,
        AuthState.unauthenticated(),
      );
    });

    group('UserChanged', () {
      blocTest<AuthBloc, AuthState>(
        'emite autenticado cuando el usuario no está vacío',
        setUp: () {
          when(() => user.isNotEmpty).thenReturn(true);
          when(() => authenticationRepository.user).thenAnswer(
            (_) => Stream.value(user),
          );
        },
        build: () => AuthBloc(
          authenticationRepository: authenticationRepository,
        ),
        seed: AuthState.unauthenticated,
        expect: () => [AuthState.authenticated(user)],
      );

      blocTest<AuthBloc, AuthState>(
        'emite no autenticado cuando el usuario está vacío',
        setUp: () {
          when(() => authenticationRepository.user).thenAnswer(
            (_) => Stream.value(User.empty),
          );
        },
        build: () => AuthBloc(
          authenticationRepository: authenticationRepository,
        ),
        expect: () => [AuthState.unauthenticated()],
      );
    });

    group('LogoutRequested', () {
      blocTest<AuthBloc, AuthState>(
        'invoca cerrar sesión',
        setUp: () {
          when(
            () => authenticationRepository.logOut(),
          ).thenAnswer((_) async {});
        },
        build: () => AuthBloc(
          authenticationRepository: authenticationRepository,
        ),
        act: (bloc) => bloc.add(AppLogoutRequested()),
        verify: (_) {
          verify(() => authenticationRepository.logOut()).called(1);
        },
      );
    });
  });
}
