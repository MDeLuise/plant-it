import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:plant_it/data/repository/notifications_lang_repository.dart';
import 'package:plant_it/data/repository/reminder_repository.dart';
import 'package:plant_it/data/repository/user_setting_repository.dart';
import 'package:plant_it/data/service/notification_service.dart';
import 'package:plant_it/data/service/scheduling_service.dart';
import 'package:plant_it/data/service/search/cache/app_cache.dart';
import 'package:plant_it/data/service/search/flora_codex_searcher.dart';
import 'package:plant_it/domain/models/user_settings_keys.dart';
import 'package:plant_it/ui/settings/view_models/settings_viewmodel.dart';
import 'package:result_dart/result_dart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'settings_viewmodel_test.mocks.dart';

@GenerateMocks([
  UserSettingRepository,
  ReminderRepository,
  SchedulingService,
  NotificationService,
  NotificationsLangRepository,
  AppCache,
  FloraCodexSearcher,
])
void main() {
  provideDummy<Result<void>>(Success('ok'));

  group('SettingsViewModel Flora Codex key save', () {
    late SettingsViewModel viewModel;
    late MockUserSettingRepository userSettingRepository;
    late MockAppCache appCache;
    late MockFloraCodexSearcher floraCodexSearcher;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final SharedPreferences pref = await SharedPreferences.getInstance();

      userSettingRepository = MockUserSettingRepository();
      appCache = MockAppCache();
      floraCodexSearcher = MockFloraCodexSearcher();

      when(userSettingRepository.put(any, any))
          .thenAnswer((_) async => Success('ok'));
      when(appCache.clearSearch()).thenAnswer((_) async {});

      viewModel = SettingsViewModel(
        userSettingRepository: userSettingRepository,
        reminderRepository: MockReminderRepository(),
        schedulingService: MockSchedulingService(),
        notificationService: MockNotificationService(),
        notificationsLangRepository: MockNotificationsLangRepository(),
        sharedPreferences: pref,
        appCache: appCache,
        floraCodexSearcher: floraCodexSearcher,
      );
    });

    test(
        'refreshes the searcher key and clears the search cache when the Flora Codex key is saved',
        () async {
      await viewModel.save.executeWithFuture({
        UserSettingsKeys.floraCodexKey.key: 'my-secret-key',
      });

      verify(floraCodexSearcher.setKey('my-secret-key')).called(1);
      verify(appCache.clearSearch()).called(1);
    });

    test(
        'does not touch the searcher or search cache when an unrelated setting is saved',
        () async {
      await viewModel.save.executeWithFuture({
        UserSettingsKeys.useFloraCodex.key: 'true',
      });

      verifyNever(floraCodexSearcher.setKey(any));
      verifyNever(appCache.clearSearch());
    });
  });
}
