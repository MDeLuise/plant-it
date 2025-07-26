// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get enterValue => 'Введіть значення';

  @override
  String get enterValidURL => 'Введіть коректну URL адресу';

  @override
  String get go => 'Продовжити';

  @override
  String get noBackend => 'Не вдається підключитися до сервера';

  @override
  String get ok => 'ОК';

  @override
  String get serverURL => 'Адреса сервера';

  @override
  String get username => 'Ім\'я користувача';

  @override
  String get password => 'Пароль';

  @override
  String get login => 'Вхід';

  @override
  String get badCredentials => 'Невірні облікові дані';

  @override
  String get loginMessage => 'Вітаємо знову на';

  @override
  String get signupMessage => 'Вітаємо на';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Забули пароль?';

  @override
  String get areYouNew => 'Немає акаунту?';

  @override
  String get createAccount => 'Створити обліковий запис';

  @override
  String get email => 'Електронна пошта';

  @override
  String get usernameSize => 'Ім\'я користувача має бути від 3 до 20 символів';

  @override
  String get passwordSize => 'Пароль має бути від 6 до 20 символів';

  @override
  String get enterValidEmail => 'Введіть коректну пошту';

  @override
  String get alreadyRegistered => 'Вже зареєстровані?';

  @override
  String get signup => 'Реєстрація';

  @override
  String get generalError => 'Помилка при виконанні операції';

  @override
  String get error => 'Помилка';

  @override
  String get details => 'Подробиці';

  @override
  String get insertBackendURL =>
      'Привіт друже! Магія починається тут, з налаштування URL-адреси вашого сервера.';

  @override
  String get loginTagline => 'Досліджуйте, вчіться та вирощуйте!';

  @override
  String get singupTagline => 'Давайте рости разом!';

  @override
  String get sentOTPCode =>
      'Будь ласка, введіть код, надісланий на електронну адресу: ';

  @override
  String get verify => 'Підтвердити';

  @override
  String get resendCode => 'Вислати код знову';

  @override
  String get otpCode => 'Одноразовий код';

  @override
  String get splashLoading => 'Біп буп біп... Завантажуємо данні з сервера!';

  @override
  String get welcomeBack => 'З поверненням';

  @override
  String hello(String userName) {
    return 'Привіт, $userName';
  }

  @override
  String get search => 'Пошук';

  @override
  String get today => 'сьогодні';

  @override
  String get yesterday => 'вчора';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'днів',
      few: 'дня',
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
      other: 'днів',
      few: 'дня',
      one: 'день',
    );
    return '$countString $_temp0 в майбутньому (щооо?)';
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
      other: 'місяців',
      few: 'місяця',
      one: 'місяць',
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
      other: 'років',
      few: 'роки',
      one: 'рік',
    );
    return '$countString $_temp0 назад';
  }

  @override
  String get events => 'Події';

  @override
  String get plants => 'Рослини';

  @override
  String get or => 'або';

  @override
  String get filter => 'Фільтр';

  @override
  String get seeding => 'посів';

  @override
  String get watering => 'полив';

  @override
  String get fertilizing => 'удобрення';

  @override
  String get biostimulating => 'біостимуляція';

  @override
  String get misting => 'оприскування';

  @override
  String get transplanting => 'пересаджування';

  @override
  String get water_changing => 'заміна води';

  @override
  String get observation => 'спостереження';

  @override
  String get treatment => 'догляд';

  @override
  String get propagating => 'розмноження';

  @override
  String get pruning => 'підрізка';

  @override
  String get repotting => 'пересаджування у горщик';

  @override
  String get recents => 'Останні події';

  @override
  String get addNewEvent => 'Добавити нову подію';

  @override
  String get selectDate => 'Виберіть дату';

  @override
  String get selectEvents => 'Виберіть подію';

  @override
  String get selectPlants => 'Виберіть рослину';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'нових',
      few: 'нові',
      one: 'нову',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'подій',
      few: 'події',
      one: 'подію',
    );
    return 'Створено $countString $_temp0 $_temp1';
  }

  @override
  String get addNote => 'Додати примітку';

  @override
  String get enterNote => 'Введіть примітку';

  @override
  String get selectAtLeastOnePlant => 'Виберіть хоча б одну рослину';

  @override
  String get selectAtLeastOneEvent => 'Виберіть хоча б одну подію';

  @override
  String get eventSuccessfullyUpdated => 'Подію оновлено успішно';

  @override
  String get editEvent => 'Редагувати подію';

  @override
  String get eventSuccessfullyDeleted => 'Подію видалено успішно';

  @override
  String get noInfoAvailable => 'Немає доступної інформації';

  @override
  String get species => 'Вид';

  @override
  String get plant => 'Рослина';

  @override
  String get scientificClassification => 'Наукова класифікація';

  @override
  String get family => 'Родина';

  @override
  String get genus => 'Рід';

  @override
  String get synonyms => 'Синоніми';

  @override
  String get care => 'Догляд';

  @override
  String get light => 'Освітлення';

  @override
  String get humidity => 'Волога';

  @override
  String get maxTemp => 'Максимальна температура';

  @override
  String get minTemp => 'Мінімальна температура';

  @override
  String get minPh => 'Мінімальний pH';

  @override
  String get maxPh => 'Максимальний pH';

  @override
  String get info => 'Інформація';

  @override
  String get addPhotos => 'Додати фото';

  @override
  String get addEvents => 'Додати події';

  @override
  String get modifyPlant => 'Редагувати рослину';

  @override
  String get removePlant => 'Видалити рослину';

  @override
  String get useBirthday => 'Використовувати день народження';

  @override
  String get birthday => 'День народження';

  @override
  String get avatar => 'Аватар';

  @override
  String get note => 'Примітка';

  @override
  String get stats => 'Статистика';

  @override
  String get eventStats => 'Статистика подій';

  @override
  String get age => 'Вік';

  @override
  String get newBorn => 'Новонароджена';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'днів',
      few: 'дня',
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
      other: 'місяців',
      few: 'місяця',
      one: 'місяць',
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
      other: 'років',
      few: 'роки',
      one: 'рік',
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
      other: 'місяців',
      few: 'місяця',
      one: 'місяць',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'днів',
      few: 'дня',
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
      other: 'років',
      few: 'роки',
      one: 'рік',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'днів',
      few: 'дня',
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
      other: 'років',
      few: 'роки',
      one: 'рік',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'місяців',
      few: 'місяця',
      one: 'місяць',
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
      other: 'років',
      few: 'роки',
      one: 'рік',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'місяців',
      few: 'місяця',
      one: 'місяць',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'днів',
      few: 'дня',
      one: 'день',
    );
    return '$yearsString $_temp0, $monthsString $_temp1, $daysString $_temp2';
  }

  @override
  String get name => 'Ім\'я';

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

    return '$valueString з $maxString';
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
  String get numberOfPhotos => 'Кількість фотографій';

  @override
  String get numberOfEvents => 'Кількість подій';

  @override
  String get searchInYourPlants => 'Шукати у ваших рослинах';

  @override
  String get searchNewGreenFriends => 'Шукати нових зелених друзів';

  @override
  String get custom => 'Користувацька';

  @override
  String get addPlant => 'Додати рослину';

  @override
  String get yes => 'Так';

  @override
  String get no => 'Ні';

  @override
  String get pleaseConfirm => 'Будь ласка підтвердіть';

  @override
  String get areYouSureToRemoveEvent =>
      'Ви впевнені, що хочете видалити подію?';

  @override
  String get areYouSureToRemoveReminder =>
      'Ви впевнені, що хочете видалити нагадування?';

  @override
  String get areYouSureToRemoveSpecies =>
      'Ви впевнені, що хочете видалити вид?';

  @override
  String get areYouSureToRemovePlant =>
      'Ви впевнені, що хочете видалити рослину?';

  @override
  String get purchasedPrice => 'Ціна придбання';

  @override
  String get seller => 'Продавець';

  @override
  String get location => 'Розташування';

  @override
  String get currency => 'Валюта';

  @override
  String get plantUpdatedSuccessfully => 'Рослину було оновлено';

  @override
  String get plantCreatedSuccessfully => 'Рослина була створена';

  @override
  String get insertPrice => 'Введіть ціну';

  @override
  String get noBirthday => 'День народження відсутній';

  @override
  String get appVersion => 'Версія додатку';

  @override
  String get serverVersion => 'Версія серверу';

  @override
  String get documentation => 'Документація';

  @override
  String get openSource => 'Відкритий код';

  @override
  String get reportIssue => 'Повідомити про проблему';

  @override
  String get logout => 'Вийти';

  @override
  String get eventCount => 'Кількість подій';

  @override
  String get plantCount => 'Кількість рослин';

  @override
  String get speciesCount => 'Кількість видів';

  @override
  String get imageCount => 'Кількість зображень';

  @override
  String get unknown => 'Невідомо';

  @override
  String get account => 'Обліковий запис';

  @override
  String get changePassword => 'Змінити пароль';

  @override
  String get more => 'Більше';

  @override
  String get editProfile => 'Редагувати обліковий запис';

  @override
  String get currentPassword => 'Поточний пароль';

  @override
  String get updatePassword => 'Оновити пароль';

  @override
  String get updateProfile => 'Оновити обліковий запис';

  @override
  String get newPassword => 'Новий пароль';

  @override
  String get removeEvent => 'Видалити подію';

  @override
  String get appLog => 'Логи додатку';

  @override
  String get passwordUpdated => 'Пароль було оновлено';

  @override
  String get userUpdated => 'Обліковий запис був оновлено';

  @override
  String get noChangesDetected => 'Зміни не знайдені';

  @override
  String get plantDeletedSuccessfully => 'Рослина була видалена';

  @override
  String get server => 'Сервер';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get changeServer => 'Змінити сервер';

  @override
  String get serverUpdated => 'Сервер успішно змінено';

  @override
  String get changeNotifications => 'Змінити сповіщення';

  @override
  String get updateNotifications => 'Оновити сповіщення';

  @override
  String get notificationUpdated => 'Сповіщення було оновлено';

  @override
  String get supportTheProject => 'Підтримати проект';

  @override
  String get buyMeACoffee => 'Купіть мені каву';

  @override
  String get gallery => 'Галерея';

  @override
  String photosOf(String name) {
    return 'Фотографії $name';
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
      other: 'нових',
      few: 'нові',
      one: 'нову',
    );
    return 'Завантажено $countString $_temp0 фото';
  }

  @override
  String get errorCreatingPlant => 'Помилка при створенні рослини';

  @override
  String get noImages => 'Нема зображень';

  @override
  String get errorCreatingSpecies => 'Помилка при створенні виду';

  @override
  String get errorUpdatingSpecies => 'Помилка при оновленні виду';

  @override
  String get speciesUpdatedSuccessfully => 'Вид було оновлено';

  @override
  String get addCustom => 'Додати користувацьку';

  @override
  String get speciesCreatedSuccessfully => 'Вид було створено';

  @override
  String get uploadPhoto => 'Завантажити фото';

  @override
  String get linkURL => 'URL посилання';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Підтвердити';

  @override
  String get cancel => 'Відмінити';

  @override
  String get actions => 'Дії';

  @override
  String get areYouSureToRemovePhoto => 'Ви точно хочете видалити фото?';

  @override
  String get photoSuccessfullyDeleted => 'Фото було видалено';

  @override
  String get errorUpdatingPlant => 'Помилка при оновленні рослини';

  @override
  String get reminders => 'Нагадування';

  @override
  String get selectStartDate => 'Виберіть дату початку';

  @override
  String get selectEndDate => 'Виберіть дату завершення';

  @override
  String get addNewReminder => 'Додати нове нагадування';

  @override
  String get noEndDate => 'Без кінцевої дати';

  @override
  String get frequency => 'Періодичність';

  @override
  String get repeatAfter => 'Повторити після';

  @override
  String get addNew => 'Додати нове';

  @override
  String get reminderCreatedSuccessfully => 'Нагадування було створене';

  @override
  String get startAndEndDateOrderError =>
      'Початкова дата має бути менше ніж кінцева';

  @override
  String get reminderUpdatedSuccessfully => 'Нагадування було оновлене';

  @override
  String get reminderDeletedSuccessfully => 'Нагадування було видалено';

  @override
  String get errorResettingPassword => 'Помилка при скиданні пароля';

  @override
  String get resetPassword => 'Скинути пароль';

  @override
  String get resetPasswordHeader =>
      'Введіть ім\'я користувача для надсилання запиту на скидання паролю';

  @override
  String get editReminder => 'Редагувати нагадування';

  @override
  String get ntfyServerUrl => 'Ntfy server URL';

  @override
  String get ntfyServerTopic => 'Ntfy server topic';

  @override
  String get ntfyServerUsername => 'Ntfy server username';

  @override
  String get ntfyServerPassword => 'Ntfy server password';

  @override
  String get ntfyServerToken => 'Ntfy server token';

  @override
  String get enterValidTopic => 'Please enter a valid topic';

  @override
  String get ntfySettings => 'Ntfy settings';

  @override
  String get ntfySettingsUpdated => 'Ntfy settings correctly updated';

  @override
  String get modifySpecies => 'Modify species';

  @override
  String get removeSpecies => 'Delete species';

  @override
  String get speciesDeletedSuccessfully => 'Species successfully deleted';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get ops => 'Ops!';

  @override
  String get changeLanguage => 'Change language';

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
