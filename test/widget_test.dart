import 'package:flutter_test/flutter_test.dart';

import 'package:pullmanat_app/features/auth/providers/auth_provider.dart';
import 'package:pullmanat_app/main.dart';

void main() {
  testWidgets('يعرض شاشة البداية الشعار عند التشغيل', (WidgetTester tester) async {
    final authProvider = AuthProvider();
    await authProvider.initializeSession();

    await tester.pumpWidget(PullmanatApp(authProvider: authProvider));
    await tester.pump();

    expect(find.byType(PullmanatApp), findsOneWidget);
  });
}
