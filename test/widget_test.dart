import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:propveil/main.dart';
import 'package:propveil/presentation/screens/app_shell.dart';
import 'package:propveil/presentation/screens/dashboard_screen.dart';
import 'package:propveil/presentation/screens/properties_screen.dart';

void main() {
  testWidgets('App builds and onboarding flow transitions on tap', (WidgetTester tester) async {
    // 1. Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify AppShell is in the tree
    expect(find.byType(AppShell), findsOneWidget);
    
    // Bottom navigation should be hidden during onboarding
    expect(find.byType(BottomNavigationBar), findsNothing);
    expect(find.byIcon(Icons.dashboard_outlined), findsNothing);

    // 2. Perform a series of taps on the gesture detector to advance the onboarding flow
    // Onboarding has 12 steps. We tap the center of the screen to advance each step.
    for (int i = 0; i < 12; i++) {
      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
    }

    // After 12 taps, onboarding completes and we transition to the Home Dashboard native screen.
    // 3. Verify native Dashboard screen is visible
    expect(find.byType(NativeDashboardScreen), findsOneWidget);

    // 4. Verify bottom navigation bar is now visible
    expect(find.byIcon(Icons.dashboard_outlined), findsOneWidget);
    expect(find.byIcon(Icons.business_outlined), findsOneWidget);

    // 5. Test Tab Switch: Tap on Properties tab (2nd tab)
    await tester.tap(find.byIcon(Icons.business_outlined));
    await tester.pumpAndSettle();

    // 6. Verify native Properties screen is visible and dashboard is hidden
    expect(find.byType(NativePropertiesScreen), findsOneWidget);
    expect(find.byType(NativeDashboardScreen), findsNothing);
  });
}
