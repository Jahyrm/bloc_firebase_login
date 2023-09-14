import 'package:equatable/equatable.dart';

/// User model
/// The User class is extending equatable in order to override equality
/// comparisons so that we can compare different instances of User by value.
class User extends Equatable {
  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
  });

  /// The current user's id.
  final String id;

  /// The current user's email address.
  final String? email;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  /// [User.empty] which represents an unauthenticated user.
  /// It's useful to define a static empty User so that we don't have to handle
  /// null Users and can always work with a concrete User object.
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;

  @override
  List<Object?> get props => [email, id, name, photo];
}
