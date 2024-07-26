import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class EmpListScreen {
  late WidgetTester tester;

  Future<bool> isDataContainInList(String title) async {
    final todoLocator = find.descendant(of: find.byType(ListTile), matching: find.text(title));
    return tester.any(todoLocator);
  }

  EmpListScreen(this.tester);
}