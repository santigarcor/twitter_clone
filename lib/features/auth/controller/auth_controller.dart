import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/apis/user_api.dart';
import 'package:twitter_clone/extensions/appwrite_extensions.dart';
import 'package:twitter_clone/features/home/view/home.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/utils/snackbar.dart';
import 'package:twitter_clone/utils/string.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authApi: ref.watch(authApiProvider),
    userApi: ref.watch(userApiProvider),
    ref: ref,
  );
});

final currentUserProvider = FutureProvider((ref) {
  return ref.watch(authControllerProvider.notifier).currentUser();
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  return ref.watch(authControllerProvider.notifier).getUserData(uid);
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserProvider).value;
  return ref.watch(userDetailsProvider(currentUserId!.$id)).value;
});

class AuthController extends StateNotifier<bool> {
  final AuthApi _authApi;
  final UserApi _userApi;
  final Ref ref;

  AuthController({
    required AuthApi authApi,
    required UserApi userApi,
    required this.ref,
  })  : _authApi = authApi,
        _userApi = userApi,
        super(false);

  Future<User?> currentUser() => _authApi.currentUser();

  Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final (data: user, :exception) = await _authApi.signUp(
      email: email,
      password: password,
    );
    var userModel = UserModel(
      email: email,
      name: getNameFromEmail(email),
      followers: const [],
      following: const [],
      profilePic: '',
      bannerPic: '',
      uid: user.$id,
      bio: '',
      isTwitterBlue: false,
    );
    final response = await _userApi.saveUserData(userModel);
    ref.invalidate(currentUserProvider);
    state = false;

    if (!mounted) return;

    if (response.exception.code != null) {
      return showSnackBar(
          context, response.exception.message ?? 'There was an issue');
    }
    if (exception.code != null || user.isEmpty) {
      return showSnackBar(context, exception.message ?? 'There was an issue');
    }

    showSnackBar(context, "Account created! Please login.");
    Navigator.pop(context);
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = true;
    final (data: session, :exception) = await _authApi.login(
      email: email,
      password: password,
    );
    ref.invalidate(currentUserProvider);
    state = false;

    if (!mounted) {
      return;
    }

    if (exception.code != null || session.isEmpty) {
      return showSnackBar(context, exception.message ?? 'There was an issue');
    }

    Navigator.pushReplacement(context, Home.route());
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userApi.getUserData(uid);
    final user = UserModel.fromMap(document.data);

    return user;
  }
}
