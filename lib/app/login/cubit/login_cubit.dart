import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../../core/repositories/authentication_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    emit(state.copyWith(email: value, errorMessage: null));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, errorMessage: null));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  Future<void> logInWithCredentials() async {
    if (loginFormKey.currentState?.validate() ?? false) {
      emit(state.copyWith(status: FormStatus.loading, errorMessage: null));
      try {
        await _authenticationRepository.logInWithEmailAndPassword(
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(status: FormStatus.success, errorMessage: null));
      } on LogInWithEmailAndPasswordFailure catch (e) {
        emit(
          state.copyWith(
            errorMessage: e.message,
            status: FormStatus.failure,
          ),
        );
        emit(state.copyWith(status: FormStatus.initial, errorMessage: null));
      } catch (_) {
        emit(state.copyWith(status: FormStatus.failure, errorMessage: null));
      }
    } else {
      emit(state.copyWith(
        status: FormStatus.validationFail,
        errorMessage: null,
      ));
    }
  }
}
