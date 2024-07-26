import 'package:drift_demo/database/database.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class EditEmpDetailsScreen extends StatefulWidget {
  Employee employee;

  EditEmpDetailsScreen({super.key, required this.employee});

  @override
  State<EditEmpDetailsScreen> createState() => _EditEmpDetailsScreenState();
}

class _EditEmpDetailsScreenState extends State<EditEmpDetailsScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController salaryController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.employee.name?.toString() ?? "";
    postController.text = widget.employee.post?.toString() ?? "";
    salaryController.text = widget.employee.salary?.toString() ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(hintText: "emp name"),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: postController,
              decoration: const InputDecoration(hintText: "emp post"),
            ),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: salaryController,
              decoration: const InputDecoration(hintText: "emp salary"),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async{
                  var data =await dbHelper.updateEmpSalary(
                      id: widget.employee.id,
                      employee: Employee(
                        id: widget.employee.id,
                        name: nameController.text,
                        post: postController.text,
                        salary: int.parse(salaryController.text),
                      ));

                },
                child: const Text("Update data")),
          ],
        ),
      ),
    );
  }
}
