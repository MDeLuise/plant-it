// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get enterValue => 'Bitte einen Wert eingeben';

  @override
  String get enterValidURL => 'Bitte eine gültige URL eingeben';

  @override
  String get go => 'Weiter';

  @override
  String get noBackend => 'Keine Verbindung zum Server möglich';

  @override
  String get ok => 'OK';

  @override
  String get serverURL => 'Server-URL';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get login => 'Anmelden';

  @override
  String get badCredentials => 'Ungültige Anmeldedaten';

  @override
  String get loginMessage => 'Willkommen zurück bei';

  @override
  String get signupMessage => 'Willkommen bei';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get areYouNew => 'Neu hier?';

  @override
  String get createAccount => 'Konto erstellen';

  @override
  String get email => 'E-Mail';

  @override
  String get usernameSize =>
      'Der Benutzername muss zwischen 3 und 20 Zeichen lang sein';

  @override
  String get passwordSize =>
      'Das Passwort muss zwischen 6 und 20 Zeichen lang sein';

  @override
  String get enterValidEmail => 'Bitte eine gültige E-Mail-Adresse eingeben';

  @override
  String get alreadyRegistered => 'Bereits registriert?';

  @override
  String get signup => 'Registrieren';

  @override
  String get generalError => 'Fehler bei der Durchführung der Operation';

  @override
  String get error => 'Fehler';

  @override
  String get details => 'Details';

  @override
  String get insertBackendURL =>
      'Hallo Freund! Lass uns Magie geschehen lassen, beginne mit der Konfiguration der URL deines Servers.';

  @override
  String get loginTagline => 'Entdecken, lernen und wachsen!';

  @override
  String get singupTagline => 'Lass uns gemeinsam wachsen!';

  @override
  String get sentOTPCode =>
      'Bitte den Code eingeben, der an die E-Mail-Adresse gesendet wurde:';

  @override
  String get verify => 'Verifizieren';

  @override
  String get resendCode => 'Code erneut senden';

  @override
  String get otpCode => 'OTP-Code';

  @override
  String get splashLoading => 'Beep boop beep... Laden von Serverdaten!';

  @override
  String get welcomeBack => 'Willkommen zurück';

  @override
  String hello(String userName) {
    return 'Hallo, $userName';
  }

  @override
  String get search => 'Suchen';

  @override
  String get today => 'heute';

  @override
  String get yesterday => 'gestern';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tagen',
      one: 'Tag',
    );
    return 'vor $countString $_temp0';
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
      other: 'Tage',
      one: 'Tag',
    );
    return '$countString $_temp0 in der Zukunft (was?)';
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
      other: 'Monaten',
      one: 'Monat',
    );
    return 'vor $countString $_temp0';
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
      other: 'Jahren',
      one: 'Jahr',
    );
    return 'vor $countString $_temp0';
  }

  @override
  String get events => 'Ereignisse';

  @override
  String get plants => 'Pflanzen';

  @override
  String get or => 'oder';

  @override
  String get filter => 'Filtern';

  @override
  String get seeding => 'gesät';

  @override
  String get watering => 'gegossen';

  @override
  String get fertilizing => 'gedüngt';

  @override
  String get biostimulating => 'biostimuliert';

  @override
  String get misting => 'besprüht';

  @override
  String get transplanting => 'umgepflanzt';

  @override
  String get water_changing => 'Wasser gewechselt';

  @override
  String get observation => 'Beobachtung';

  @override
  String get treatment => 'Behandlung';

  @override
  String get propagating => 'vermehrt';

  @override
  String get pruning => 'geschnitten';

  @override
  String get repotting => 'umgetopft';

  @override
  String get recents => 'Aktuelles';

  @override
  String get addNewEvent => 'Neues Ereignis hinzufügen';

  @override
  String get selectDate => 'Datum auswählen';

  @override
  String get selectEvents => 'Ereignisse auswählen';

  @override
  String get selectPlants => 'Pflanzen auswählen';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ereignisse',
      one: 'Ereignis',
    );
    return '$countString neues $_temp0 erstellt';
  }

  @override
  String get addNote => 'Notiz hinzufügen';

  @override
  String get enterNote => 'Notiz eingeben';

  @override
  String get selectAtLeastOnePlant => 'Wähle mindestens eine Pflanze aus';

  @override
  String get selectAtLeastOneEvent => 'Wähle mindestens ein Ereignis aus';

  @override
  String get eventSuccessfullyUpdated => 'Ereignis erfolgreich aktualisiert';

  @override
  String get editEvent => 'Ereignis bearbeiten';

  @override
  String get eventSuccessfullyDeleted => 'Ereignis erfolgreich gelöscht';

  @override
  String get noInfoAvailable => 'Keine Informationen verfügbar';

  @override
  String get species => 'Art';

  @override
  String get plant => 'Pflanze';

  @override
  String get scientificClassification => 'Wissenschaftliche Klassifikation';

  @override
  String get family => 'Familie';

  @override
  String get genus => 'Gattung';

  @override
  String get synonyms => 'Synonyme';

  @override
  String get care => 'Pflege';

  @override
  String get light => 'Licht';

  @override
  String get humidity => 'Feuchtigkeit';

  @override
  String get maxTemp => 'Maximale Temperatur';

  @override
  String get minTemp => 'Minimale Temperatur';

  @override
  String get minPh => 'Minimaler pH-Wert';

  @override
  String get maxPh => 'Maximaler pH-Wert';

  @override
  String get info => 'Informationen';

  @override
  String get addPhotos => 'Fotos hinzufügen';

  @override
  String get addEvents => 'Ereignisse hinzufügen';

  @override
  String get modifyPlant => 'Pflanze bearbeiten';

  @override
  String get removePlant => 'Pflanze entfernen';

  @override
  String get useBirthday => 'Geburtsdatum verwenden';

  @override
  String get birthday => 'Anzuchtdatum';

  @override
  String get avatar => 'Avatar';

  @override
  String get note => 'Notiz';

  @override
  String get stats => 'Statistiken';

  @override
  String get eventStats => 'Ereignisstatistiken';

  @override
  String get age => 'Alter';

  @override
  String get newBorn => 'Neugeboren';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
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
      other: 'Monate',
      one: 'Monat',
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
      other: 'Jahre',
      one: 'Jahr',
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
      other: 'Monate',
      one: 'Monat',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
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
      other: 'Jahre',
      one: 'Jahr',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
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
      other: 'Jahre',
      one: 'Jahr',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Monate',
      one: 'Monat',
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
      other: 'Jahre',
      one: 'Jahr',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'Monate',
      one: 'Monat',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
    );
    return '$yearsString $_temp0, $monthsString $_temp1, $daysString $_temp2';
  }

  @override
  String get name => 'Name';

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

    return '$valueString von $maxString';
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
  String get numberOfPhotos => 'Anzahl der Fotos';

  @override
  String get numberOfEvents => 'Anzahl der Ereignisse';

  @override
  String get searchInYourPlants => 'In deinen Pflanzen suchen';

  @override
  String get searchNewGreenFriends => 'Neue grüne Freunde suchen';

  @override
  String get custom => 'Benutzerdefiniert';

  @override
  String get addPlant => 'Pflanze hinzufügen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get pleaseConfirm => 'Bitte bestätigen';

  @override
  String get areYouSureToRemoveEvent =>
      'Bist du sicher, dass du das Ereignis entfernen möchten?';

  @override
  String get areYouSureToRemoveReminder =>
      'Bist du sicher, dass du die Erinnerung entfernen möchten?';

  @override
  String get areYouSureToRemoveSpecies =>
      'Bist du sicher, dass du die Art entfernen möchten?';

  @override
  String get areYouSureToRemovePlant =>
      'Bist du sicher, dass du die Pflanze entfernen möchten?';

  @override
  String get purchasedPrice => 'Kaufpreis';

  @override
  String get seller => 'Verkäufer';

  @override
  String get location => 'Ort';

  @override
  String get currency => 'Währung';

  @override
  String get plantUpdatedSuccessfully => 'Pflanze erfolgreich aktualisiert';

  @override
  String get plantCreatedSuccessfully => 'Pflanze erfolgreich erstellt';

  @override
  String get insertPrice => 'Preis eingeben';

  @override
  String get noBirthday => 'Kein Anzuchtdatum';

  @override
  String get appVersion => 'App-Version';

  @override
  String get serverVersion => 'Server-Version';

  @override
  String get documentation => 'Dokumentation';

  @override
  String get openSource => 'Open Source';

  @override
  String get reportIssue => 'Problem melden';

  @override
  String get logout => 'Abmelden';

  @override
  String get eventCount => 'Ereigniszähler';

  @override
  String get plantCount => 'Pflanzenzähler';

  @override
  String get speciesCount => 'Artenzähler';

  @override
  String get imageCount => 'Bildzähler';

  @override
  String get unknown => 'Unbekannt';

  @override
  String get account => 'Konto';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get more => 'Mehr';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get currentPassword => 'Aktuelles Passwort';

  @override
  String get updatePassword => 'Passwort aktualisieren';

  @override
  String get updateProfile => 'Profil aktualisieren';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get removeEvent => 'Ereignis entfernen';

  @override
  String get appLog => 'App-Log';

  @override
  String get passwordUpdated => 'Passwort erfolgreich aktualisiert';

  @override
  String get userUpdated => 'Benutzer erfolgreich aktualisiert';

  @override
  String get noChangesDetected => 'Keine Änderungen festgestellt';

  @override
  String get plantDeletedSuccessfully => 'Pflanze erfolgreich gelöscht';

  @override
  String get server => 'Server';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get changeServer => 'Server ändern';

  @override
  String get serverUpdated => 'Server erfolgreich aktualisiert';

  @override
  String get changeNotifications => 'Benachrichtigungen ändern';

  @override
  String get updateNotifications => 'Benachrichtigungen aktualisieren';

  @override
  String get notificationUpdated => 'Benachrichtigung erfolgreich aktualisiert';

  @override
  String get supportTheProject => 'Unterstütze das Projekt';

  @override
  String get buyMeACoffee => 'Kaufen Sie mir einen Kaffee';

  @override
  String get gallery => 'Galerie';

  @override
  String photosOf(String name) {
    return 'Fotos von $name';
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
      other: 'neue Fotos',
      one: 'neues Foto',
    );
    return '$countString $_temp0 hochgeladen';
  }

  @override
  String get errorCreatingPlant => 'Fehler beim Erstellen der Pflanze';

  @override
  String get noImages => 'Keine Bilder';

  @override
  String get errorCreatingSpecies => 'Fehler beim Erstellen der Art';

  @override
  String get errorUpdatingSpecies => 'Fehler beim Aktualisieren der Art';

  @override
  String get speciesUpdatedSuccessfully => 'Art erfolgreich aktualisiert';

  @override
  String get addCustom => 'Benutzerdefiniert hinzufügen';

  @override
  String get speciesCreatedSuccessfully => 'Art erfolgreich erstellt';

  @override
  String get uploadPhoto => 'Foto hochladen';

  @override
  String get linkURL => 'URL-Link';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Bestätigen';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get actions => 'Aktionen';

  @override
  String get areYouSureToRemovePhoto =>
      'Bist du sicher, dass du das Foto entfernen möchten?';

  @override
  String get photoSuccessfullyDeleted => 'Foto erfolgreich gelöscht';

  @override
  String get errorUpdatingPlant => 'Fehler beim Aktualisieren der Pflanze';

  @override
  String get reminders => 'Erinnerungen';

  @override
  String get selectStartDate => 'Startdatum auswählen';

  @override
  String get selectEndDate => 'Enddatum auswählen';

  @override
  String get addNewReminder => 'Neue Erinnerung hinzufügen';

  @override
  String get noEndDate => 'Kein Enddatum';

  @override
  String get frequency => 'Häufigkeit';

  @override
  String get repeatAfter => 'Wiederholen nach';

  @override
  String get addNew => 'Neu hinzufügen';

  @override
  String get reminderCreatedSuccessfully => 'Erinnerung erfolgreich erstellt';

  @override
  String get startAndEndDateOrderError =>
      'Das Startdatum muss vor dem Enddatum liegen';

  @override
  String get reminderUpdatedSuccessfully =>
      'Erinnerung erfolgreich aktualisiert';

  @override
  String get reminderDeletedSuccessfully => 'Erinnerung erfolgreich gelöscht';

  @override
  String get errorResettingPassword => 'Fehler beim Zurücksetzen des Passworts';

  @override
  String get resetPassword => 'Passwort zurücksetzen';

  @override
  String get resetPasswordHeader =>
      'Gib unten den Benutzernamen ein, um eine Passwort-Zurücksetzanforderung zu senden';

  @override
  String get editReminder => 'Erinnerung bearbeiten';

  @override
  String get ntfyServerUrl => 'Ntfy Server URL';

  @override
  String get ntfyServerTopic => 'Ntfy Server Thema';

  @override
  String get ntfyServerUsername => 'Ntfy Server Benutzername';

  @override
  String get ntfyServerPassword => 'Ntfy Server Passwort';

  @override
  String get ntfyServerToken => 'Ntfy Server Token';

  @override
  String get enterValidTopic => 'Bitte ein gültiges Thema eingeben';

  @override
  String get ntfySettings => 'Ntfy Einstellungen';

  @override
  String get ntfySettingsUpdated =>
      'Ntfy Einstellungen erfolgreich aktualisiert';

  @override
  String get modifySpecies => 'Art bearbeiten';

  @override
  String get removeSpecies => 'Art löschen';

  @override
  String get speciesDeletedSuccessfully => 'Art erfolgreich gelöscht';

  @override
  String get success => 'Erfolg';

  @override
  String get warning => 'Warnung';

  @override
  String get ops => 'Hoppla!';

  @override
  String get changeLanguage => 'Sprache ändern';

  @override
  String get gotifyServerUrl => 'Gotify Server URL';

  @override
  String get gotifyServerToken => 'Gotify Server Token';

  @override
  String get gotifySettings => 'Gotify Einstellungen';

  @override
  String get gotifySettingsUpdated =>
      'Gotify Einstellungen korrekt aktualisiert';

  @override
  String get activity => 'Aktivität';

  @override
  String get fromDate => 'seit';

  @override
  String frequencyEvery(num amount, String unit) {
    return 'alle $amount $unit';
  }

  @override
  String day(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
    );
    return '$_temp0';
  }

  @override
  String week(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wochen',
      one: 'Woche',
    );
    return '$_temp0';
  }

  @override
  String month(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Monate',
      one: 'Monat',
    );
    return '$_temp0';
  }

  @override
  String year(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jahre',
      one: 'Jahr',
    );
    return '$_temp0';
  }
}
