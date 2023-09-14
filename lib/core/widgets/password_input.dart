import 'package:flutter/material.dart';

import '../utils/validator_utils.dart';

/// Part 4
class PasswordInput extends StatelessWidget {
  const PasswordInput({
    super.key,
    this.onChanged,
    this.onEditingComplete,
    this.togglePassword,
    this.obscureText = false,
    this.isLast = false,
    this.mainPassword,
  });

  final void Function(String)? onChanged;
  final void Function()? onEditingComplete;
  final void Function()? togglePassword;
  final bool obscureText;
  final bool isLast;
  final String? mainPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      obscureText: obscureText,
      textInputAction: isLast ? TextInputAction.done : TextInputAction.next,
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
