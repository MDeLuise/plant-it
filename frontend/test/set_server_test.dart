import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/logger/logger.dart';
import 'package:plant_it/login.dart';
import 'package:plant_it/set_server.dart';
import 'package:plant_it/toast/toast_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localizations_injector.dart';
import 'set_server_test.mocks.dart';

@GenerateMocks([
  Environment,
  AppHttpClient,
  BuildContext,
  SharedPreferences,
  NavigatorObserver,
  Logger,
  ToastManager,
])
void main() {
  late MockEnvironment env;
  late MockAppHttpClient http;
  late MockBuildContext context;
  late MockSharedPreferences prefs;
  late MockNavigatorObserver navigatorObserver;
  late MockLogger logger;
  late MockToastManager toastManager;

  setUp(() {
    // Arrange
    env = MockEnvironment();
    http = MockAppHttpClient();
    context = MockBuildContext();
    prefs = MockSharedPreferences();
    navigatorObserver = MockNavigatorObserver();
    logger = MockLogger();
    toastManager = MockToastManager();

    // Mock behavior
    when(env.prefs).thenReturn(prefs);
    when(env.http).thenReturn(http);
    when(prefs.setString(any, any)).thenAnswer((_) => Future.value(true));
    when(context.mounted).thenReturn(true);
    when(navigatorObserver.navigator).thenReturn(null);
    when(env.logger).thenReturn(logger);
    when(env.toastManager).thenReturn(toastManager);
  });

  void testInvalidUrl(String invalidUrl) {
    testWidgets('Entering invalid URL "$invalidUrl" shows error message',
        (tester) async {
      // Act
      await tester.pumpWidget(LocalizationsInjector(
          navigatorObserver: navigatorObserver, child: SetServer(env: env)));
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, invalidUrl);
      await tester.tap(find.text('Continue'));
      await tester.pump();

      // Assert and verify
      expect(
        find.descendant(
          of: textField,
          matching: find.text('Please enter a valid URL'),
        ),
        findsOneWidget,
      );
    });
  }

  void testValidUrl(String validUrl) {
    testWidgets(
        'Entering valid and working URL "$validUrl" navigates to LoginPage',
        (tester) async {
      // Mock behavior
      when(http.get("info/ping"))
          .thenAnswer((_) => Future.value(Response("pong", 200)));

      // Act
      await tester.pumpWidget(LocalizationsInjector(
          navigatorObserver: navigatorObserver, child: SetServer(env: env)));
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, validUrl);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Assert and verify
      verify(navigatorObserver.didPush(any, any));
      expect(find.byType(LoginPage), findsOneWidget);
    });
  }

  void testValidButNotWorkingUrl(String validUrl) {
    testWidgets(
        'Entering valid but not working URL "$validUrl" results in error',
        (tester) async {
      // Mock behavior
      when(http.get("info/ping"))
          .thenAnswer((_) => Future.value(Response("{}", 404)));

      // Act
      await tester.pumpWidget(LocalizationsInjector(
          navigatorObserver: navigatorObserver, child: SetServer(env: env)));
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, validUrl);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Assert and verify
      verify(logger.error(any)).called(1);
      verify(toastManager.showToast(any, any, any)).called(1);
      expect(find.byType(LoginPage), findsNothing);
    });
  }

  void testValidButNotExistingUrl(String validUrl) {
    testWidgets(
        'Entering valid but not existing URL "$validUrl" results in error',
        (tester) async {
      // Mock behavior
      when(http.get("info/ping"))
          .thenThrow(ClientException('Failed to connect'));

      // Act
      await tester.pumpWidget(LocalizationsInjector(
          navigatorObserver: navigatorObserver, child: SetServer(env: env)));
      final textField = find.byType(TextFormField);
      await tester.enterText(textField, validUrl);
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      // Assert and verify
      verify(logger.error(any, any, any)).called(1);
      verify(toastManager.showToast(any, any, any)).called(1);
      expect(find.byType(LoginPage), findsNothing);
    });
  }

  testWidgets('Signup widget has a server URL label', (tester) async {
    // Act
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: SetServer(env: env)));

    // Assert and verify
    expect(find.text("Server URL"), findsOneWidget);
  });

  testInvalidUrl('invalidURL');
  testInvalidUrl('http://');
  testInvalidUrl('https://');
  testInvalidUrl('ftp://');
  //testInvalidUrl('http://19');
  //testInvalidUrl('http://192.168.1');
  //testInvalidUrl('http://192.168.1:200');
  //testInvalidUrl('192.168.1.2:2000');

  testValidUrl('http://example.com');
  testValidUrl('https://example.com');
  testValidUrl('https://192.168.1.108');
  testValidUrl('http://192.168.1.108:0885');
  testValidUrl('https://foo.com:7070');
  testValidUrl('http://plant-it-api.docker.localhost');

  testValidButNotWorkingUrl('http://example.com');
  testValidButNotWorkingUrl('https://example.com');
  testValidButNotWorkingUrl('https://192.168.1.108');
  testValidButNotWorkingUrl('http://192.168.1.108:0885');
  testValidButNotWorkingUrl('https://foo.com:7070');

  testValidButNotExistingUrl('http://example.com');
  testValidButNotExistingUrl('https://example.com');
  testValidButNotExistingUrl('https://192.168.1.108');
  testValidButNotExistingUrl('http://192.168.1.108:0885');
  testValidButNotExistingUrl('https://foo.com:7070');
}
