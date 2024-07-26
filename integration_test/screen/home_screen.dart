import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class HomeScreen {
  late WidgetTester tester;

  final _addData = find.byKey(const ValueKey("addData"));
  final _viewAllEmployList = find.byKey(const ValueKey("viewAllEmployList"));

  Future<void> addData() async {
    await tester.tap(_addData, warnIfMissed: true);
    await tester.pumpAndSettle();
  }

  Future<void> viewAllEmployList() async {
    await tester.tap(_viewAllEmployList, warnIfMissed: true);
    await tester.pumpAndSettle();
  }

  Future<bool> isInsertDataProperly(String title) async {
    final todoLocator = find.descendant(of: find.byType(ListTile), matching: find.text(title));
    return tester.any(todoLocator);
  }

  HomeScreen(this.tester);
}