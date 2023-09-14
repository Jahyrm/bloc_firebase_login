import 'package:bloc_firebase_login/app/home/bloc/post_bloc.dart';
import 'package:bloc_firebase_login/app/main/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../widgets/avatar.dart';
import 'posts_list.dart';

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
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
              const SizedBox(height: 16),
              Expanded(
                child: BlocProvider(
                  create: (_) => PostBloc(httpClient: http.Client())
                    ..add(
                      PostFetched(),
                    ),
                  child: const PostsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
