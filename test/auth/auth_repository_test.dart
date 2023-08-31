//
// class MockAuthController extends Mock implements AuthController {
//   @override
//   void Function() addListener(void Function(AuthState state) listener,
//       {bool fireImmediately = true}) {
//     return () {}; // return a function that does nothing
//   }
//
//   @override
//   void removeListener(void Function(AuthState state) listener) {
//     // do nothing
//   }
// }
//
// void main() async {
//   final mockedAuthController = MockAuthController();
//   final container = ProviderContainer(overrides: [
//     authControllerProvider.overrideWith((ref) => mockedAuthController),
//   ]);
//
//   setUp(() {
//     when(mockedAuthController.state)
//         .thenReturn(const AuthState.isUnauthenticated());
//   });
//
//   testWidgets('SignInPage should have one TabBar', (WidgetTester tester) async {
//     await tester.pumpWidget(
//       UncontrolledProviderScope(
//           container: container, child: const MaterialApp(home: SignInPage())),
//     );
//
//     await tester.pump();
//     expect(find.byType(TabBar), findsOneWidget);
//   });
// }

// void main() {
//   setUp(() async {
//     TestWidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp();
//     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
//     FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
//     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
//   });
//
//   testWidgets('SignInPage should have one TabBar', (WidgetTester tester) async {
//     await tester.pumpWidget(const MaterialApp(
//       home: ProviderScope(child: SignInPage()),
//     ));
//
//     expect(find.byType(TabBar), findsOneWidget);
//   });
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:shopping_list/auth/application/auth_controller.dart';
// import 'package:shopping_list/auth/application/auth_state.dart';
// import 'package:shopping_list/auth/presentation/sign_in_page.dart';
//
// import 'sing_in_page_test.mocks.dart';
//
// @GenerateMocks([AuthController])
// void main() async {
//   final mockedAuthController = MockAuthController();
//   // final container = ProviderContainer(overrides: [
//   //   authControllerProvider.overrideWith((ref) => mockedAuthController),
//   // ]);
//
//   setUp(() {
//     when(mockedAuthController.state)
//         .thenReturn(const AuthState.isUnauthenticated());
//   });
//
//   testWidgets('SignInPage should have one TabBar', (WidgetTester tester) async {
//     await tester.pumpWidget(ProviderScope(
//             overrides: [
//           authControllerProvider.overrideWith((ref) => mockedAuthController),
//         ],
//             child: const MaterialApp(
//               home: SignInPage(),
//             ))
//         // UncontrolledProviderScope(
//         //     container: container, child: const MaterialApp(home: SignInPage())),
//         );
//
//     await tester.pump();
//     expect(find.byType(TabBar), findsOneWidget);
//   });
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shopping_list/auth/presentation/sign_in_page.dart';

void main() {
  testWidgets('SignInPage should have one TabBar', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: ProviderScope(child: SignInPage()),
    ));

    expect(find.byType(TabBar), findsOneWidget);
  });
}
