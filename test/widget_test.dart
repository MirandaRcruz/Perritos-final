import 'package:flutter_test/flutter_test.dart';

import 'package:app_perritos/main.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PerritosApp());
    expect(find.text('Perritos App'), findsOneWidget);
  });
}
