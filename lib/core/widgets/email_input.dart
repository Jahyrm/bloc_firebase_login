import 'package:flutter/material.dart';

import '../utils/validator_utils.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key, this.onChanged});

  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(labelText: 'Correo electrónico'),
      validator: (email) => ValidatorUtils.validateEmail(email),
    );
  }
}
