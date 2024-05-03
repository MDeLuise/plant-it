import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/commons.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/homepage/homepage.dart';
import 'package:plant_it/logger/logger.dart';
import 'package:plant_it/signup.dart';
import 'package:plant_it/toast/toast_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localizations_injector.dart';
import 'signup_test.mocks.dart';

@GenerateMocks([
  Environment,
  AppHttpClient,
  BuildContext,
  SharedPreferences,
  NavigatorObserver,
  Logger,
  ToastManager,
  Credentials,
])
void main() {
  late MockEnvironment env;
  late MockAppHttpClient http;
  late MockBuildContext context;
  late MockSharedPreferences prefs;
  late MockNavigatorObserver navigatorObserver;
  late MockLogger logger;
  late MockToastManager toastManager;
  late MockCredentials credentials;

  setUp(() {
    // Arrange
    env = MockEnvironment();
    http = MockAppHttpClient();
    context = MockBuildContext();
    prefs = MockSharedPreferences();
    navigatorObserver = MockNavigatorObserver();
    logger = MockLogger();
    toastManager = MockToastManager();
    credentials = MockCredentials();

    // Mock behavior
    when(env.prefs).thenReturn(prefs);
    when(env.http).thenReturn(http);
    when(prefs.setString(any, any)).thenAnswer((_) => Future.value(true));
    when(context.mounted).thenReturn(true);
    when(navigatorObserver.navigator).thenReturn(null);
    when(env.credentials).thenReturn(credentials);
    when(env.logger).thenReturn(logger);
    when(env.toastManager).thenReturn(toastManager);
  });

  testWidgets('Signup widget has a username and password and email labels',
      (tester) async {
    // Act
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: SignupPage(env: env)));

    // Assert and verify
    expect(find.text("Username"), findsOneWidget);
    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Password"), findsOneWidget);
  });

  testWidgets('Validate username and password and email fields',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: SignupPage(env: env)));
    await tester.tap(find.byType(ElevatedLoadingButton));
    await tester.pump();

    // Assert and verify
    final textField = find.byType(TextFormField);
    final errorTextFinder = find.descendant(
      of: textField,
      matching: find.text('Please enter a value'),
    );
    expect(errorTextFinder, findsNWidgets(3));
  });

  void testInvalidEmail(String invalidEmail) {
    testWidgets('Entering invalid email "$invalidEmail" shows error message',
        (tester) async {
      // Act
      await tester.pumpWidget(LocalizationsInjector(
          navigatorObserver: navigatorObserver, child: SignupPage(env: env)));
      final textField = find.byType(TextFormField).at(1);
      await tester.enterText(textField, invalidEmail);
      await tester.tap(find.byType(ElevatedLoadingButton));
      await tester.pump();

      // Assert and verify
      expect(
        find.descendant(
          of: textField,
          matching: find.text('Please enter a valid email'),
        ),
        findsOneWidget,
      );
    });
  }

  void testValidEmail(String invalidEmail) {
    testWidgets('Entering valid email "$invalidEmail" shows no error message',
        (tester) async {
      // Act
      await tester.pumpWidget(LocalizationsInjector(
          navigatorObserver: navigatorObserver, child: SignupPage(env: env)));
      final textField = find.byType(TextFormField).at(1);
      await tester.enterText(textField, invalidEmail);
      await tester.tap(find.byType(ElevatedLoadingButton));
      await tester.pump();

      // Assert and verify
      expect(
        find.descendant(
          of: textField,
          matching: find.text('Please enter a valid email'),
        ),
        findsNothing,
      );
    });
  }

  for (var element in ["a", "foo@", "foo@bar", "foo@bar."]) {
    testInvalidEmail(element);
  }
  for (var element in ["foo@bar.com", "a@b.co"]) {
    testValidEmail(element);
  }

  testWidgets('Correct values and no otp, then login',
      (WidgetTester tester) async {
    // Arrange
    final SignupRequest request = SignupRequest(
      username: "test_username",
      email: "test@email.com",
      password: "test_password",
    );
    const jwt = 'test_jwt';
    const appKey = 'frontend';

    // Mock behavior
    when(credentials.username).thenReturn(request.username);
    when(http.post('authentication/signup', request.toMap())).thenAnswer(
        (_) => Future.value(Response('User registered successfully.', 200)));
    when(http.post('authentication/login', {
      'username': request.username,
      'password': request.password,
    })).thenAnswer((_) => Future.value(Response(
        '{"id": 99, "username": "${request.username}", "email": "${request.email}", "jwt": {"value": "$jwt", "lastLogin": "06-03-2024 11:00:00", "expiresOn": "06-03-2024 11:00:00"}}',
        200)));
    when(http.get('api-key/name/$appKey')).thenAnswer((_) => Future.value(Response(
        '{"statusCode": 404, "errorCode": "RESOURCE_NOT_FOUND", "message": ""}',
        404)));
    when(http.post("api-key/", {"name": appKey}))
        .thenAnswer((_) => Future.value(Response(appKey, 200)));
    when(http.get('diary/entry/type'))
        .thenAnswer((_) => Future.value(Response("{[]}", 200)));
    when(http.get('plant'))
        .thenAnswer((_) => Future.value(Response('{"content": []}', 200)));
    when(env.plants).thenReturn([]);
    when(http.get("diary/entry/type")).thenAnswer((_) => Future.delayed(
        Duration(seconds: 5), () => Response('["SEEDING"]', 200)));
    when(http.get("plant/_count"))
        .thenAnswer((_) => Future.value(Response('0', 200)));
    when(http.get("info/version")).thenAnswer((_) => Future.value(Response(
        '{"currentVersion": "42", "latestVersion": "42", "latestReleaseNote": "42", "latest": true}',
        200)));
    when(http.get("info/notification-dispatchers"))
        .thenAnswer((_) => Future.value(Response('["CONSOLE"]', 200)));
    when(http.get("notification-dispatcher"))
        .thenAnswer((_) => Future.value(Response('["CONSOLE"]', 200)));
    when(http.get("diary/entry?pageNo=0&pageSize=5")).thenAnswer((_) =>
        Future.value(Response(
            '{ "totalPages": 0, "totalElements": 0, "first": true, "last": true, "size": 0, "content": [ { "id": 0, "type": "string", "note": "string", "date": "2024-05-03T09:30:55.883Z", "diaryId": 0, "diaryTargetId": 0, "diaryTargetPersonalName": "string" } ], "number": 0, "sort": { "empty": true, "sorted": true, "unsorted": true }, "pageable": { "offset": 0, "sort": { "empty": true, "sorted": true, "unsorted": true }, "pageNumber": 0, "pageSize": 0, "paged": true, "unpaged": true }, "numberOfElements": 0, "empty": true }',
            200)));

    // Act
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: SignupPage(env: env)));
    final usernameField = find.byType(TextFormField).first;
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).last;
    await tester.enterText(usernameField, request.username);
    await tester.enterText(emailField, request.email);
    await tester.enterText(passwordField, request.password);
    final signupButton = find.byType(ElevatedLoadingButton);
    await tester.tap(signupButton);
    await tester.pumpAndSettle();

    // Assert and verify
    verify(prefs.setString('serverKey', appKey)).called(1);
    verify(prefs.setString('username', request.username)).called(1);
    verify(prefs.setString('email', request.email)).called(1);
    verify(navigatorObserver.didPush(any, any));
    expect(find.byType(HomePage), findsOneWidget);
  });

  // FIXME
  testWidgets('Correct values and otp, then new page',
      (WidgetTester tester) async {
    // Arrange
    //tester.binding.window.physicalSizeTestValue = Size(1000, 1000);
    final SignupRequest request = SignupRequest(
        username: "test_username",
        email: "test@email.com",
        password: "test_password");

    // Mock behavior
    when(http.post('authentication/signup', request.toMap())).thenAnswer((_) =>
        Future.value(Response(
            '{"message": "Signup request pending verification"}', 202)));

    // Act
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: SignupPage(env: env)));
    final usernameField = find.byType(TextFormField).first;
    final emailField = find.byType(TextFormField).at(1);
    final passwordField = find.byType(TextFormField).last;
    await tester.enterText(usernameField, request.username);
    await tester.enterText(emailField, request.email);
    await tester.enterText(passwordField, request.password);
    final signupButton = find.byType(ElevatedLoadingButton);
    await tester.tap(signupButton);
    await tester.pumpAndSettle();

    // Assert and verify
    //addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
    verifyNever(prefs.setString(any, any));
    verify(navigatorObserver.didPush(any, any));
    //expect(find.byType(OTPInsertPage), findsOneWidget);
  }, skip: true);
}
