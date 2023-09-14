import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/main/screens/main_screen.dart';
import 'core/configs/firebase_options.dart';
import 'core/repositories/authentication_repository.dart';
import 'core/widgets/bloc_observer.dart';

Future<void> main() async {
  /// This line ensures that all async/await loads are done before initializing.
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = const AppBlocObserver();

  /// We initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// We create an instance of our repository
  final authenticationRepository = AuthenticationRepository();
  await authenticationRepository.user.first;

  /// We pass the repository to our parent widget.
  runApp(MainApp(authenticationRepository: authenticationRepository));
}
