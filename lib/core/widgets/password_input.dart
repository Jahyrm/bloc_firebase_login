import 'package:flutter/material.dart';

import '../utils/validator_utils.dart';

class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    this.onChanged,
    this.togglePassword,
    this.obscureText = false,
    this.mainPassword,
  });

  final void Function(String)? onChanged;
  final void Function()? togglePassword;
  final bool obscureText;
  final String? mainPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: 'Contraseña',
        suffixIcon: togglePassword != null
            ? (obscureText
                ? InkWell(
                    onTap: togglePassword,
                    child: const Icon(
                      Icons.visibility,
                    ))
                : InkWell(
                    onTap: togglePassword,
                    child: const Icon(
                      Icons.visibility_off,
                    )))
            : null,
      ),
      validator: (password) => ValidatorUtils.validatePassword(
        password,
        mainPassword: mainPassword,
      ),
    );
  }
}
