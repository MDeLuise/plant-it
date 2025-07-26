// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get enterValue => 'Proszę wprowadzić wartość';

  @override
  String get enterValidURL => 'Proszę wprowadzić prawidłowy adres URL';

  @override
  String get go => 'Kontynuuj';

  @override
  String get noBackend => 'Nie mogę podłączyć się do serwera';

  @override
  String get ok => 'Ok';

  @override
  String get serverURL => 'URL serwera';

  @override
  String get username => 'Użytkownik';

  @override
  String get password => 'Hasło';

  @override
  String get login => 'Login';

  @override
  String get badCredentials => 'Błędne dane';

  @override
  String get loginMessage => 'Witaj z powrotem';

  @override
  String get signupMessage => 'Witaj';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Zapomniałeś hasła?';

  @override
  String get areYouNew => 'Jesteś tu nowy?';

  @override
  String get createAccount => 'Stwórz konto';

  @override
  String get email => 'Email';

  @override
  String get usernameSize => 'Nazwa użytkownika musi mieć od 3 do 20 znaków';

  @override
  String get passwordSize => 'Hasło musi mieć długość od 6 do 20 znaków';

  @override
  String get enterValidEmail => 'Proszę wprowadzić prawidłowy adres email';

  @override
  String get alreadyRegistered => 'Jesteś zarejestrowany?';

  @override
  String get signup => 'Rejestracja';

  @override
  String get generalError => 'Błąd podczas wykonywania operacji';

  @override
  String get error => 'Błąd';

  @override
  String get details => 'Detale';

  @override
  String get insertBackendURL =>
      'Witaj przyjacielu! Żeby zacząć podaj adres URL swojego serwera.';

  @override
  String get loginTagline => 'Odkrywaj, ucz się i hoduj!';

  @override
  String get singupTagline => 'Wyhodujmy coś razem!';

  @override
  String get sentOTPCode => 'Wpisz kod wysłany na adres email: ';

  @override
  String get verify => 'Weryfikuj';

  @override
  String get resendCode => 'Wyślij kod ponownie';

  @override
  String get otpCode => 'Kod OTP';

  @override
  String get splashLoading => 'Bip bip bip... ładowanie danych z serwera!';

  @override
  String get welcomeBack => 'Witaj ponownie';

  @override
  String hello(String userName) {
    return 'Witaj, $userName';
  }

  @override
  String get search => 'Wyszukaj';

  @override
  String get today => 'dzisiaj';

  @override
  String get yesterday => 'wczoraj';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dni',
      one: 'dzień',
    );
    return '$countString $_temp0 temu';
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
      other: 'dni',
      one: 'dzień',
    );
    return '$countString $_temp0 w przyszłości (coooo?)';
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
      other: 'miesięcy',
      one: 'miesiąc',
    );
    return '$countString $_temp0 temu';
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
      other: 'lata',
      one: 'rok',
    );
    return '$countString $_temp0 temu';
  }

  @override
  String get events => 'Zdarzenia';

  @override
  String get plants => 'Rośliny';

  @override
  String get or => 'lub';

  @override
  String get filter => 'Filtruj';

  @override
  String get seeding => 'wysiew';

  @override
  String get watering => 'podlewanie';

  @override
  String get fertilizing => 'nawożenie';

  @override
  String get biostimulating => 'biostymulacja';

  @override
  String get misting => 'zraszanie';

  @override
  String get transplanting => 'przeszczepianie';

  @override
  String get water_changing => 'wymienianie wody';

  @override
  String get observation => 'obserwacja';

  @override
  String get treatment => 'zabieg';

  @override
  String get propagating => 'rozmnażanie';

  @override
  String get pruning => 'przycinanie';

  @override
  String get repotting => 'przesadzanie';

  @override
  String get recents => 'Niedawne';

  @override
  String get addNewEvent => 'Dodaj nowe zdarzenie';

  @override
  String get selectDate => 'Wybierz datę';

  @override
  String get selectEvents => 'Wybierz zdarzenia';

  @override
  String get selectPlants => 'Wybierz rośliny';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'zdarzenia',
      one: 'zdarzenie',
    );
    return 'Stworzono $countString nowe $_temp0';
  }

  @override
  String get addNote => 'Dodaj notatkę';

  @override
  String get enterNote => 'Wprowadź notatkę';

  @override
  String get selectAtLeastOnePlant => 'Wybierz przynajmniej jedną roślinę';

  @override
  String get selectAtLeastOneEvent => 'Wybierz przynajmniej jedno zdarzenie';

  @override
  String get eventSuccessfullyUpdated => 'Zdarzenie zaktualizowane pomyślnie';

  @override
  String get editEvent => 'Edytuj zdarzenie';

  @override
  String get eventSuccessfullyDeleted => 'Zdarzenie usunięto prawidłowo';

  @override
  String get noInfoAvailable => 'Brak informacji';

  @override
  String get species => 'Gatunki';

  @override
  String get plant => 'Roślina';

  @override
  String get scientificClassification => 'Klasyfikacja naukowa';

  @override
  String get family => 'Rodzina';

  @override
  String get genus => 'Rodzaj';

  @override
  String get synonyms => 'Synonimy';

  @override
  String get care => 'Opieka';

  @override
  String get light => 'Światło';

  @override
  String get humidity => 'Wilgotność';

  @override
  String get maxTemp => 'Maksymalna temperatura';

  @override
  String get minTemp => 'Minimalna temperatura';

  @override
  String get minPh => 'Minimalne pH';

  @override
  String get maxPh => 'Maksymalne pH';

  @override
  String get info => 'Informacje';

  @override
  String get addPhotos => 'Dodaj zdjęcie';

  @override
  String get addEvents => 'Dodaj zdarzenie';

  @override
  String get modifyPlant => 'Edytuj roślinę';

  @override
  String get removePlant => 'Usuń roślinę';

  @override
  String get useBirthday => 'Użyj urodzin';

  @override
  String get birthday => 'Urodziny';

  @override
  String get avatar => 'Awatar';

  @override
  String get note => 'Notatka';

  @override
  String get stats => 'Statystyki';

  @override
  String get eventStats => 'Statystyki zdarzenia';

  @override
  String get age => 'Wiek';

  @override
  String get newBorn => 'Nowa roślina';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dni',
      one: 'dzień',
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
      other: 'miesięcy',
      one: 'miesiąc',
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
      other: 'lata',
      one: 'rok',
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
      other: 'miesięcy',
      one: 'miesiąc',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dni',
      one: 'dzień',
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
      other: 'lata',
      one: 'rok',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dni',
      one: 'dzień',
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
      other: 'lata',
      one: 'rok',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'miesięcy',
      one: 'miesiąc',
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
      other: 'lat',
      one: 'rok',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'miesięcy',
      one: 'miesiąc',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dni',
      one: 'dzień',
    );
    return '$yearsString $_temp0, $monthsString $_temp1, $daysString $_temp2';
  }

  @override
  String get name => 'Nazwa';

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

    return '$valueString z $maxString';
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
  String get numberOfPhotos => 'Ilość zdjęć';

  @override
  String get numberOfEvents => 'Ilość zdarzeń';

  @override
  String get searchInYourPlants => 'Wyszukuj w swoich roślinach';

  @override
  String get searchNewGreenFriends => 'Szukaj nowych zielonych przyjaciół';

  @override
  String get custom => 'Custom';

  @override
  String get addPlant => 'Add Plant';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get pleaseConfirm => 'Proszę potwierdzić';

  @override
  String get areYouSureToRemoveEvent =>
      'Czy na pewno chcesz usunąć wydarzenie?';

  @override
  String get areYouSureToRemoveReminder =>
      'Czy na pewno chcesz usunąć przypomnienie?';

  @override
  String get areYouSureToRemoveSpecies => 'Czy na pewno chcesz usunąć gatunek?';

  @override
  String get areYouSureToRemovePlant => 'Czy na pewno chcesz usunąć roślinę?';

  @override
  String get purchasedPrice => 'Cena zakupu';

  @override
  String get seller => 'Sprzedawca';

  @override
  String get location => 'Lokalizacja';

  @override
  String get currency => 'Waluta';

  @override
  String get plantUpdatedSuccessfully => 'Roślina zaktualizowana pomyślnie';

  @override
  String get plantCreatedSuccessfully => 'Roślina utworzona pomyślnie';

  @override
  String get insertPrice => 'Wprowadź cenę';

  @override
  String get noBirthday => 'Brak urodzin';

  @override
  String get appVersion => 'Wersja aplikacji';

  @override
  String get serverVersion => 'Wersja serwera';

  @override
  String get documentation => 'Dokumentacja';

  @override
  String get openSource => 'Otwarte źródło';

  @override
  String get reportIssue => 'Zgłoś problem';

  @override
  String get logout => 'Wyloguj';

  @override
  String get eventCount => 'Ilość zdarzeń';

  @override
  String get plantCount => 'Ilość roślin';

  @override
  String get speciesCount => 'Ilość gatunków';

  @override
  String get imageCount => 'Ilość zdjęć';

  @override
  String get unknown => 'Nieznane';

  @override
  String get account => 'Konto';

  @override
  String get changePassword => 'Zmień hasło';

  @override
  String get more => 'Więcej';

  @override
  String get editProfile => 'Edytuj profil';

  @override
  String get currentPassword => 'Bieżące hasło';

  @override
  String get updatePassword => 'Zmień hasło';

  @override
  String get updateProfile => 'Zaktualizuj profil';

  @override
  String get newPassword => 'Nowe hasło';

  @override
  String get removeEvent => 'Usuń zdarzenie';

  @override
  String get appLog => 'Logi aplikacji';

  @override
  String get passwordUpdated => 'Hasło pomyślnie zmienione';

  @override
  String get userUpdated => 'Użytkownik pomyślnie zaktualizowany';

  @override
  String get noChangesDetected => 'Nie wykryto żadnych zmian';

  @override
  String get plantDeletedSuccessfully => 'Roślina pomyślnie usunięta';

  @override
  String get server => 'Serwer';

  @override
  String get notifications => 'Powiadomienia';

  @override
  String get changeServer => 'Zmień serwer';

  @override
  String get serverUpdated => 'Serwer pomyślnie zaktualizowany';

  @override
  String get changeNotifications => 'Zmień powiadomienia';

  @override
  String get updateNotifications => 'Zaktualizuj powiadomienia';

  @override
  String get notificationUpdated => 'Powiadomienia zaktualizowane pomyślnie';

  @override
  String get supportTheProject => 'Wesprzyj projekt';

  @override
  String get buyMeACoffee => 'Kup mi kawę';

  @override
  String get gallery => 'Galeria';

  @override
  String photosOf(String name) {
    return 'Zdjęcie $name';
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
      other: 'zdjęcia',
      one: 'zdjęcie',
    );
    return 'Wgrano $countString nowe $_temp0';
  }

  @override
  String get errorCreatingPlant => 'Błąd podczas tworzenia rośliny';

  @override
  String get noImages => 'Brak zdjęć';

  @override
  String get errorCreatingSpecies => 'Błąd podczas tworzenia gatunku';

  @override
  String get errorUpdatingSpecies => 'Błąd podczas aktualizacji gatunku';

  @override
  String get speciesUpdatedSuccessfully => 'Gatunek pomyślnie zaktualizowany';

  @override
  String get addCustom => 'Dodaj własne';

  @override
  String get speciesCreatedSuccessfully => 'Gatunek pomyślnie utworzony';

  @override
  String get uploadPhoto => 'Wgraj zdjęcie';

  @override
  String get linkURL => 'Odnośnik URL';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Potwierdź';

  @override
  String get cancel => 'Anuluj';

  @override
  String get actions => 'Czynności';

  @override
  String get areYouSureToRemovePhoto =>
      'Czy na pewno chcesz usunąć to zdjęcie?';

  @override
  String get photoSuccessfullyDeleted => 'Zdjęcie usunięte prawidłowo';

  @override
  String get errorUpdatingPlant => 'Błąd podczas aktualizacji rośliny';

  @override
  String get reminders => 'Przypomnienia';

  @override
  String get selectStartDate => 'Wybierz datę początkową';

  @override
  String get selectEndDate => 'Wybierz datę końcową';

  @override
  String get addNewReminder => 'Dodaj nowe przypomnienie';

  @override
  String get noEndDate => 'Brak daty końcowej';

  @override
  String get frequency => 'Częstotliwość';

  @override
  String get repeatAfter => 'Powtórz po';

  @override
  String get addNew => 'Dodaj nowe';

  @override
  String get reminderCreatedSuccessfully => 'Przypomnienie utworzono pomyślnie';

  @override
  String get startAndEndDateOrderError =>
      'Data początkowa musi poprzedzać datę końcową';

  @override
  String get reminderUpdatedSuccessfully =>
      'Przypomnienie pomyślnie zaktualizowane';

  @override
  String get reminderDeletedSuccessfully => 'Przypomnienie pomyślnie usunięte';

  @override
  String get errorResettingPassword => 'Błąd podczas resetowania hasła';

  @override
  String get resetPassword => 'Resetuj hasło';

  @override
  String get resetPasswordHeader =>
      'Podaj nazwę użytkownika, aby zresetować hasło';

  @override
  String get editReminder => 'Edytuj przypomnienie';

  @override
  String get ntfyServerUrl => 'URL serwera Ntfy';

  @override
  String get ntfyServerTopic => 'Topic serwera Ntfy';

  @override
  String get ntfyServerUsername => 'Użytkownik serwera Ntfy';

  @override
  String get ntfyServerPassword => 'Hasło serwera Ntfy';

  @override
  String get ntfyServerToken => 'Token serwera Ntfy';

  @override
  String get enterValidTopic => 'Podaj prawidłowy topic';

  @override
  String get ntfySettings => 'Ustawienia Ntfy';

  @override
  String get ntfySettingsUpdated => 'Ustawienia Ntfy pomyślnie zaktualizowane';

  @override
  String get modifySpecies => 'Edytuj gatunek';

  @override
  String get removeSpecies => 'Usuń gatunek';

  @override
  String get speciesDeletedSuccessfully => 'Gatunek pomyślnie usunięty';

  @override
  String get success => 'Powodzenie';

  @override
  String get warning => 'Ostrzeżenie';

  @override
  String get ops => 'Ups!';

  @override
  String get changeLanguage => 'Zmień język';

  @override
  String get gotifyServerUrl => 'URL serwera Gotify';

  @override
  String get gotifyServerToken => 'Token serwera Gotify';

  @override
  String get gotifySettings => 'Ustawienia Gotify';

  @override
  String get gotifySettingsUpdated =>
      'Ustawienia Gotify pomyślnie zaktualizowane';

  @override
  String get activity => 'Aktywność';

  @override
  String get fromDate => 'od';

  @override
  String frequencyEvery(num amount, String unit) {
    return 'każdy $amount $unit';
  }

  @override
  String day(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dni',
      one: 'dzień',
    );
    return '$_temp0';
  }

  @override
  String week(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'tygodnie',
      one: 'tydzień',
    );
    return '$_temp0';
  }

  @override
  String month(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'miesiące',
      one: 'miesiąc',
    );
    return '$_temp0';
  }

  @override
  String year(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'lata',
      one: 'rok',
    );
    return '$_temp0';
  }
}
