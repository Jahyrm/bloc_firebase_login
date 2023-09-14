part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

final class AppLogoutRequested extends AuthEvent {
  const AppLogoutRequested();
}

final class AppUserChanged extends AuthEvent {
  const AppUserChanged(this.user);

  final User user;
}
