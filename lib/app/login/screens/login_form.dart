import 'package:bloc_firebase_login/app/sign_up/screens/sign_up_screen.dart';
import 'package:bloc_firebase_login/core/resources/images.dart';
import 'package:bloc_firebase_login/core/widgets/email_input.dart';
import 'package:bloc_firebase_login/core/widgets/main_button.dart';
import 'package:bloc_firebase_login/core/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      // listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? 'Fallo de autenticación',
                  textAlign: TextAlign.center,
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: BlocBuilder<LoginCubit, LoginState>(builder: (context, state) {
            return Form(
              key: context.read<LoginCubit>().loginFormKey,
              autovalidateMode: state.status == FormStatus.validationFail
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    imgBlocLogo.path,
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  EmailInput(
                    onChanged: (email) =>
                        context.read<LoginCubit>().emailChanged(email),
                  ),
                  const SizedBox(height: 8),
                  PasswordInput(
                    onChanged: (passwd) =>
                        context.read<LoginCubit>().passwordChanged(passwd),
                    obscureText: state.obscurePassword,
                    togglePassword:
                        context.read<LoginCubit>().togglePasswordVisibility,
                    onEditingComplete:
                        context.read<LoginCubit>().logInWithCredentials,
                    isLast: true,
                  ),
                  const SizedBox(height: 8),
                  _loginButton(context),
                  const SizedBox(height: 8),
                  _signUpButton(context),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  BlocBuilder _loginButton(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status == FormStatus.loading
            ? const CircularProgressIndicator()
            : MainButton(
                onPressed: context.read<LoginCubit>().logInWithCredentials,
                text: 'INICIAR SESIÓN',
              );
      },
    );
  }

  TextButton _signUpButton(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () => Navigator.of(context).pushNamed(SignUpScreen.routeName),
      child: Text(
        'CREAR CUENTA',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
