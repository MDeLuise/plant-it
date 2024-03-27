import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plant_it/app_http_client.dart';
import 'package:plant_it/environment.dart';
import 'package:plant_it/event/event_card.dart';
import 'package:plant_it/event/events.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'localizations_injector.dart';
import 'events_test.mocks.dart';

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
    when(env.eventTypes).thenReturn(["eventType1", "eventType2"]);
    when(env.plants).thenReturn([]);
    when(prefs.setString(any, any)).thenAnswer((_) => Future.value(true));
    when(context.mounted).thenReturn(true);
    when(navigatorObserver.navigator).thenReturn(null);
  });

  testWidgets('Events widget has correct fields', (tester) async {
    // Arrange
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: EventsPage(env: env)));
    expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);

    // Act
    await tester.tap(find.byType(Icon));
    await tester.pumpAndSettle();

    // Assert and verify
    expect(find.byIcon(Icons.keyboard_arrow_up), findsOneWidget);
    expect(find.text("Filter"), findsOneWidget);
    expect(find.text("Event"), findsOneWidget);
    expect(find.text("Plant"), findsOneWidget);
  });

  testWidgets('Events widget has correct events', (tester) async {
    // Mock behaviour
    when(http.get("diary/entry?pageNo=0&pageSize=10"))
        .thenAnswer((_) => Future.value(Response('''
  {
    "totalElements": 2,
    "totalPages": 1,
    "first": true,
    "last": true,
    "size": 2,
    "content": [
      {
        "id": 0,
        "type": "WATERING",
        "date": "2024-03-12T13:28:11.237Z",
        "diaryId": 0,
        "diaryTargetId": 0,
        "diaryTargetPersonalName": "foo"
      },
      {
        "id": 1,
        "type": "SEEDING",
        "date": "2024-03-12T13:28:11.237Z",
        "diaryId": 0,
        "diaryTargetId": 0,
        "diaryTargetPersonalName": "foo"
      }
    ],
    "number": 0,
    "sort": {
      "empty": true,
      "unsorted": true,
      "sorted": true
    },
    "numberOfElements": 2,
    "pageable": {
      "offset": 0,
      "sort": {
        "empty": true,
        "unsorted": true,
        "sorted": true
      },
      "pageNumber": 0,
      "pageSize": 2,
      "paged": true,
      "unpaged": true
    },
    "empty": true
  }
  ''', 200)));

    // Arrange
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: EventsPage(env: env)));
    await tester.pumpAndSettle();

    // Assert and verify
    verify(http.get("diary/entry?pageNo=0&pageSize=10")).called(1);
    expect(find.byType(EventCard), findsExactly(2));
  });

  // TODO how to insert the event/plant value in the fields?
  testWidgets('Events widget filter by event type correctly', (tester) async {
    // Mock behaviour
    when(http.get(
            "diary/entry?pageNo=0&pageSize=10&eventTypes=WATERING,SEEDING"))
        .thenAnswer((_) => Future.value(Response('''
  {
    "totalElements": 2,
    "totalPages": 1,
    "first": true,
    "last": true,
    "size": 2,
    "content": [
      {
        "id": 0,
        "type": "WATERING",
        "date": "2024-03-12T13:28:11.237Z",
        "diaryId": 0,
        "diaryTargetId": 0,
        "diaryTargetPersonalName": "foo"
      },
      {
        "id": 1,
        "type": "SEEDING",
        "date": "2024-03-12T13:28:11.237Z",
        "diaryId": 0,
        "diaryTargetId": 0,
        "diaryTargetPersonalName": "foo"
      }
    ],
    "number": 0,
    "sort": {
      "empty": true,
      "unsorted": true,
      "sorted": true
    },
    "numberOfElements": 2,
    "pageable": {
      "offset": 0,
      "sort": {
        "empty": true,
        "unsorted": true,
        "sorted": true
      },
      "pageNumber": 0,
      "pageSize": 2,
      "paged": true,
      "unpaged": true
    },
    "empty": true
  }
  ''', 200)));

    // Arrange
    await tester.pumpWidget(LocalizationsInjector(
        navigatorObserver: navigatorObserver, child: EventsPage(env: env)));
    await tester.pumpAndSettle();

    // Act
    await tester.tap(find.byType(Icon).first);

    // Assert and verify
    verify(http.get(
            "diary/entry?pageNo=0&pageSize=10&eventTypes=WATERING,SEEDING"))
        .called(1);
    expect(find.byType(EventCard), findsExactly(2));
  }, skip: true);
}
