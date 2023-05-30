import 'dart:ffi';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/app_write_constants.dart';
import 'package:twitter_clone/models/user.dart';
import 'package:twitter_clone/providers/appwrite_providers.dart';
import 'package:twitter_clone/types.dart';

abstract interface class UserApiInterface {
  FutureApiResponse<void> saveUserData(UserModel userModel);
  Future<Document> getUserData(String uid);
}

final userApiProvider = Provider<UserApi>((ref) {
  return UserApi(db: ref.watch(appWriteDatabasesProvider));
});

class UserApi implements UserApiInterface {
  final Databases _db;

  UserApi({required Databases db}) : _db = db;

  @override
  FutureApiResponse<void> saveUserData(UserModel userModel) async {
    var exception = AppwriteException();

    try {
      await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.usersCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
      );
    } on AppwriteException catch (e) {
      exception = e;
    }

    return (exception: exception, data: Void);
  }

  @override
  Future<Document> getUserData(String uid) {
    return _db.getDocument(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.usersCollectionId,
      documentId: uid,
    );
  }
}
