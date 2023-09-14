import 'package:bloc_firebase_login/app/login/screens/login_form.dart';
import 'package:bloc_firebase_login/app/login/screens/login_screen.dart';
import 'package:bloc_firebase_login/core/repositories/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('LoginScreen', () {
    testWidgets('Renderiza un LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => MockAuthenticationRepository(),
          child: const MaterialApp(home: LoginScreen()),
        ),
      );
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
