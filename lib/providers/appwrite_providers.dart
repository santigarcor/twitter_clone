import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_write_constants.dart';

final appWriteClientProvider = Provider(
  (ref) => Client()
      .setEndpoint(AppWriteConstants.endPointUri.toString())
      .setProject(AppWriteConstants.projectId)
      .setSelfSigned(status: true),
);

final appWriteAccountProvider = Provider((ref) {
  final appWriteClient = ref.watch(appWriteClientProvider);
  return Account(appWriteClient);
});

final appWriteDatabasesProvider = Provider<Databases>((ref) {
  return Databases(ref.watch(appWriteClientProvider));
});

final appWriteRealtimeProvider = Provider<Realtime>((ref) {
  return Realtime(ref.watch(appWriteClientProvider));
});

final appWriteStorageProvider = Provider<Storage>((ref) {
  return Storage(ref.watch(appWriteClientProvider));
});
