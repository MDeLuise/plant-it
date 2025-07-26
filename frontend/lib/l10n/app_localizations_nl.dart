// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get enterValue => 'Voer een waarde in';

  @override
  String get enterValidURL => 'Voer een geldige URL in';

  @override
  String get go => 'Doorgaan';

  @override
  String get noBackend => 'Kan geen verbinding maken met de server';

  @override
  String get ok => 'Ok';

  @override
  String get serverURL => 'Server-URL';

  @override
  String get username => 'Gebruikersnaam';

  @override
  String get password => 'Wachtwoord';

  @override
  String get login => 'Inloggen';

  @override
  String get badCredentials => 'Ongeldige inloggegevens';

  @override
  String get loginMessage => 'Welkom terug op';

  @override
  String get signupMessage => 'Welkom bij';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Wachtwoord vergeten?';

  @override
  String get areYouNew => 'Bent u nieuw?';

  @override
  String get createAccount => 'Account aanmaken';

  @override
  String get email => 'E-mail';

  @override
  String get usernameSize =>
      'De lengte van de gebruikersnaam moet tussen 3 en 20 tekens zijn';

  @override
  String get passwordSize =>
      'De lengte van het wachtwoord moet tussen 6 en 20 tekens zijn';

  @override
  String get enterValidEmail => 'Voer een geldig e-mailadres in';

  @override
  String get alreadyRegistered => 'Al geregistreerd?';

  @override
  String get signup => 'Registreren';

  @override
  String get generalError => 'Fout bij het uitvoeren van de bewerking';

  @override
  String get error => 'Fout';

  @override
  String get details => 'Details';

  @override
  String get insertBackendURL =>
      'Hallo vriend! Laten we magie laten gebeuren, begin met het instellen van je server-URL.';

  @override
  String get loginTagline => 'Verken, leer en kweek!';

  @override
  String get singupTagline => 'Laten we samen groeien!';

  @override
  String get sentOTPCode => 'Voer de code in die is verzonden naar: ';

  @override
  String get verify => 'Verifiëren';

  @override
  String get resendCode => 'Code opnieuw verzenden';

  @override
  String get otpCode => 'OTP-code';

  @override
  String get splashLoading => 'Beep boop beep... Gegevens laden van de server!';

  @override
  String get welcomeBack => 'Welkom terug';

  @override
  String hello(String userName) {
    return 'Hallo, $userName';
  }

  @override
  String get search => 'Zoeken';

  @override
  String get today => 'vandaag';

  @override
  String get yesterday => 'gisteren';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dagen',
      one: 'dag',
    );
    return '$countString $_temp0 geleden';
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
      other: 'dagen',
      one: 'dag',
    );
    return '$countString $_temp0 in de toekomst (wat?)';
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
      other: 'maanden',
      one: 'maand',
    );
    return '$countString $_temp0 geleden';
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
      other: 'jaren',
      one: 'jaar',
    );
    return '$countString $_temp0 geleden';
  }

  @override
  String get events => 'Gebeurtenissen';

  @override
  String get plants => 'Planten';

  @override
  String get or => 'of';

  @override
  String get filter => 'Filter';

  @override
  String get seeding => 'zaaien';

  @override
  String get watering => 'water geven';

  @override
  String get fertilizing => 'bemesten';

  @override
  String get biostimulating => 'biostimuleren';

  @override
  String get misting => 'nevelen';

  @override
  String get transplanting => 'verplanten';

  @override
  String get water_changing => 'water verversen';

  @override
  String get observation => 'observatie';

  @override
  String get treatment => 'behandeling';

  @override
  String get propagating => 'vermeerderen';

  @override
  String get pruning => 'snoeien';

  @override
  String get repotting => 'verpotten';

  @override
  String get recents => 'Recent';

  @override
  String get addNewEvent => 'Nieuwe gebeurtenis toevoegen';

  @override
  String get selectDate => 'Selecteer datum';

  @override
  String get selectEvents => 'Selecteer gebeurtenissen';

  @override
  String get selectPlants => 'Selecteer planten';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'gebeurtenissen',
      one: 'gebeurtenis',
    );
    return '$countString nieuwe $_temp0 aangemaakt';
  }

  @override
  String get addNote => 'Notitie toevoegen';

  @override
  String get enterNote => 'Voer notitie in';

  @override
  String get selectAtLeastOnePlant => 'Selecteer minstens één plant';

  @override
  String get selectAtLeastOneEvent => 'Selecteer minstens één gebeurtenis';

  @override
  String get eventSuccessfullyUpdated => 'Gebeurtenis succesvol bijgewerkt';

  @override
  String get editEvent => 'Gebeurtenis bewerken';

  @override
  String get eventSuccessfullyDeleted => 'Gebeurtenis succesvol verwijderd';

  @override
  String get noInfoAvailable => 'Geen informatie beschikbaar';

  @override
  String get species => 'Soort';

  @override
  String get plant => 'Plant';

  @override
  String get scientificClassification => 'Wetenschappelijke classificatie';

  @override
  String get family => 'Familie';

  @override
  String get genus => 'Geslacht';

  @override
  String get synonyms => 'Synoniemen';

  @override
  String get care => 'Verzorging';

  @override
  String get light => 'Licht';

  @override
  String get humidity => 'Vochtigheid';

  @override
  String get maxTemp => 'Maximale temperatuur';

  @override
  String get minTemp => 'Minimale temperatuur';

  @override
  String get minPh => 'Minimale pH';

  @override
  String get maxPh => 'Maximale pH';

  @override
  String get info => 'Informatie';

  @override
  String get addPhotos => 'Foto\'s toevoegen';

  @override
  String get addEvents => 'Gebeurtenissen toevoegen';

  @override
  String get modifyPlant => 'Plant wijzigen';

  @override
  String get removePlant => 'Plant verwijderen';

  @override
  String get useBirthday => 'Gebruik geboortedatum';

  @override
  String get birthday => 'Geboortedatum';

  @override
  String get avatar => 'Avatar';

  @override
  String get note => 'Notitie';

  @override
  String get stats => 'Statistieken';

  @override
  String get eventStats => 'Gebeurtenisstatistieken';

  @override
  String get age => 'Leeftijd';

  @override
  String get newBorn => 'Pasgeboren';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dagen',
      one: 'dag',
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
      other: 'maanden',
      one: 'maand',
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
      other: 'jaren',
      one: 'jaar',
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
      other: 'maanden',
      one: 'maand',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dagen',
      one: 'dag',
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
      other: 'jaren',
      one: 'jaar',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dagen',
      one: 'dag',
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
      other: 'jaren',
      one: 'jaar',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'maanden',
      one: 'maand',
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
      other: 'jaren',
      one: 'jaar',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'maanden',
      one: 'maand',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dagen',
      one: 'dag',
    );
    return '$yearsString $_temp0, $monthsString $_temp1, $daysString $_temp2';
  }

  @override
  String get name => 'Naam';

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

    return '$valueString van de $maxString';
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
  String get numberOfPhotos => 'Aantal foto\'s';

  @override
  String get numberOfEvents => 'Aantal gebeurtenissen';

  @override
  String get searchInYourPlants => 'Zoek in je planten';

  @override
  String get searchNewGreenFriends => 'Zoek nieuwe groene vrienden';

  @override
  String get custom => 'Aangepast';

  @override
  String get addPlant => 'Plant toevoegen';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nee';

  @override
  String get pleaseConfirm => 'Bevestig alstublieft';

  @override
  String get areYouSureToRemoveEvent =>
      'Weet je zeker dat je de gebeurtenis wilt verwijderen?';

  @override
  String get areYouSureToRemoveReminder =>
      'Weet je zeker dat je de herinnering wilt verwijderen?';

  @override
  String get areYouSureToRemoveSpecies =>
      'Weet je zeker dat je de soort wilt verwijderen?';

  @override
  String get areYouSureToRemovePlant =>
      'Weet je zeker dat je de plant wilt verwijderen?';

  @override
  String get purchasedPrice => 'Aankoopprijs';

  @override
  String get seller => 'Verkoper';

  @override
  String get location => 'Locatie';

  @override
  String get currency => 'Valuta';

  @override
  String get plantUpdatedSuccessfully => 'Plant succesvol bijgewerkt';

  @override
  String get plantCreatedSuccessfully => 'Plant succesvol aangemaakt';

  @override
  String get insertPrice => 'Prijs invoeren';

  @override
  String get noBirthday => 'Geen geboortedatum';

  @override
  String get appVersion => 'App-versie';

  @override
  String get serverVersion => 'Server-versie';

  @override
  String get documentation => 'Documentatie';

  @override
  String get openSource => 'Open source';

  @override
  String get reportIssue => 'Probleem melden';

  @override
  String get logout => 'Uitloggen';

  @override
  String get eventCount => 'Aantal gebeurtenissen';

  @override
  String get plantCount => 'Aantal planten';

  @override
  String get speciesCount => 'Aantal soorten';

  @override
  String get imageCount => 'Aantal afbeeldingen';

  @override
  String get unknown => 'Onbekend';

  @override
  String get account => 'Account';

  @override
  String get changePassword => 'Wachtwoord wijzigen';

  @override
  String get more => 'Meer';

  @override
  String get editProfile => 'Profiel bewerken';

  @override
  String get currentPassword => 'Huidig wachtwoord';

  @override
  String get updatePassword => 'Wachtwoord bijwerken';

  @override
  String get updateProfile => 'Profiel bijwerken';

  @override
  String get newPassword => 'Nieuw wachtwoord';

  @override
  String get removeEvent => 'Gebeurtenis verwijderen';

  @override
  String get appLog => 'App-logboek';

  @override
  String get passwordUpdated => 'Wachtwoord succesvol bijgewerkt';

  @override
  String get userUpdated => 'Gebruiker succesvol bijgewerkt';

  @override
  String get noChangesDetected => 'Geen wijzigingen gedetecteerd';

  @override
  String get plantDeletedSuccessfully => 'Plant succesvol verwijderd';

  @override
  String get server => 'Server';

  @override
  String get notifications => 'Meldingen';

  @override
  String get changeServer => 'Server wijzigen';

  @override
  String get serverUpdated => 'Server succesvol bijgewerkt';

  @override
  String get changeNotifications => 'Meldingen wijzigen';

  @override
  String get updateNotifications => 'Meldingen bijwerken';

  @override
  String get notificationUpdated => 'Melding succesvol bijgewerkt';

  @override
  String get supportTheProject => 'Ondersteun het project';

  @override
  String get buyMeACoffee => 'Koop een koffie voor mij';

  @override
  String get gallery => 'Galerij';

  @override
  String photosOf(String name) {
    return 'Foto\'s van $name';
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
      other: 'foto\'s',
      one: 'foto',
    );
    return '$countString nieuwe $_temp0 geüpload';
  }

  @override
  String get errorCreatingPlant => 'Fout bij het aanmaken van de plant';

  @override
  String get noImages => 'Geen afbeeldingen';

  @override
  String get errorCreatingSpecies => 'Fout bij het aanmaken van de soort';

  @override
  String get errorUpdatingSpecies => 'Fout bij het bijwerken van de soort';

  @override
  String get speciesUpdatedSuccessfully => 'Soort succesvol bijgewerkt';

  @override
  String get addCustom => 'Aangepaste toevoegen';

  @override
  String get speciesCreatedSuccessfully => 'Soort succesvol aangemaakt';

  @override
  String get uploadPhoto => 'Foto uploaden';

  @override
  String get linkURL => 'Link-URL';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Bevestigen';

  @override
  String get cancel => 'Annuleren';

  @override
  String get actions => 'Acties';

  @override
  String get areYouSureToRemovePhoto =>
      'Weet je zeker dat je de foto wilt verwijderen?';

  @override
  String get photoSuccessfullyDeleted => 'Foto succesvol verwijderd';

  @override
  String get errorUpdatingPlant => 'Fout bij het bijwerken van de plant';

  @override
  String get reminders => 'Herinneringen';

  @override
  String get selectStartDate => 'Selecteer startdatum';

  @override
  String get selectEndDate => 'Selecteer einddatum';

  @override
  String get addNewReminder => 'Nieuwe herinnering toevoegen';

  @override
  String get noEndDate => 'Geen einddatum';

  @override
  String get frequency => 'Frequentie';

  @override
  String get repeatAfter => 'Herhalen na';

  @override
  String get addNew => 'Nieuwe toevoegen';

  @override
  String get reminderCreatedSuccessfully => 'Herinnering succesvol aangemaakt';

  @override
  String get startAndEndDateOrderError =>
      'Startdatum moet voor de einddatum liggen';

  @override
  String get reminderUpdatedSuccessfully => 'Herinnering succesvol bijgewerkt';

  @override
  String get reminderDeletedSuccessfully => 'Herinnering succesvol verwijderd';

  @override
  String get errorResettingPassword =>
      'Fout bij het resetten van het wachtwoord';

  @override
  String get resetPassword => 'Wachtwoord resetten';

  @override
  String get resetPasswordHeader =>
      'Voer hieronder de gebruikersnaam in om een reset-wachtwoordverzoek te verzenden';

  @override
  String get editReminder => 'Herinnering bewerken';

  @override
  String get ntfyServerUrl => 'Ntfy server-URL';

  @override
  String get ntfyServerTopic => 'Ntfy server-onderwerp';

  @override
  String get ntfyServerUsername => 'Ntfy server-gebruikersnaam';

  @override
  String get ntfyServerPassword => 'Ntfy server-wachtwoord';

  @override
  String get ntfyServerToken => 'Ntfy server-token';

  @override
  String get enterValidTopic => 'Voer een geldig onderwerp in';

  @override
  String get ntfySettings => 'Ntfy-instellingen';

  @override
  String get ntfySettingsUpdated => 'Ntfy-instellingen correct bijgewerkt';

  @override
  String get modifySpecies => 'Soort wijzigen';

  @override
  String get removeSpecies => 'Soort verwijderen';

  @override
  String get speciesDeletedSuccessfully => 'Soort succesvol verwijderd';

  @override
  String get success => 'Succes';

  @override
  String get warning => 'Waarschuwing';

  @override
  String get ops => 'Oeps!';

  @override
  String get changeLanguage => 'Taal wijzigen';

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
