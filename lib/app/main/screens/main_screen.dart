import 'package:bloc_firebase_login/core/configs/app_themes.dart';
import 'package:bloc_firebase_login/core/resources/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/authentication_repository.dart';
import '../../login/screens/login_screen.dart';
import '../bloc/auth_bloc.dart';

class MainApp extends StatelessWidget {
  const MainApp({
    required AuthenticationRepository authenticationRepository,
    super.key,
  }) : _authenticationRepository = authenticationRepository;

  final AuthenticationRepository _authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthBloc(
          authenticationRepository: _authenticationRepository,
        ),
        child: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFire BLoC Login',
      theme: AppThemes.lightTheme,
      onGenerateRoute:
          AppRouter(bloc: context.read<AuthBloc>()).onGenerateRoute,
      initialRoute:
          context.read<AuthBloc>().state.status == AuthStatus.authenticated
              ? LoginScreen.routeName
              : LoginScreen.routeName,
    );
  }
}
