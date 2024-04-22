import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:material_loading_buttons/material_loading_buttons.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/homepage/homepage.dart';
import 'package:plant_it/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localizations_injector.dart';
import 'login_test.mocks.dart';

@GenerateMocks([
  Environment,
  AppHttpClient,
  BuildContext,
  SharedPreferences,
  NavigatorObserver
])
void main() {
  late MockEnvironment env;
  late MockAppHttpClient http;
  late MockBuildContext context;
  late MockSharedPreferences prefs;
  late MockNavigatorObserver navigatorObserver;

  setUp(() {
    // Arrange
    env = MockEnvironment();
    http = MockAppHttpClient();
    context = MockBuildContext();
    prefs = MockSharedPreferences();
    navigatorObserver = MockNavigatorObserver();

    // Mock behavior
    when(env.prefs).thenReturn(prefs);
    when(env.http).thenReturn(http);
    when(prefs.setString(any, any)).thenAnswer((_) => Future.value(true));
    when(context.mounted).thenReturn(true);
    when(navigatorObserver.navigator).thenReturn(null);
  });

  testWidgets('Login widget has a username and password labels',
      (tester) async {
    // Act
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: LoginPage(env: env)));

    // Assert and verify
    expect(find.text("Username"), findsOneWidget);
    expect(find.text("Password"), findsOneWidget);
  });

  testWidgets('Validate username and password fields',
      (WidgetTester tester) async {
    // Act
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: LoginPage(env: env)));
    await tester.tap(find.byType(ElevatedLoadingButton));
    await tester.pump();

    // Assert and verify
    final textField = find.byType(TextFormField);
    final errorTextFinder = find.descendant(
      of: textField,
      matching: find.text('Please enter a value'),
    );
    expect(errorTextFinder, findsNWidgets(2));
  });

  testWidgets(
      'Correct username and password with already created key, then login',
      (WidgetTester tester) async {
    // Arrange
    const username = 'test_username';
    const password = 'test_password';
    const jwt = 'test_jwt';
    const appKey = 'frontend';

    // Mock behavior
    when(http.post('authentication/login', {
      'username': username,
      'password': password,
    })).thenAnswer((_) => Future.value(Response(
        '{"id": 99, "username": "$username", "jwt": {"value": "$jwt", "expiresOn": "06-03-2024 11:00:00"}}',
        200)));
    when(http.get('api-key/name/$appKey')).thenAnswer((_) => Future.value(Response(
        '{"id": 1, "name": "user_key_1709710168787", "value": "$appKey", "createdOn": "2024-03-06T07:29:28.787+00:00"}',
        200)));
    when(http.get('diary/entry/type'))
        .thenAnswer((_) => Future.value(Response("{[]}", 200)));
    when(http.get('plant'))
        .thenAnswer((_) => Future.value(Response('{"content": []}', 200)));
    when(env.plants).thenReturn([]);

    // Act
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: LoginPage(env: env)));
    final usernameField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;
    await tester.enterText(usernameField, username);
    await tester.enterText(passwordField, password);
    final loginButton = find.byType(ElevatedLoadingButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Assert and verify
    verify(prefs.setString('serverKey', appKey)).called(1);
    verify(prefs.setString('username', username)).called(1);
    verify(navigatorObserver.didPush(any, any));
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('Correct username and password with no previous key, then login',
      (WidgetTester tester) async {
    // Arrange
    const username = 'test_username';
    const password = 'test_password';
    const jwt = 'test_jwt';
    const appKey = 'frontend';

    // Mock behavior
    when(http.post('authentication/login', {
      'username': username,
      'password': password,
    })).thenAnswer((_) => Future.value(Response(
        '{"id": 99, "username": "$username", "jwt": {"value": "$jwt", "expiresOn": "06-03-2024 11:00:00"}}',
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

    // Act
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: LoginPage(env: env)));
    final usernameField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;
    await tester.enterText(usernameField, username);
    await tester.enterText(passwordField, password);
    final loginButton = find.byType(ElevatedLoadingButton);
    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    // Assert and verify
    verify(prefs.setString('serverKey', appKey)).called(1);
    verify(prefs.setString('username', username)).called(1);
    verify(navigatorObserver.didPush(any, any));
    expect(find.byType(HomePage), findsOneWidget);
  });
}
