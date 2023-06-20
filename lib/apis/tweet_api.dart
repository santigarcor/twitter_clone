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
    db: ref.watch(appWriteDatabasesProvider),
    realtime: ref.watch(appWriteRealtimeProvider),
  );
});

abstract interface class TweetApiInterface {
  FutureApiResponse<Document> createTweet(TweetModel tweet);
  Future<List<Document>> getTweets();
  Stream<RealtimeMessage> getLatestTweet();
  FutureApiResponse<Document> likeTweet(TweetModel tweet);
}

class TweetApi implements TweetApiInterface {
  final Realtime _realtime;
  final Databases _db;

  TweetApi({
    required Databases db,
    required Realtime realtime,
  })  : _db = db,
        _realtime = realtime;

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
          Permission.update(Role.any()),
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

  @override
  Future<List<Document>> getTweets() async {
    final response = await _db.listDocuments(
      databaseId: AppWriteConstants.databaseId,
      collectionId: AppWriteConstants.tweetsCollectionId,
      queries: [Query.orderDesc("createdAt")],
    );
    return response.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestTweet() {
    return _realtime.subscribe([
      'databases.${AppWriteConstants.databaseId}.collections.${AppWriteConstants.tweetsCollectionId}.documents'
    ]).stream;
  }

  @override
  FutureApiResponse<Document> likeTweet(TweetModel tweet) async {
    var exception = AppwriteException();
    var document = AppWriteNullObjects.document;
    try {
      document = await _db.updateDocument(
        databaseId: AppWriteConstants.databaseId,
        collectionId: AppWriteConstants.tweetsCollectionId,
        documentId: tweet.id,
        data: {'likes': tweet.likes},
        permissions: [
          Permission.delete(
            Role.user(tweet.uid),
          ),
        ],
      );
    } on AppwriteException catch (e) {
      exception = e;
    }

    return (exception: exception, data: document);
  }
}
