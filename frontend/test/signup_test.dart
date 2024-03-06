void main() {}
// testWidgets('validate username length', (WidgetTester tester) async {
//     // Act
//     await tester.pumpWidget(LocalizationsInjector(
//         navigatorObserver: navigatorObserver, child: LoginPage(env: env)));
//     await tester.enterText(find.byType(TextFormField).first, 'ab');
//     await tester.tap(find.byType(ElevatedButton));
//     await tester.pump();

//     // Assert and verify
//     expect(find.text('Username length must be between 3 and 20 characters'),
//         findsOneWidget);
//   });

//   testWidgets('validate password length', (WidgetTester tester) async {
//     // Act
//     await tester.pumpWidget(LocalizationsInjector(
//         navigatorObserver: navigatorObserver, child: LoginPage(env: env)));
//     await tester.enterText(find.byType(TextFormField).last, '12');
//     await tester.tap(find.byType(ElevatedButton));
//     await tester.pump();

//     // Assert and verify
//     expect(find.text('Password length must be between 3 and 20 characters'),
//         findsOneWidget);
//   });
// }
