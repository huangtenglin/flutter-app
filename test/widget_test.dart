import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_multi_platform_app/app/app.dart';

void main() {
  testWidgets('Home shows recovery-first modules', (tester) async {
    await tester.pumpWidget(const AppRoot());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Lincoln Elementary'), findsOneWidget);
    expect(find.text('Open map'), findsOneWidget);
    expect(find.text("Today's route"), findsOneWidget);

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pump();

    expect(find.text('YOUR THINGS'), findsOneWidget);
    expect(find.text("Maya's backpack"), findsWidgets);
  });
}
