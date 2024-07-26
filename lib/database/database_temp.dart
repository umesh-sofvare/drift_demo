import 'package:drift/drift.dart';
import 'package:drift_demo/tables.dart';

part 'database_temp.g.dart';

@DriftDatabase(tables: [Employees],)
class AppDbTemp extends _$AppDbTemp {
  AppDbTemp(super.executor);

  @override
  int get schemaVersion => 1;
}