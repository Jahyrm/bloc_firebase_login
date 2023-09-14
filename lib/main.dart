import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app/main/screens/main_screen.dart';
import 'core/configs/firebase_options.dart';
import 'core/repositories/authentication_repository.dart';

Future<void> main() async {
  /// Esta línea nos asegura que todas las cargas async/await se realicen antes
  /// de inicializar.
  WidgetsFlutterBinding.ensureInitialized();

  /// We initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// We create an instance of our repository
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  /// We pass the repository to our parent widget.
  runApp(MainApp(authenticationRepository: authenticationRepository));
}
