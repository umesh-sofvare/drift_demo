import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'database.dart';
import 'platform/platform.dart';

class DBHelper {
  late AppDb database;

  init() async {
    database = AppDb(DBCreator.createDatabaseConnection('dbname'));
  }

  int count = 100;

  addEmployee() async {
    count++;
    try {
      database.employees.insertOne(EmployeesCompanion(
        id: Value(count),
        name: Value("$count Test Employee"),
        post: const Value('Employee'),
        salary: const Value(30000),
      ),mode: InsertMode.replace);
    } on Exception catch (e) {
      print("object==== $e");
    }
    // database.employees.insert(const EmployeesCompanion(
    //   name: Value('John Doe'),
    //   post: Value('Manager'),
    //   salary: Value('200000'),
    // ),);
  }

  addMultipleEmployee({required List<Employee> employees}) async {
    await database.batch((batch) {
      // functions in a batch don't have to be awaited - just
      // await the whole batch afterwards.
      batch.insertAll(database.employees, employees,mode: InsertMode.replace);
    });

    // database.employees.insertOne(employees.first, mode: InsertMode.replace);
    // database.employees.insert(const EmployeesCompanion(
    //   name: Value('John Doe'),
    //   post: Value('Manager'),
    //   salary: Value('200000'),
    // ),);
  }

  Future<List<Employee>> getAllEmployees() async {
    // final List<Employee> empList = await database.customSelect('SELECT * FROM employees').get().then((results){
    //   return results.map((row) => Employee.fromJson(row.data)).toList();
    // }); // Replace 'Employee' with your actual table name
    //
    // print("empList--- ${empList}");

    List<Employee> employeeList = await database.employees.select().get();

    return employeeList;
  }

  Stream<List<Employee>> getAllEmployeesStream() {
    // final List<Employee> empList = await database.customSelect('SELECT * FROM employees').get().then((results){
    //   return results.map((row) => Employee.fromJson(row.data)).toList();
    // }); // Replace 'Employee' with your actual table name
    //
    // print("empList--- ${empList}");

    Stream<List<Employee>> employeeList = (database.employees.select()
          ..where((tbl) => tbl.salary.isBiggerThanValue(1500))
          ..orderBy([
            (t) => OrderingTerm(expression: t.salary, mode: OrderingMode.desc)
          ]))
        .watch();
    // print("empList--- ${empList}");

    return employeeList;
  }

  Stream<List<Employee>> getLastRecord() {

    final query = (database.employees.select())
      ..orderBy([(t) => OrderingTerm(expression: t.id,mode: OrderingMode.desc)])
      ..limit(1);

    return query.watch();

  }

  Future<Employee?> getLastEmpRecord() async{

    final query = (database.employees.select())
      ..orderBy([(t) => OrderingTerm(expression: t.id,mode: OrderingMode.desc)])
      ..limit(1);


    List<Employee> employees = await query.get();
    if(employees.isEmpty){
      return null;
    }

    return employees.first;

  }

  Future deleteEmployeeById({required int id}) async {
    return database.employees.deleteWhere((tbl) => tbl.id.equals(id));
  }

  Future updateEmpSalary({required int id, required Employee employee}) async {
    return (database.employees.update()
      ..where((tbl) => tbl.id.equals(id))
      ..write(employee));
  }


  importDatabase()async{
    final byteData = await rootBundle.load('assets/dbname1.sqlite');
    final dbPath = await getApplicationDocumentsDirectory();
    final dbFile = File(join(dbPath.path, 'dbname.sqlite'));
    await dbFile.writeAsBytes(byteData.buffer.asUint8List());
  }

  copyDataFromAnotherDatabase(){
    DBCreator.copyDataFromAnotherDatabase();
  }


}
