// ignore_for_file: prefer_const_constructors
import 'package:bloc_firebase_login/app/login/cubit/login_cubit.dart';
import 'package:bloc_firebase_login/core/repositories/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const invalidEmailString = 'invalid';
  const invalidEmail = invalidEmailString;

  const invalidPasswordString = 'invalid';
  const invalidPassword = invalidPasswordString;

  group('LoginCubit', () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(
        () => authenticationRepository.logInWithEmailAndPassword(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async {});
    });

    test('el estado inicial es LoginState', () {
      expect(LoginCubit(authenticationRepository).state, LoginState());
    });

    group('emailChanged', () {
      blocTest<LoginCubit, LoginState>(
        'emails change',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.emailChanged(invalidEmailString),
        expect: () => const <LoginState>[LoginState(email: invalidEmail)],
      );
    });

    group('passwordChanged', () {
      blocTest<LoginCubit, LoginState>(
        'password cambia',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.passwordChanged(invalidPasswordString),
        expect: () => const <LoginState>[LoginState(password: invalidPassword)],
      );
    });

    group('logInWithCredentials', () {
      blocTest<LoginCubit, LoginState>(
        'no hace nada',
        build: () => LoginCubit(authenticationRepository),
        act: (cubit) => cubit.logInWithCredentials(),
        expect: () => const <LoginState>[
          LoginState(
            status: FormStatus.validationFail,
          )
        ],
      );
    });
  });
}
