class ValidatorUtils {
  static String? validateEmail(String? email, {bool allowEmpty = false}) {
    if (email?.isNotEmpty ?? false) {
      RegExp emailRegExp = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
      );
      if (!emailRegExp.hasMatch(email!)) return 'El email no es válido';
    } else {
      return allowEmpty ? null : 'Ingrese su email.';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password?.isNotEmpty ?? false) {
      RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
      if (!passwordRegExp.hasMatch(password!)) {
        return 'La contraseña no es válida.';
      }
    } else {
      return 'Ingrese su contraseña.';
    }
    return null;
  }
}
