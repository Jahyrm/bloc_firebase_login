// ignore_for_file: prefer_const_constructors
import 'package:bloc_firebase_login/app/main/bloc/auth_bloc.dart';
import 'package:bloc_firebase_login/app/main/models/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AppState', () {
    group('unauthenticated', () {
      test('tiene el estado correcto', () {
        final state = AuthState.unauthenticated();
        expect(state.status, AuthStatus.unauthenticated);
        expect(state.user, User.empty);
      });
    });

    group('authenticated', () {
      test('tiene el estado correcto', () {
        final user = MockUser();
        final state = AuthState.authenticated(user);
        expect(state.status, AuthStatus.authenticated);
        expect(state.user, user);
      });
    });
  });
}
