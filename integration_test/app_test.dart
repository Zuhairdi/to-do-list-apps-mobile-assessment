import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:to_do_list_app/main.dart' as app;

void main() => run(_testMain);

void _testMain() {
  testWidgets('Test to-do-list app', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    app.main();

    // Trigger a frame.
    await tester.pumpAndSettle();
  });
}
