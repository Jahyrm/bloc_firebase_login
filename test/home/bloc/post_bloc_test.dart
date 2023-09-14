import 'package:bloc_firebase_login/app/home/bloc/post_bloc.dart';
import 'package:bloc_firebase_login/app/home/models/post.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements http.Client {}

Uri _postsUrl({required int start}) {
  return Uri.https(
    'jsonplaceholder.typicode.com',
    '/posts',
    <String, String>{'_start': '$start', '_limit': '20'},
  );
}

void main() {
  group('PostBloc', () {
    const mockPosts = [
      Post(id: 1, title: 'post title', body: 'post body', userId: 1)
    ];
    const extraMockPosts = [
      Post(id: 2, title: 'post title', body: 'post body', userId: 1)
    ];

    late http.Client httpClient;

    setUpAll(() {
      registerFallbackValue(Uri());
    });

    setUp(() {
      httpClient = MockClient();
    });

    test('El estado incial es PostState()', () {
      expect(PostBloc(httpClient: httpClient).state, const PostState());
    });

    group('PostFetched', () {
      blocTest<PostBloc, PostState>(
        'no emite nada cuando se ha alcanzado la cantidad máxima de post',
        build: () => PostBloc(httpClient: httpClient),
        seed: () => const PostState(hasReachedMax: true),
        act: (bloc) => bloc.add(PostFetched()),
        expect: () => <PostState>[],
      );

      blocTest<PostBloc, PostState>(
        'emite successful status cuando obtiene los post iniciales',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 1, "title": "post title", "body": "post body" }]',
              200,
            );
          });
        },
        build: () => PostBloc(httpClient: httpClient),
        act: (bloc) => bloc.add(PostFetched()),
        expect: () => const <PostState>[
          PostState(status: PostStatus.success, posts: mockPosts)
        ],
        verify: (_) {
          verify(() => httpClient.get(_postsUrl(start: 0))).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'lanza nuevos events cuando procesa el evento actual',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 1, "title": "post title", "body": "post body" }]',
              200,
            );
          });
        },
        build: () => PostBloc(httpClient: httpClient),
        act: (bloc) => bloc
          ..add(PostFetched())
          ..add(PostFetched()),
        expect: () => const <PostState>[
          PostState(status: PostStatus.success, posts: mockPosts)
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'throttles events',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 1, "title": "post title", "body": "post body" }]',
              200,
            );
          });
        },
        build: () => PostBloc(httpClient: httpClient),
        act: (bloc) async {
          bloc.add(PostFetched());
          await Future<void>.delayed(Duration.zero);
          bloc.add(PostFetched());
        },
        expect: () => const <PostState>[
          PostState(status: PostStatus.success, posts: mockPosts)
        ],
        verify: (_) {
          verify(() => httpClient.get(any())).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'emits failure status cuando se hace una petición y hay un error',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer(
            (_) async => http.Response('', 500),
          );
        },
        build: () => PostBloc(httpClient: httpClient),
        act: (bloc) => bloc.add(PostFetched()),
        expect: () => <PostState>[const PostState(status: PostStatus.failure)],
        verify: (_) {
          verify(() => httpClient.get(_postsUrl(start: 0))).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'emits successful status y alcanza los post máximos cuando'
        'ya no se extraen mas post o son 0',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer(
            (_) async => http.Response('[]', 200),
          );
        },
        build: () => PostBloc(httpClient: httpClient),
        seed: () => const PostState(
          status: PostStatus.success,
          posts: mockPosts,
        ),
        act: (bloc) => bloc.add(PostFetched()),
        expect: () => const <PostState>[
          PostState(
            status: PostStatus.success,
            posts: mockPosts,
            hasReachedMax: true,
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(_postsUrl(start: 1))).called(1);
        },
      );

      blocTest<PostBloc, PostState>(
        'emits successful status y no alcanza el máximo de post'
        'cuando nuevos post son obtenidos',
        setUp: () {
          when(() => httpClient.get(any())).thenAnswer((_) async {
            return http.Response(
              '[{ "id": 2, "title": "post title", "body": "post body" }]',
              200,
            );
          });
        },
        build: () => PostBloc(httpClient: httpClient),
        seed: () => const PostState(
          status: PostStatus.success,
          posts: mockPosts,
        ),
        act: (bloc) => bloc.add(PostFetched()),
        expect: () => const <PostState>[
          PostState(
            status: PostStatus.success,
            posts: [...mockPosts, ...extraMockPosts],
          )
        ],
        verify: (_) {
          verify(() => httpClient.get(_postsUrl(start: 1))).called(1);
        },
      );
    });
  });
}
