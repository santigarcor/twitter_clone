import 'package:appwrite/appwrite.dart';

typedef FutureApiResponse<T> = Future<({AppwriteException exception, T data})>;
