import 'package:flutter_test/flutter_test.dart';
import 'package:kopi_and_co/main.dart';

void main() {
  testWidgets('Kopi & Co. menu displays correctly', (tester) async {
    await tester.pumpWidget(const KopiAndCoApp());

    expect(find.text('Kopi & Co.'), findsOneWidget);
    expect(find.text('Find your favourite'), findsOneWidget);
    expect(find.text('Kopi Latte'), findsOneWidget);
  });
}
