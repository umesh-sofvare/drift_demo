import 'dart:async';

import 'package:flutter/material.dart';

import 'database/database.dart';
import 'edit_emp_details_screen.dart';
import 'main.dart';

class EmployeeListScreen extends StatefulWidget {
  const EmployeeListScreen({super.key});

  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  List<Employee> employeesList = [];

  StreamSubscription<List<Employee>>? employeesStream;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getAllEmployees();
    });
    super.initState();
  }

  getAllEmployees() async {
    // employeesList = await dbHelper.getAllEmployees();
    employeesStream = dbHelper.getAllEmployeesStream().listen((event) {
      employeesList = event;
      print("empList--- $event");
      setState(() {});
    });
    // print("data--- $employeesList");
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.separated(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(employeesList[index].name ?? ""),
              subtitle: Text(employeesList[index].salary?.toString() ?? ""),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditEmpDetailsScreen(
                            employee: employeesList[index],
                          ),
                        ));
                      },
                      icon: const Icon(Icons.edit)),
                  IconButton(
                      onPressed: () {
                        dbHelper.deleteEmployeeById(
                            id: employeesList[index].id);
                      },
                      icon: const Icon(Icons.delete)),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemCount: employeesList.length),
    );
  }

  @override
  void dispose() {
    employeesStream?.cancel();
    super.dispose();
  }
}
