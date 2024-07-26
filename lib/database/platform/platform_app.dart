import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_demo/main.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';

import '../database_temp.dart' as temp;


class PlatformInterface {
  static QueryExecutor createDatabaseConnection(String databaseName) {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final dbFile = File(join(dbFolder.path, '$databaseName.db'));

      // final byteData = await rootBundle.load('assets/dbname1.sqlite');
      // final dbPath = await getApplicationDocumentsDirectory();
      // final dbFile = File(join(dbPath.path, 'dbname1.sqlite'));
      // if(!await dbFile.exists()) {
      //   print("dbFile-- $dbFile");
      //   print("import database call");
      //   await dbFile.writeAsBytes(byteData.buffer.asUint8List());
      // }else {
      //   print("database already exits");
      // }

      NativeDatabase db = NativeDatabase(dbFile);
      return db;
    });
  }


  static temp.AppDbTemp? appDbTemp;


  static copyDataFromAnotherDatabase()async{

    appDbTemp ??= temp.AppDbTemp(LazyDatabase(() async {
      final byteData = await rootBundle.load('assets/dbname1.sqlite');
      final dbPath = await getApplicationDocumentsDirectory();
      final dbFile = File(join(dbPath.path, 'dbname1.sqlite'));
      await dbFile.writeAsBytes(byteData.buffer.asUint8List());
      return NativeDatabase(dbFile);
    }));


    for (final tableInfo in appDbTemp!.allTables) {
      final existingTable = dbHelper.database.allTables.firstWhereOrNull((table) => table.actualTableName == tableInfo.actualTableName);

      if(existingTable!=null){
        final assetTableData = await appDbTemp!.select(existingTable).get();
        // Insert merged data into the existing table using batch operation for efficiency
        await dbHelper.database.batch((batch) {
          for (var row in assetTableData) {
            batch.insert(existingTable, row as Insertable<Object?>, mode: InsertMode.insertOrIgnore);
          }
        });

      }

    }

    // final dbPath = await getApplicationDocumentsDirectory();
    // final dbFile = File(join(dbPath.path, 'dbname1.sqlite'));
    // await dbFile.writeAsBytes(byteData.buffer.asUint8List());
  }
}
