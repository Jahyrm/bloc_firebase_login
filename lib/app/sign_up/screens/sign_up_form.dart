import 'package:bloc_firebase_login/app/login/cubit/login_cubit.dart';
import 'package:bloc_firebase_login/core/widgets/email_input.dart';
import 'package:bloc_firebase_login/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/password_input.dart';
import '../cubit/sign_up_cubit.dart';

/// Part 1
class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          Navigator.of(context).pop();
        } else if (state.status == FormStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Error de registro',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: BlocBuilder<SignUpCubit, SignUpState>(builder: (context, state) {
          return Form(
            key: context.read<SignUpCubit>().signUpFormKey,
            autovalidateMode: state.status == FormStatus.validationFail
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EmailInput(
                  onChanged: (email) =>
                      context.read<SignUpCubit>().emailChanged(email),
                ),
                const SizedBox(height: 8),
                PasswordInput(
                  onChanged: (passwd) =>
                      context.read<SignUpCubit>().passwordChanged(passwd),
                  obscureText: state.obscurePassword,
                  togglePassword:
                      context.read<SignUpCubit>().togglePasswordVisibility,
                ),
                const SizedBox(height: 8),
                PasswordInput(
                  onChanged: (passwd) => context
                      .read<SignUpCubit>()
                      .confirmedPasswordChanged(passwd),
                  onEditingComplete:
                      context.read<SignUpCubit>().signUpFormSubmitted,
                  obscureText: state.obscureConfirmedPassword,
                  mainPassword: state.password,
                  togglePassword: context
                      .read<SignUpCubit>()
                      .toggleConfirmedPasswordVisibility,
                  isLast: true,
                ),
                const SizedBox(height: 8),
                _SignUpButton(),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpCubit, SignUpState>(
      builder: (context, state) {
        return state.status == FormStatus.loading
            ? const CircularProgressIndicator()
            : MainButton(
                color: const Color(0xFF0097A7),
                onPressed: context.read<SignUpCubit>().signUpFormSubmitted,
                text: 'REGISTRARSE',
              );
      },
    );
  }
}
