import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as models;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/null_objects/app_write_null_objects.dart';
import 'package:twitter_clone/types.dart';

import '../providers/appwrite_providers.dart';

final authApiProvider = Provider(
  (ref) => AuthApi(account: ref.watch(appWriteAccountProvider)),
);

abstract interface class AuthApiInterface {
  FutureApiResponse<models.User> signUp({
    required String email,
    required String password,
  });

  FutureApiResponse<models.Session> login({
    required String email,
    required String password,
  });

  Future<models.User?> currentUser();
}

class AuthApi implements AuthApiInterface {
  final Account _account;

  AuthApi({required Account account}) : _account = account;

  @override
  FutureApiResponse<models.User> signUp({
    required String email,
    required String password,
  }) async {
    var user = AppWriteNullObjects.user;
    var exception = AppwriteException();

    try {
      user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      exception = e;
    } catch (e) {
      exception = AppwriteException(e.toString(), 400, 'dart');
    }

    return (exception: exception, data: user);
  }

  @override
  FutureApiResponse<models.Session> login({
    required String email,
    required String password,
  }) async {
    var session = AppWriteNullObjects.session;
    var exception = AppwriteException();

    try {
      session = await _account.createEmailSession(
        email: email,
        password: password,
      );
    } on AppwriteException catch (e) {
      exception = e;
    } catch (e) {
      exception = AppwriteException(e.toString(), 400, 'dart');
    }

    return (exception: exception, data: session);
  }

  @override
  Future<models.User?> currentUser() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }
}
