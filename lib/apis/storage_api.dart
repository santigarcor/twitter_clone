import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/constants/constants.dart';
import 'package:twitter_clone/providers/appwrite_providers.dart';

final storageApiProvider = Provider<StorageApi>((ref) {
  return StorageApi(storage: ref.watch(appWriteStorageProvider));
});

class StorageApi {
  final Storage _storage;

  StorageApi({required storage}) : _storage = storage;

  Future<List<String>> uploadFiles(List<File> files) async {
    final List<String> fileLinks = [];

    for (var file in files) {
      final uploadedFile = await _storage.createFile(
        bucketId: AppWriteConstants.imagesBucket,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
        permissions: [
          Permission.read(Role.any()),
        ],
      );
      fileLinks.add(AppWriteConstants.imageUrl(uploadedFile.$id));
    }

    return fileLinks;
  }
}
