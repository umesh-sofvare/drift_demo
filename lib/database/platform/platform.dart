import 'package:drift/drift.dart';

import 'platform_stub.dart'
    if (dart.library.io) 'platform_app.dart'
    if (dart.library.html) 'platform_web.dart';

class DBCreator {
  static QueryExecutor createDatabaseConnection(String databaseName) =>
      PlatformInterface.createDatabaseConnection(databaseName);

  static copyDataFromAnotherDatabase() =>
      PlatformInterface.copyDataFromAnotherDatabase();
}
