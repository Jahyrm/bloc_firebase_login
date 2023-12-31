part of 'login_cubit.dart';

enum FormStatus { initial, loading, success, validationFail, failure }

final class LoginState extends Equatable {
  const LoginState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.status = FormStatus.initial,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool obscurePassword;
  final FormStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        email,
        password,
        obscurePassword,
        status,
        errorMessage,
      ];

  LoginState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    FormStatus? status,
    String? errorMessage,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
