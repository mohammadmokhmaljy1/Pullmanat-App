import 'package:flutter_test/flutter_test.dart';

import 'package:pullmanat_app/main.dart';

void main() {
  testWidgets('يعرض شاشة البداية الشعار عند التشغيل', (WidgetTester tester) async {
    await tester.pumpWidget(const PullmanatApp());
    await tester.pump();

    expect(find.byType(PullmanatApp), findsOneWidget);
  });
}
