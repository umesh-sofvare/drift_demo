import 'package:flutter_test/flutter_test.dart';
import 'package:drift_demo/main.dart' as drift_demo;

import 'package:integration_test/integration_test.dart';

import '../screen/emp_list_screen.dart';
import '../screen/home_screen.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('Drift Test :', () {
    testWidgets(
      'Validate Drift Example',
          (WidgetTester tester) async {
            // Initialing Application for Testing and waiting for it to launch
            drift_demo.main();
            await tester.pump(const Duration(seconds: 5));

            final homeScreen = HomeScreen(tester);

            // Test Data Setup
            const title = '101 Test Employee';

            // Actions to Perform
            await homeScreen.addData();

            // Assertions
            final isInsertDataProperly = await homeScreen.isInsertDataProperly(title);
            expect(isInsertDataProperly, true, reason: 'Expected Data should be created and it should reflect on Home Screen');

            await homeScreen.viewAllEmployList();

            final empListScreen = EmpListScreen(tester);

            final isDataContainInList = await empListScreen.isDataContainInList(title);
            expect(isDataContainInList, true, reason: 'Expected Data should be created and it should reflect on Home Screen');


          },
      skip: false,
      timeout: const Timeout(Duration(minutes: 5)),
    );
  });
}