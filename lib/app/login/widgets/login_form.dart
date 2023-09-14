import 'package:bloc_firebase_login/core/resources/images.dart';
import 'package:bloc_firebase_login/core/utils/validator_utils.dart';
import 'package:bloc_firebase_login/core/widgets/main_button.dart';
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
                content: Text(state.errorMessage ?? 'Fallo de autentificacion'),
              ),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Form(
            key: context.read<LoginCubit>().loginFormKey,
            autovalidateMode: context.watch<LoginCubit>().state.status ==
                    FormStatus.validationFail
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
                _emailInput(context),
                const SizedBox(height: 8),
                _passwordInput(context),
                const SizedBox(height: 8),
                _loginButton(context),
                const SizedBox(height: 8),
                _signUpButton(context),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _emailInput(BuildContext context) {
    return TextFormField(
      onChanged: (email) => context.read<LoginCubit>().emailChanged(email),
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(labelText: 'Correo electrónico'),
      validator: (email) => ValidatorUtils.validateEmail(email),
    );
  }

  TextFormField _passwordInput(BuildContext context) {
    return TextFormField(
      onChanged: (passwd) => context.read<LoginCubit>().passwordChanged(passwd),
      obscureText: true,
      decoration: const InputDecoration(labelText: 'Contraseña'),
      validator: (password) => ValidatorUtils.validatePassword(password),
    );
  }

  BlocBuilder _loginButton(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status == FormStatus.loading
            ? const CircularProgressIndicator()
            : MainButton(
                onPressed: () {
                  context.read<LoginCubit>().logInWithCredentials();
                },
                text: 'Iniciar Sesión',
              );
      },
    );
  }

  TextButton _signUpButton(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      onPressed: () {},
      child: Text(
        'CREATE ACCOUNT',
        style: TextStyle(color: theme.primaryColor),
      ),
    );
  }
}
