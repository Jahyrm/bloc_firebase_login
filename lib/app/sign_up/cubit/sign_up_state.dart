part of 'sign_up_cubit.dart';

final class SignUpState extends Equatable {
  const SignUpState({
    this.email = '',
    this.password = '',
    this.obscurePassword = true,
    this.confirmedPassword = '',
    this.obscureConfirmedPassword = true,
    this.status = FormStatus.initial,
    this.errorMessage,
  });

  final String email;
  final String password;
  final bool obscurePassword;
  final String confirmedPassword;
  final bool obscureConfirmedPassword;
  final FormStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        email,
        password,
        obscurePassword,
        confirmedPassword,
        obscureConfirmedPassword,
        status,
        errorMessage,
      ];

  SignUpState copyWith({
    String? email,
    String? password,
    bool? obscurePassword,
    String? confirmedPassword,
    bool? obscureConfirmedPassword,
    FormStatus? status,
    String? errorMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      obscureConfirmedPassword:
          obscureConfirmedPassword ?? this.obscureConfirmedPassword,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
