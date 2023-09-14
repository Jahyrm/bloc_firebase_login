import 'package:bloc_firebase_login/app/home/screens/home_screen.dart';
import 'package:bloc_firebase_login/app/login/screens/login_screen.dart';
import 'package:bloc_firebase_login/app/main/bloc/auth_bloc.dart';
import 'package:bloc_firebase_login/app/sign_up/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Part 8: Extra knowledge
/// When we navigate to different screens, thanks to this class you can
/// always use the AuthBloc
class AppRouter {
  AppRouter({required AuthBloc bloc}) : _authBloc = bloc;

  final AuthBloc _authBloc;

  Route? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: const HomeScreen(),
          ),
        );
      case LoginScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: const LoginScreen(),
          ),
        );
      case SignUpScreen.routeName:
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: _authBloc,
            child: const SignUpScreen(),
          ),
        );
      default:
        return null;
    }
  }

  void dispose() {
    _authBloc.close();
  }
}
