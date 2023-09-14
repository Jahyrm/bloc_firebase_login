// ignore_for_file: prefer_const_constructors

import 'package:bloc_firebase_login/app/home/bloc/post_bloc.dart';
import 'package:bloc_firebase_login/app/home/models/post.dart';
import 'package:bloc_firebase_login/app/home/screens/posts_list.dart';
import 'package:bloc_firebase_login/app/home/widgets/bottom_loader.dart';
import 'package:bloc_firebase_login/app/home/widgets/post_list_item.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPostBloc extends MockBloc<PostEvent, PostState> implements PostBloc {}

extension on WidgetTester {
  Future<void> pumpPostsList(PostBloc postBloc) {
    return pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: postBloc,
          child: PostsList(),
        ),
      ),
    );
  }
}

void main() {
  final mockPosts = List.generate(
    5,
    (i) => Post(id: i, title: 'titulo', body: 'cuerpo', userId: 1),
  );

  late PostBloc postBloc;

  setUp(() {
    postBloc = MockPostBloc();
  });

  group('PostsList', () {
    testWidgets(
        'renderiza CircularProgressIndicator '
        'cuando el estado es inicial', (tester) async {
      when(() => postBloc.state).thenReturn(const PostState());
      await tester.pumpPostsList(postBloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'renderiza el texto "No hay post"'
        'cuando el estado es succes pero con 0 post', (tester) async {
      when(() => postBloc.state).thenReturn(
        const PostState(status: PostStatus.success, hasReachedMax: true),
      );
      await tester.pumpPostsList(postBloc);
      expect(find.text('No hay post.'), findsOneWidget);
    });

    testWidgets(
        'renderiza 5 posts y un bottom loader cuando no se alcanza el máximo',
        (tester) async {
      when(() => postBloc.state).thenReturn(
        PostState(
          status: PostStatus.success,
          posts: mockPosts,
        ),
      );
      await tester.pumpPostsList(postBloc);
      expect(find.byType(PostListItem), findsNWidgets(5));
      expect(find.byType(BottomLoader), findsOneWidget);
    });

    testWidgets('no renderiza elbottom loader cuando se alcanza el máximo',
        (tester) async {
      when(() => postBloc.state).thenReturn(
        PostState(
          status: PostStatus.success,
          posts: mockPosts,
          hasReachedMax: true,
        ),
      );
      await tester.pumpPostsList(postBloc);
      expect(find.byType(BottomLoader), findsNothing);
    });

    testWidgets('obtiene más post cuando se scrollea al fondo de la pantalla',
        (tester) async {
      when(() => postBloc.state).thenReturn(
        PostState(
          status: PostStatus.success,
          posts: List.generate(
            10,
            (i) => Post(id: i, title: 'titulo', body: 'cuerpo', userId: 10),
          ),
        ),
      );
      await tester.pumpPostsList(postBloc);
      await tester.drag(find.byType(PostsList), const Offset(0, -500));
      verify(() => postBloc.add(PostFetched())).called(1);
    });
  });
}
