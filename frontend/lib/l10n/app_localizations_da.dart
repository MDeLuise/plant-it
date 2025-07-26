// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get enterValue => 'Indtast venligst en værdi';

  @override
  String get enterValidURL => 'Indtast venligst en gyldig URL';

  @override
  String get go => 'Fortsæt';

  @override
  String get noBackend => 'Kan ikke forbinde til serveren';

  @override
  String get ok => 'Ok';

  @override
  String get serverURL => 'Server URL';

  @override
  String get username => 'Brugernavn';

  @override
  String get password => 'Kodeord';

  @override
  String get login => 'Log ind';

  @override
  String get badCredentials => 'Dårlige konto-oplysninger';

  @override
  String get loginMessage => 'Velkommen tilbage på';

  @override
  String get signupMessage => 'Velkommen på';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Glemt kodeord?';

  @override
  String get areYouNew => 'Er du ny?';

  @override
  String get createAccount => 'Opret en konto';

  @override
  String get email => 'Email';

  @override
  String get usernameSize =>
      'Brugernavn længde skal være mellem 3 og 20 karaktere';

  @override
  String get passwordSize => 'Kodeord længe skal være mellem 6 og 20 karaktere';

  @override
  String get enterValidEmail => 'Indtast venligst en gyldig email';

  @override
  String get alreadyRegistered => 'Allerede registreret?';

  @override
  String get signup => 'Tilmeld';

  @override
  String get generalError => 'Fejl ved udførsel af handlingen';

  @override
  String get error => 'Fejl';

  @override
  String get details => 'Detaljer';

  @override
  String get insertBackendURL =>
      'Hej ven! Lad os skabe magi, start ved at sætte din server URL op.';

  @override
  String get loginTagline => 'Udforsk, lær og dyrk!';

  @override
  String get singupTagline => 'Lad os vokse, sammen!';

  @override
  String get sentOTPCode =>
      'Indsæt venligst koden der blev sendt til emailen: ';

  @override
  String get verify => 'Verificer';

  @override
  String get resendCode => 'Send kode igen';

  @override
  String get otpCode => 'OTP kode';

  @override
  String get splashLoading => 'Beep boop beep... Indlæser data fra serveren!';

  @override
  String get welcomeBack => 'Velkommen tilbage';

  @override
  String hello(String userName) {
    return 'Halløj, $userName';
  }

  @override
  String get search => 'Søg';

  @override
  String get today => 'i dag';

  @override
  String get yesterday => 'i går';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dage',
      one: 'dag',
    );
    return '$countString $_temp0 siden';
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
      other: 'dage',
      one: 'dag',
    );
    return '$countString $_temp0 in fremtiden (vent hvad?)';
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
      other: 'måneder',
      one: 'måned',
    );
    return '$countString $_temp0 siden';
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
      other: 'år',
      one: 'år',
    );
    return '$countString $_temp0 siden';
  }

  @override
  String get events => 'Begivenheder';

  @override
  String get plants => 'Planter';

  @override
  String get or => 'eller';

  @override
  String get filter => 'Filter';

  @override
  String get seeding => 'såning';

  @override
  String get watering => 'vander';

  @override
  String get fertilizing => 'gøder';

  @override
  String get biostimulating => 'bio-stimulerer';

  @override
  String get misting => 'forstøver';

  @override
  String get transplanting => 'transplanterer';

  @override
  String get water_changing => 'skifter vand';

  @override
  String get observation => 'observation';

  @override
  String get treatment => 'behandling';

  @override
  String get propagating => 'formerer';

  @override
  String get pruning => 'beskærer';

  @override
  String get repotting => 'repotter';

  @override
  String get recents => 'Nylige';

  @override
  String get addNewEvent => 'Tilføj ny begivenhed';

  @override
  String get selectDate => 'Vælg dato';

  @override
  String get selectEvents => 'Vælg begivenheder';

  @override
  String get selectPlants => 'Vælg planter';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'begivenheder',
      one: 'begivenhed',
    );
    return 'Oprettede $countString nye $_temp0';
  }

  @override
  String get addNote => 'Tilføj note';

  @override
  String get enterNote => 'Indtast note';

  @override
  String get selectAtLeastOnePlant => 'Vælg mindst en plante';

  @override
  String get selectAtLeastOneEvent => 'Vælg mindst en begivenhed';

  @override
  String get eventSuccessfullyUpdated => 'Begivenhed opdateret succesfuldt';

  @override
  String get editEvent => 'Rediger begivenhed';

  @override
  String get eventSuccessfullyDeleted => 'Begivenhed slettet succesfuldt';

  @override
  String get noInfoAvailable => 'Ingen information tilgængelig';

  @override
  String get species => 'Species';

  @override
  String get plant => 'Plante';

  @override
  String get scientificClassification => 'Videnskabelig klassifikation';

  @override
  String get family => 'Familie';

  @override
  String get genus => 'Slægt';

  @override
  String get synonyms => 'Synonymer';

  @override
  String get care => 'Pasning';

  @override
  String get light => 'Lys';

  @override
  String get humidity => 'Fugtighed';

  @override
  String get maxTemp => 'Maksimal temperatur';

  @override
  String get minTemp => 'Minimum temperatur';

  @override
  String get minPh => 'Minimum ph';

  @override
  String get maxPh => 'Maksimal ph';

  @override
  String get info => 'Information';

  @override
  String get addPhotos => 'Tilføj billeder';

  @override
  String get addEvents => 'Tilføj begivenheder';

  @override
  String get modifyPlant => 'Modificer plante';

  @override
  String get removePlant => 'Fjern plante';

  @override
  String get useBirthday => 'Brug fødselsdag';

  @override
  String get birthday => 'Fødselsdag';

  @override
  String get avatar => 'Avatar';

  @override
  String get note => 'Note';

  @override
  String get stats => 'Statistikker';

  @override
  String get eventStats => 'Begivenheds statistikker';

  @override
  String get age => 'Alder';

  @override
  String get newBorn => 'Nyfødt';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dage',
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
      other: 'måneder',
      one: 'måned',
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
      other: 'år',
      one: 'år',
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
      other: 'måneder',
      one: 'måned',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dage',
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
      other: 'år',
      one: 'år',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dage',
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
      other: 'år',
      one: 'år',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'måneder',
      one: 'måned',
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
      other: 'år',
      one: 'år',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'måneder',
      one: 'måned',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dage',
      one: 'dag',
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

    return '$valueString ud af $maxString';
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
  String get numberOfPhotos => 'Antal billeder';

  @override
  String get numberOfEvents => 'Antal begivenheder';

  @override
  String get searchInYourPlants => 'Søg i dine planter';

  @override
  String get searchNewGreenFriends => 'Søg nye grønne venner';

  @override
  String get custom => 'Tilpasset';

  @override
  String get addPlant => 'Tilføj Plante';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nej';

  @override
  String get pleaseConfirm => 'Bekræft venligst';

  @override
  String get areYouSureToRemoveEvent =>
      'Er du sikker på du vil fjerne begivenheden?';

  @override
  String get areYouSureToRemoveReminder =>
      'Er du sikker på du vil fjerne påmindelsen?';

  @override
  String get areYouSureToRemoveSpecies =>
      'Er du sikker på du vil fjerne arten?';

  @override
  String get areYouSureToRemovePlant =>
      'Er du sikker på du vil fjerne planten?';

  @override
  String get purchasedPrice => 'Købspris';

  @override
  String get seller => 'Sælger';

  @override
  String get location => 'Lokation';

  @override
  String get currency => 'Valuta';

  @override
  String get plantUpdatedSuccessfully => 'Plante opdateret succesfuldt';

  @override
  String get plantCreatedSuccessfully => 'Plante oprettet succesfuldt';

  @override
  String get insertPrice => 'Indsæt pris';

  @override
  String get noBirthday => 'Ingen fødselsdag';

  @override
  String get appVersion => 'App version';

  @override
  String get serverVersion => 'Server version';

  @override
  String get documentation => 'Dokumentation';

  @override
  String get openSource => 'Åben kilde';

  @override
  String get reportIssue => 'Anmeld fejl';

  @override
  String get logout => 'Log ud';

  @override
  String get eventCount => 'Begivenhed optælling';

  @override
  String get plantCount => 'Plante optælling';

  @override
  String get speciesCount => 'Art optælling';

  @override
  String get imageCount => 'Billede optælling';

  @override
  String get unknown => 'Ukendt';

  @override
  String get account => 'Konto';

  @override
  String get changePassword => 'Skift kodeord';

  @override
  String get more => 'Mere';

  @override
  String get editProfile => 'Rediger profil';

  @override
  String get currentPassword => 'Nuværende kodeord';

  @override
  String get updatePassword => 'Opdater kodeord';

  @override
  String get updateProfile => 'Opdater profil';

  @override
  String get newPassword => 'Nyt kodeord';

  @override
  String get removeEvent => 'Fjern begivenhed';

  @override
  String get appLog => 'App log';

  @override
  String get passwordUpdated => 'Kodeord succesfuldt opdateret';

  @override
  String get userUpdated => 'Bruger succesfuldt opdateret';

  @override
  String get noChangesDetected => 'Ingen ændringer registreret';

  @override
  String get plantDeletedSuccessfully => 'Plante succesfuldt slettet';

  @override
  String get server => 'Server';

  @override
  String get notifications => 'Notifikationer';

  @override
  String get changeServer => 'Skift server';

  @override
  String get serverUpdated => 'Server succesfuldt opdateret';

  @override
  String get changeNotifications => 'Skift notifikationer';

  @override
  String get updateNotifications => 'Opdater notifications';

  @override
  String get notificationUpdated => 'Notifikationer succesfuldt opdateret';

  @override
  String get supportTheProject => 'Støt projektet';

  @override
  String get buyMeACoffee => 'Køb mig en kaffe';

  @override
  String get gallery => 'Galleri';

  @override
  String photosOf(String name) {
    return 'Billeder af $name';
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
      other: 'billeder',
      one: 'billede',
    );
    return 'Uploadet $countString nye $_temp0';
  }

  @override
  String get errorCreatingPlant => 'Fejl ved oprettelse af plante';

  @override
  String get noImages => 'Ingen billeder';

  @override
  String get errorCreatingSpecies => 'Fejl ved oprettelse af art';

  @override
  String get errorUpdatingSpecies => 'Fejl ved opdatering af art';

  @override
  String get speciesUpdatedSuccessfully => 'Art succesfuldt opdateret';

  @override
  String get addCustom => 'Tilføj tilpasset';

  @override
  String get speciesCreatedSuccessfully => 'Art succesfuldt oprettet';

  @override
  String get uploadPhoto => 'Upload Billede';

  @override
  String get linkURL => 'Link URL';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Bekræft';

  @override
  String get cancel => 'Annuller';

  @override
  String get actions => 'Handlinger';

  @override
  String get areYouSureToRemovePhoto =>
      'Er du sikker på du vil fjerne billedet?';

  @override
  String get photoSuccessfullyDeleted => 'Billede slettet succesfuldt';

  @override
  String get errorUpdatingPlant => 'Fejl ved at opdatere plante';

  @override
  String get reminders => 'Påmindelser';

  @override
  String get selectStartDate => 'Vælg start dato';

  @override
  String get selectEndDate => 'Vælg slut dato';

  @override
  String get addNewReminder => 'Tilføj ny påmindelse';

  @override
  String get noEndDate => 'Ingen slut dato';

  @override
  String get frequency => 'Hyppighed';

  @override
  String get repeatAfter => 'Gentag efter';

  @override
  String get addNew => 'Tilføj ny';

  @override
  String get reminderCreatedSuccessfully => 'Påmindelse succesfuldt oprettet';

  @override
  String get startAndEndDateOrderError => 'Start dato skal være før slut dato';

  @override
  String get reminderUpdatedSuccessfully => 'Påmindelse succesfuldt opdateret';

  @override
  String get reminderDeletedSuccessfully => 'Påmindelse succesfuldt slettet';

  @override
  String get errorResettingPassword => 'Fejl ved nulstilling af kodeord';

  @override
  String get resetPassword => 'Nulstil kodeord';

  @override
  String get resetPasswordHeader =>
      'Indsat brugernavn herunder, for at sende en \"nulstil kodeord\" forespørgsel';

  @override
  String get editReminder => 'Rediger påmindelse';

  @override
  String get ntfyServerUrl => 'Ntfy server URL';

  @override
  String get ntfyServerTopic => 'Ntfy server emne';

  @override
  String get ntfyServerUsername => 'Ntfy server brugernavn';

  @override
  String get ntfyServerPassword => 'Ntfy server kodeord';

  @override
  String get ntfyServerToken => 'Ntfy server token';

  @override
  String get enterValidTopic => 'Indtast venligst et gyldigt emne';

  @override
  String get ntfySettings => 'Ntfy indstillinger';

  @override
  String get ntfySettingsUpdated => 'Ntfy indstillinger korrekt opdateret';

  @override
  String get modifySpecies => 'Modificer art';

  @override
  String get removeSpecies => 'Slet art';

  @override
  String get speciesDeletedSuccessfully => 'Art succesfuldt slettet';

  @override
  String get success => 'Succes';

  @override
  String get warning => 'Advarsel';

  @override
  String get ops => 'Ups!';

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
