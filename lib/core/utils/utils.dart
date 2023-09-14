import 'package:flutter/material.dart';

class Utils {
  static void ocultarTeclado() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
