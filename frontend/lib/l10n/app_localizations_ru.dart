// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get enterValue => 'Пожалуйста введи значение';

  @override
  String get enterValidURL => 'Пожалуйста введи правильный URL';

  @override
  String get go => 'Продолжить';

  @override
  String get noBackend => 'Невозможно подключиться к серверу';

  @override
  String get ok => 'Ок';

  @override
  String get serverURL => 'Адрес сервера';

  @override
  String get username => 'Имя пользователя';

  @override
  String get password => 'Пароль';

  @override
  String get login => 'Логин';

  @override
  String get badCredentials => 'Неверные учетные данные';

  @override
  String get loginMessage => 'Добро пожаловать обратно';

  @override
  String get signupMessage => 'Добро пожаловать';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Забыл пароль?';

  @override
  String get areYouNew => 'Ты новенький?';

  @override
  String get createAccount => 'Создать аккаунт';

  @override
  String get email => 'Электронная почта';

  @override
  String get usernameSize =>
      'Длина имени пользователя должна составлять от 3 до 20 символов';

  @override
  String get passwordSize =>
      'Длина пароля должна составлять от 6 до 20 символов';

  @override
  String get enterValidEmail =>
      'Пожалуйста введите верный адрес электронной почты';

  @override
  String get alreadyRegistered => 'Уже зарегистрирован?';

  @override
  String get signup => 'Регистрация';

  @override
  String get generalError => 'Ошибка при выполнении операции';

  @override
  String get error => 'Ошибка';

  @override
  String get details => 'Детали';

  @override
  String get insertBackendURL =>
      'Привет друг! Давай сотворим чудо, начнем с настройки адреса вашего сервера.';

  @override
  String get loginTagline => 'Исследуй, учись и совершенствуйся!';

  @override
  String get singupTagline => 'Давай расти вместе!';

  @override
  String get sentOTPCode =>
      'Пожалуйста, введи код, отправленный по электронной почте: ';

  @override
  String get verify => 'Проверка';

  @override
  String get resendCode => 'Отправить повторно';

  @override
  String get otpCode => 'OTP код';

  @override
  String get splashLoading => 'Бип буп бип... Загрузка данных с сервера!';

  @override
  String get welcomeBack => 'С возвращением';

  @override
  String hello(String userName) {
    return 'Привет, $userName';
  }

  @override
  String get search => 'Поиск';

  @override
  String get today => 'сегодня';

  @override
  String get yesterday => 'вчера';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'дней',
      one: 'день',
    );
    return '$countString $_temp0 назад';
  }

  @override
  String nDaysInFuture(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'дней',
      one: 'день',
    );
    return '$countString $_temp0 в будущем (чтооо?)';
  }

  @override
  String nMonthsAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'месяцев',
      one: 'месяц',
    );
    return '$countString $_temp0 назад';
  }

  @override
  String nYearsAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'лет',
      one: 'год',
    );
    return '$countString $_temp0 назад';
  }

  @override
  String get events => 'События';

  @override
  String get plants => 'Растения';

  @override
  String get or => 'или';

  @override
  String get filter => 'Фильтр';

  @override
  String get seeding => 'Посев';

  @override
  String get watering => 'Полив';

  @override
  String get fertilizing => 'Удобрение';

  @override
  String get biostimulating => 'Биостимуляция';

  @override
  String get misting => 'Опрыскивание';

  @override
  String get transplanting => 'Пересадка';

  @override
  String get water_changing => 'Смена воды';

  @override
  String get observation => 'Наблюдение';

  @override
  String get treatment => 'Обработка';

  @override
  String get propagating => 'Размножение';

  @override
  String get pruning => 'Обрезка';

  @override
  String get repotting => 'Пересадка';

  @override
  String get recents => 'Недавние события';

  @override
  String get addNewEvent => 'Добавить новое событие';

  @override
  String get selectDate => 'Выбор даты';

  @override
  String get selectEvents => 'Выбор события';

  @override
  String get selectPlants => 'Выбор растения';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'событий',
      one: 'событие',
    );
    return 'Создано $countString новое $_temp0';
  }

  @override
  String get addNote => 'Добавить заметку';

  @override
  String get enterNote => 'Текст заметки';

  @override
  String get selectAtLeastOnePlant => 'Выбери хотя бы одно растение';

  @override
  String get selectAtLeastOneEvent => 'Выбери хотя бы одно событие';

  @override
  String get eventSuccessfullyUpdated => 'Событие успешно обновлено';

  @override
  String get editEvent => 'Редактировать событие';

  @override
  String get eventSuccessfullyDeleted => 'Событие успешно удалено';

  @override
  String get noInfoAvailable => 'Информация недоступна';

  @override
  String get species => 'Вид';

  @override
  String get plant => 'Растение';

  @override
  String get scientificClassification => 'Научная классификация';

  @override
  String get family => 'Семейство';

  @override
  String get genus => 'Сорт';

  @override
  String get synonyms => 'Синонимы';

  @override
  String get care => 'Уход';

  @override
  String get light => 'Свет';

  @override
  String get humidity => 'Влажность';

  @override
  String get maxTemp => 'Максимальная температура';

  @override
  String get minTemp => 'Минимальная температура';

  @override
  String get minPh => 'Минимальный ph';

  @override
  String get maxPh => 'Максимальный ph';

  @override
  String get info => 'Информация';

  @override
  String get addPhotos => 'Добавить фото';

  @override
  String get addEvents => 'Добавить события';

  @override
  String get modifyPlant => 'Изменить растение';

  @override
  String get removePlant => 'Удалить растение';

  @override
  String get useBirthday => 'Использовать день высадки';

  @override
  String get birthday => 'День высадки';

  @override
  String get avatar => 'Аватар';

  @override
  String get note => 'Заметка';

  @override
  String get stats => 'Статистика';

  @override
  String get eventStats => 'Статистика событий';

  @override
  String get age => 'Возраст';

  @override
  String get newBorn => 'Нововысаженный';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'дней',
      one: 'день',
    );
    return '$countString $_temp0';
  }

  @override
  String nMonths(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'месяцев',
      one: 'месяц',
    );
    return '$countString $_temp0';
  }

  @override
  String nYears(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'лет',
      one: 'год',
    );
    return '$countString $_temp0';
  }

  @override
  String nMonthsAndDays(num months, num days) {
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String monthsString = monthsNumberFormat.format(months);
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'месяцев',
      one: 'месяц',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'дней',
      one: 'день',
    );
    return '$monthsString $_temp0, $daysString $_temp1';
  }

  @override
  String nYearsAndDays(num years, num days) {
    final intl.NumberFormat yearsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String yearsString = yearsNumberFormat.format(years);
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'лет',
      one: 'год',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'дней',
      one: 'день',
    );
    return '$yearsString $_temp0, $daysString $_temp1';
  }

  @override
  String nYearsAndMonths(num years, num months) {
    final intl.NumberFormat yearsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String yearsString = yearsNumberFormat.format(years);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String monthsString = monthsNumberFormat.format(months);

    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'лет',
      one: 'год',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'месяцев',
      one: 'месяц',
    );
    return '$yearsString $_temp0, $monthsString $_temp1';
  }

  @override
  String nYearsAndMonthsAndDays(num years, num months, num days) {
    final intl.NumberFormat yearsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String yearsString = yearsNumberFormat.format(years);
    final intl.NumberFormat monthsNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String monthsString = monthsNumberFormat.format(months);
    final intl.NumberFormat daysNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String daysString = daysNumberFormat.format(days);

    String _temp0 = intl.Intl.pluralLogic(
      years,
      locale: localeName,
      other: 'лет',
      one: 'год',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'месяцев',
      one: 'месяц',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'дней',
      one: 'день',
    );
    return '$yearsString $_temp0, $monthsString $_temp1, $daysString $_temp2';
  }

  @override
  String get name => 'Название';

  @override
  String nOutOf(num value, num max) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String valueString = valueNumberFormat.format(value);
    final intl.NumberFormat maxNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String maxString = maxNumberFormat.format(max);

    return '$valueString из $maxString';
  }

  @override
  String temp(num value) {
    final intl.NumberFormat valueNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString °C';
  }

  @override
  String get numberOfPhotos => 'Количество фото';

  @override
  String get numberOfEvents => 'Количество событий';

  @override
  String get searchInYourPlants => 'Искать среди моих растений';

  @override
  String get searchNewGreenFriends => 'Найди новых зеленых друзей';

  @override
  String get custom => 'Custom';

  @override
  String get addPlant => 'Добавить растение';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get pleaseConfirm => 'Пожалуйста подтверди';

  @override
  String get areYouSureToRemoveEvent => 'Ты точно хочешь удалить событие?';

  @override
  String get areYouSureToRemoveReminder =>
      'Ты точно хочешь удалить напоминание?';

  @override
  String get areYouSureToRemoveSpecies => 'Ты точно хочешь удалить вид?';

  @override
  String get areYouSureToRemovePlant => 'Ты точно хочешь удалить растение?';

  @override
  String get purchasedPrice => 'Цена покупки';

  @override
  String get seller => 'Продавец';

  @override
  String get location => 'Местоположение';

  @override
  String get currency => 'Валюта';

  @override
  String get plantUpdatedSuccessfully => 'Растение успешно обновлено';

  @override
  String get plantCreatedSuccessfully => 'Растение успешно создано';

  @override
  String get insertPrice => 'Введи цену';

  @override
  String get noBirthday => 'Нет дня высдки';

  @override
  String get appVersion => 'Версия приложения';

  @override
  String get serverVersion => 'Версия сервера';

  @override
  String get documentation => 'Документация';

  @override
  String get openSource => 'Источник';

  @override
  String get reportIssue => 'Сообщить о проблеме';

  @override
  String get logout => 'Выйти';

  @override
  String get eventCount => 'Количество событий';

  @override
  String get plantCount => 'Количество растений';

  @override
  String get speciesCount => 'Количество видов';

  @override
  String get imageCount => 'Количество фото';

  @override
  String get unknown => 'Неизвестно';

  @override
  String get account => 'Аккаунт';

  @override
  String get changePassword => 'Сменить пароль';

  @override
  String get more => 'Больше';

  @override
  String get editProfile => 'Редактировать профиль';

  @override
  String get currentPassword => 'Текущий пароль';

  @override
  String get updatePassword => 'Обновить пароль';

  @override
  String get updateProfile => 'Обновить профиль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get removeEvent => 'Удалить событие';

  @override
  String get appLog => 'Журнал приложения';

  @override
  String get passwordUpdated => 'Пароль успешно обновлен';

  @override
  String get userUpdated => 'Пользователь успешно обновлен';

  @override
  String get noChangesDetected => 'Изменений не обнаружено';

  @override
  String get plantDeletedSuccessfully => 'Растение успешно удалено';

  @override
  String get server => 'Сервер';

  @override
  String get notifications => 'Уведомления';

  @override
  String get changeServer => 'Сменить сервер';

  @override
  String get serverUpdated => 'Сервер успешно обновлен';

  @override
  String get changeNotifications => 'Изменить уведомления';

  @override
  String get updateNotifications => 'Обновить уведомления';

  @override
  String get notificationUpdated => 'Уведомление успешно обновлено';

  @override
  String get supportTheProject => 'Поддержать проект';

  @override
  String get buyMeACoffee => 'Купи мне кофе';

  @override
  String get gallery => 'Галерея';

  @override
  String photosOf(String name) {
    return 'Фото $name';
  }

  @override
  String nPhoto(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'фото',
      one: 'фото',
    );
    return 'Загружено $countString новое $_temp0';
  }

  @override
  String get errorCreatingPlant => 'Ошибка при создании растения';

  @override
  String get noImages => 'Нет изображения';

  @override
  String get errorCreatingSpecies => 'Ошибка при создании вида';

  @override
  String get errorUpdatingSpecies => 'Ошибка при обновлении вида';

  @override
  String get speciesUpdatedSuccessfully => 'Вид успешно обновлен';

  @override
  String get addCustom => 'Добавить пользовательское';

  @override
  String get speciesCreatedSuccessfully => 'Вид успешно создан';

  @override
  String get uploadPhoto => 'Загрузить фото';

  @override
  String get linkURL => 'Адрес';

  @override
  String get url => 'Ссылка';

  @override
  String get submit => 'Подтвердить';

  @override
  String get cancel => 'Отменить';

  @override
  String get actions => 'Действия';

  @override
  String get areYouSureToRemovePhoto => 'Точно удалть фото?';

  @override
  String get photoSuccessfullyDeleted => 'Фото успешно удалено';

  @override
  String get errorUpdatingPlant => 'Ошибка обновления растения';

  @override
  String get reminders => 'Напоминания';

  @override
  String get selectStartDate => 'Выбери дату начала';

  @override
  String get selectEndDate => 'Выбери дату окончания';

  @override
  String get addNewReminder => 'Добавить новое напоминание';

  @override
  String get noEndDate => 'Нет даты окончания';

  @override
  String get frequency => 'Частота';

  @override
  String get repeatAfter => 'Повтори после';

  @override
  String get addNew => 'Добавить новое';

  @override
  String get reminderCreatedSuccessfully => 'Напоминание успешно создано';

  @override
  String get startAndEndDateOrderError =>
      'Дата начала должна быть раньше даты окончания';

  @override
  String get reminderUpdatedSuccessfully => 'Напоминание успешно обновлено';

  @override
  String get reminderDeletedSuccessfully => 'Напоминание успешно удалено';

  @override
  String get errorResettingPassword => 'Ошибка при сбросе пароля';

  @override
  String get resetPassword => 'Сброс пароля';

  @override
  String get resetPasswordHeader =>
      'Введи имя пользователя, чтобы отправить запрос на сброс пароля';

  @override
  String get editReminder => 'Редактировать Напоминание';

  @override
  String get ntfyServerUrl => 'Адрес сервера Ntfy';

  @override
  String get ntfyServerTopic => 'Тема сервера Ntfy';

  @override
  String get ntfyServerUsername => 'Имя пользователя сервера Ntfy';

  @override
  String get ntfyServerPassword => 'Пароль сервера Ntfy';

  @override
  String get ntfyServerToken => 'Токен сервера Ntfy';

  @override
  String get enterValidTopic => 'Пожалуйста, укажи правильную тему';

  @override
  String get ntfySettings => 'Настройки Ntfy';

  @override
  String get ntfySettingsUpdated => 'Корректно обновлены настройки Ntfy';

  @override
  String get modifySpecies => 'Изменить вид';

  @override
  String get removeSpecies => 'Удалить вид';

  @override
  String get speciesDeletedSuccessfully => 'Вид успешно удален';

  @override
  String get success => 'Успех';

  @override
  String get warning => 'Предупреждение';

  @override
  String get ops => 'Упс!';

  @override
  String get changeLanguage => 'Сменить язык';

  @override
  String get gotifyServerUrl => 'Gotify server URL';

  @override
  String get gotifyServerToken => 'Gotify server token';

  @override
  String get gotifySettings => 'Gotify settings';

  @override
  String get gotifySettingsUpdated => 'Gotify settings correctly updated';

  @override
  String get activity => 'Activity';

  @override
  String get fromDate => 'from';

  @override
  String frequencyEvery(num amount, String unit) {
    return 'every $amount $unit';
  }

  @override
  String day(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String week(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'weeks',
      one: 'week',
    );
    return '$_temp0';
  }

  @override
  String month(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'months',
      one: 'month',
    );
    return '$_temp0';
  }

  @override
  String year(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'years',
      one: 'year',
    );
    return '$_temp0';
  }
}
