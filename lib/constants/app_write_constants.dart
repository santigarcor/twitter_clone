import 'dart:io' show Platform;

class AppWriteConstants {
  static const String projectId = '646d28fe3df5e2d02205';
  static const String databaseId = '646d2afd483535308f92';
  static final Uri endPointUri = Uri(
    scheme: 'http',
    host: Platform.isAndroid ? '192.168.1.12' : 'localhost',
    port: 80,
    path: 'v1',
  );

  static const String usersCollectionId = '6474df21d23f6b14cc28';
  static const String tweetsCollectionId = '64766852b4ba3b9ab782';

  static const String imagesBucket = '64767863aa986e2b717c';

  static String imageUrl(String imageId) {
    return '${endPointUri.toString()}/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId';
  }
}
