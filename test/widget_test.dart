import 'package:go_router/go_router.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:lyceumai/my_app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp(router: GoRouter(routes: [])));

    // write test scripts according to the app.
  });
}
