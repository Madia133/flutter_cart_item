// This is a basic Flutter widget test.

import 'package:flutter_test/flutter_test.dart';
import 'package:provider_test/main.dart';

void main() {
  testWidgets('It should test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyCartApp());
  });
}
