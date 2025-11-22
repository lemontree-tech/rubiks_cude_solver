// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:rubiks_cube_solver/main.dart';

void main() {
  testWidgets('Rubiks cube solver app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RubiksCubeSolverApp());

    // Verify that the app title is present
    expect(find.text('Rubik\'s Cube Solver'), findsOneWidget);
    
    // Verify that the scramble button is present
    expect(find.text('Scramble'), findsOneWidget);
    
    // Verify that the solve button is present
    expect(find.text('Solve'), findsOneWidget);
  });
}
