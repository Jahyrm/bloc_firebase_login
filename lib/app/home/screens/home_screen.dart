import 'package:bloc_firebase_login/app/main/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/avatar.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AuthBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              context.read<AuthBloc>().add(const AppLogoutRequested());
            },
          )
        ],
      ),
      body: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Avatar(photo: user.photo),
            if (user.email?.isNotEmpty ?? false) ...[
              const SizedBox(height: 16),
              Text(user.email!, style: textTheme.titleLarge),
            ],
            if (user.name?.isNotEmpty ?? false) ...[
              const SizedBox(height: 16),
              Text(user.name!, style: textTheme.headlineSmall),
            ],
          ],
        ),
      ),
    );
  }
}
