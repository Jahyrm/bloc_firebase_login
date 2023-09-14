import 'package:equatable/equatable.dart';

/// We extend Equatable so that we can compare Posts. Without this, we would
/// need to manually change our class to override equality and hashCode so that
/// we could tell the difference between two Posts objects.
final class Post extends Equatable {
  const Post(
      {required this.userId,
      required this.id,
      required this.title,
      required this.body});

  final int userId;
  final int id;
  final String title;
  final String body;

  Post.fromJson(Map<String, dynamic> json)
      : userId = json['userId'] ?? 0,
        id = json['id'] ?? 0,
        title = json['title'] ?? '',
        body = json['body'] ?? '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    return data;
  }

  @override
  List<Object> get props => [id, title, body];
}
