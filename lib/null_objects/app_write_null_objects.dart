import 'package:appwrite/models.dart';

class AppWriteNullObjects {
  static final User user = User(
    $id: '',
    $createdAt: '',
    $updatedAt: '',
    name: '',
    registration: '',
    status: false,
    passwordUpdate: '',
    email: '',
    phone: '',
    emailVerification: false,
    phoneVerification: false,
    prefs: Preferences.fromMap({}),
  );

  static final Session session = Session(
    $id: '',
    $createdAt: '',
    userId: '',
    expire: '',
    provider: '',
    providerUid: '',
    providerAccessToken: '',
    providerAccessTokenExpiry: '',
    providerRefreshToken: '',
    ip: '',
    osCode: '',
    osName: '',
    osVersion: '',
    clientType: '',
    clientCode: '',
    clientName: '',
    clientVersion: '',
    clientEngine: '',
    clientEngineVersion: '',
    deviceName: '',
    deviceBrand: '',
    deviceModel: '',
    countryCode: '',
    countryName: '',
    current: false,
  );

  static final document = Document(
    $id: '',
    $collectionId: '',
    $databaseId: '',
    $createdAt: '',
    $updatedAt: '',
    $permissions: [],
    data: {},
  );
}
