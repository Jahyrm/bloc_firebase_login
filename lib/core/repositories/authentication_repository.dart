import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:meta/meta.dart';

import '../../app/main/models/user.dart';
import '../utils/cache_util.dart';

/// Part 3

/// Thrown during the sign up process if a failure occurs.
class SignUpWithEmailAndPasswordFailure implements Exception {
  const SignUpWithEmailAndPasswordFailure([
    this.message = 'Se produjo una excepción desconocida.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  /// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/createUserWithEmailAndPassword.html
  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
          'El correo electrónico no es válido o está mal formateado.',
        );
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
          'Este usuario ha sido deshabilitado. Comuníquese con el soporte para '
          'obtener ayuda.',
        );
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
          'Ya existe una cuenta para ese correo electrónico.',
        );
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
          'No se permite la operación. Por favor contacte al soporte.',
        );
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
          'Por favor ingrese una contraseña más segura.',
        );
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the login process if a failure occurs.
/// https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
class LogInWithEmailAndPasswordFailure implements Exception {
  const LogInWithEmailAndPasswordFailure([
    this.message = 'Se produjo una excepción desconocida.',
  ]);

  /// Create an authentication message
  /// from a firebase authentication exception code.
  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    switch (code) {
      case 'invalid-email':
        return const LogInWithEmailAndPasswordFailure(
          'El correo electrónico no es válido o está mal formateado.',
        );
      case 'user-disabled':
        return const LogInWithEmailAndPasswordFailure(
          'Este usuario ha sido deshabilitado. Comuníquese con el soporte para '
          'obtener ayuda.',
        );
      case 'user-not-found':
        return const LogInWithEmailAndPasswordFailure(
          'No se encuentra el correo electrónico, cree una cuenta.',
        );
      case 'wrong-password':
        return const LogInWithEmailAndPasswordFailure(
          'Contraseña incorrecta. Por favor, intente de nuevo.',
        );
      case 'INVALID_LOGIN_CREDENTIALS':
        return const LogInWithEmailAndPasswordFailure(
          'Credenciales incorrectas. Por favor, intente de nuevo.',
        );
      default:
        return const LogInWithEmailAndPasswordFailure();
    }
  }

  /// The associated error message.
  final String message;
}

/// Thrown during the logout process if a failure occurs.
class LogOutFailure implements Exception {}

/// Repository which manages user authentication.
class AuthenticationRepository {
  AuthenticationRepository({
    CacheUtil? cache,
    firebase_auth.FirebaseAuth? firebaseAuth,
  })  : _cache = cache ?? CacheUtil(),
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  final CacheUtil _cache;
  final firebase_auth.FirebaseAuth _firebaseAuth;

  /// Whether or not the current environment is web
  /// Overridden for testing purposes. Otherwise, defaults to [kIsWeb]
  @visibleForTesting
  bool isWeb = kIsWeb;

  /// User cache key.
  /// Used for testing purposes.
  @visibleForTesting
  static const userCacheKey = '__user_cache_key__';

  /// Stream of [User] which will emit the current user when
  /// the authentication state changes.
  ///
  /// Emits [User.empty] if the user is not authenticated.
  Stream<User> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      final user = firebaseUser == null ? User.empty : firebaseUser.toUser;
      _cache.write(key: userCacheKey, value: user);
      return user;
    });
  }

  /// Returns the current cached user.
  /// Defaults to [User.empty] if there is no cached user.
  User get currentUser {
    return _cache.read<User>(key: userCacheKey) ?? User.empty;
  }

  /// Creates a new user with the provided [email] and [password].
  ///
  /// Throws a [SignUpWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw SignUpWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const SignUpWithEmailAndPasswordFailure();
    }
  }

  /// Signs in with the provided [email] and [password].
  ///
  /// Throws a [LogInWithEmailAndPasswordFailure] if an exception occurs.
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (_) {
      throw const LogInWithEmailAndPasswordFailure();
    }
  }

  /// Signs out the current user which will emit
  /// [User.empty] from the [user] Stream.
  ///
  /// Throws a [LogOutFailure] if an exception occurs.
  Future<void> logOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut()]);
    } catch (_) {
      throw LogOutFailure();
    }
  }
}

/// We add or extend a functionality (a method) to the class
/// [firebase_auth.User] to transform the [firebase_auth.User] object into a
/// [User] object.
extension on firebase_auth.User {
  /// Maps a [firebase_auth.User] into a [User].
  User get toUser {
    return User(id: uid, email: email, name: displayName, photo: photoURL);
  }
}
