import 'package:bloc/bloc.dart';
import 'package:bloc_firebase_login/app/login/cubit/login_cubit.dart';
import 'package:bloc_firebase_login/core/utils/utils.dart';
import 'package:bloc_firebase_login/core/utils/validator_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../../core/repositories/authentication_repository.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit(this._authenticationRepository) : super(const SignUpState());

  final AuthenticationRepository _authenticationRepository;

  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  void emailChanged(String value) {
    final email = value;
    emit(state.copyWith(email: email));
  }

  void passwordChanged(String value) {
    final password = value;
    emit(state.copyWith(password: password));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = value;
    emit(state.copyWith(confirmedPassword: confirmedPassword));
  }

  void togglePasswordVisibility() {
    emit(state.copyWith(obscurePassword: !state.obscurePassword));
  }

  void toggleConfirmedPasswordVisibility() {
    emit(state.copyWith(
        obscureConfirmedPassword: !state.obscureConfirmedPassword));
  }

  Future<void> signUpFormSubmitted() async {
    if (signUpFormKey.currentState?.validate() ?? false) {
      Utils.ocultarTeclado();
      emit(state.copyWith(status: FormStatus.loading));
      try {
        await _authenticationRepository.signUp(
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith(status: FormStatus.success));
      } on SignUpWithEmailAndPasswordFailure catch (e) {
        emit(
          state.copyWith(
            errorMessage: e.message,
            status: FormStatus.failure,
          ),
        );
      } catch (_) {
        emit(state.copyWith(status: FormStatus.failure));
      }
    } else {
      emit(state.copyWith(status: FormStatus.validationFail));
    }
  }
}
