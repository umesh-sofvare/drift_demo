import 'package:drift/drift.dart';
import 'package:drift_demo/tables.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Employees],)
class AppDb extends _$AppDb {
  AppDb(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        await m.createAll();
        print("onCreate called");
      },
      onUpgrade: (m, from, to) async {
        print("onUpgrade called");
      },
      beforeOpen: (details) async {
        print("beforeOpen called");
      },
    );
  }

}