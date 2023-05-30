import 'package:appwrite/models.dart';

extension CheckGuestSession on Session {
  bool get isEmpty => $id == '';
}

extension EmptyUser on User {
  bool get isEmpty => $id == '';
}

extension EmptyDocument on Document {
  bool get isEmpty => $id == '';
}
