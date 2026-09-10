import 'package:flutter_test/flutter_test.dart';
import 'package:movewell/main.dart';

void main() {
  testWidgets('MoveWell renders the launch experience', (tester) async {
    await tester.pumpWidget(const MoveWellApp());
    expect(find.byType(MoveWellApp), findsOneWidget);
  });
}
