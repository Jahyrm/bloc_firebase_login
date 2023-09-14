import 'package:bloc_firebase_login/app/home/screens/home_screen.dart';
import 'package:bloc_firebase_login/app/login/screens/login_screen.dart';
import 'package:bloc_firebase_login/app/main/bloc/auth_bloc.dart';
import 'package:bloc_firebase_login/app/main/models/user.dart';
import 'package:bloc_firebase_login/app/main/screens/main_screen.dart';
import 'package:bloc_firebase_login/core/repositories/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class MockAppBloc extends MockBloc<AuthEvent, AuthState> implements AuthBloc {}

void main() {
  group('AppView', () {
    late AuthenticationRepository authenticationRepository;
    late AuthBloc appBloc;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      appBloc = MockAppBloc();
    });

    testWidgets(
        'Navega a la página de inicio de sesión cuando no está autenticado',
        (tester) async {
      when(() => appBloc.state).thenReturn(const AuthState.unauthenticated());
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const MainScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('Navega a HomePage cuando está autenticado', (tester) async {
      final user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AuthState.authenticated(user));
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(
            home: BlocProvider.value(value: appBloc, child: const MainScreen()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}
