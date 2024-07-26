import 'package:drift_demo/emp_list_screen.dart';
import 'package:flutter/material.dart';

import 'database/database.dart';
import 'database/db_helper.dart';

DBHelper dbHelper = DBHelper();

void main() {
  dbHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Employee? lastRecord = null;

  @override
  void initState() {
    getLastRecord();
    super.initState();
  }

  getLastRecord() {
    dbHelper.getLastRecord().listen((event) {
      if (event.isNotEmpty) {
        lastRecord = event.first;
      } else {
        lastRecord = null;
      }
      setState(() {});
      print("event---- $event");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Last Record",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              lastRecord != null
                  ? Container(
                color: Colors.grey.shade200,
                    child: ListTile(
                        title: Text(lastRecord!.name ?? ""),
                        subtitle: Text(lastRecord!.salary?.toString() ?? ""),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  dbHelper.deleteEmployeeById(id: lastRecord!.id);
                                },
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                  )
                  : const Text("Last record not found"),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    dbHelper.copyDataFromAnotherDatabase();
                  },
                  child: const Text("Copy data")),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    dbHelper.importDatabase();
                  },
                  child: const Text("Import Data")),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                key: ValueKey('addData'),
                  onPressed: () {
                    dbHelper.addEmployee();
                  },
                  child: const Text("Add Data")),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
                    dbHelper.addMultipleEmployee(
                        employees: List.generate(
                            20,
                            (index) => Employee(
                                  id: index + 1,
                                  name: "${index + 1} Test Employee",
                                  post: "Engineering",
                                  salary: 10000,
                                )));
                  },
                  child: const Text("Add Multiple Data")),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                key: const ValueKey("viewAllEmployList"),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EmployeeListScreen(),
                    ));
                  },
                  child: const Text("View All Employee")),
            ],
          ),
        ),
      ),
    );
  }
}
