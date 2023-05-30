import 'dart:ffi';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/app_write_constants.dart';
import 'package:twitter_clone/models/tweet_model.dart';
import 'package:twitter_clone/null_objects/app_write_null_objects.dart';
import 'package:twitter_clone/providers/appwrite_providers.dart';
import 'package:twitter_clone/types.dart';

final tweetApiProvider = Provider<TweetApi>((ref) {
  return TweetApi(
    db: ref.watch(
      appWriteDatabasesProvider,
    ),
  );
});

abstract interface class TweetApiInterface {
  FutureApiResponse<Document> createTweet(TweetModel userModel);
}

class TweetApi implements TweetApiInterface {
  final Databases _db;

  TweetApi({required Databases db}) : _db = db;

  @override
  FutureApiResponse<Document> createTweet(TweetModel tweetModel) async {
    var exception = AppwriteException();
    var document = AppWriteNullObjects.document;
    try {
      document = await _db.createDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: ID.unique(),
        data: tweetModel.toMap(),
        permissions: [
          Permission.delete(
            Role.user(tweetModel.uid),
          ),
        ],
      );
    } on AppwriteException catch (e) {
      exception = e;
    }

    return (exception: exception, data: document);
  }
}
