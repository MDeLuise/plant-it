// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get enterValue => 'Prosím zadejte hodnotu';

  @override
  String get enterValidURL => 'Prosím zadejte platnou URL';

  @override
  String get go => 'Pokračovat';

  @override
  String get noBackend => 'Nemožné připojit se na server';

  @override
  String get ok => 'Ok';

  @override
  String get serverURL => 'URL serveru';

  @override
  String get username => 'Uživatelské jméno';

  @override
  String get password => 'Heslo';

  @override
  String get login => 'Login';

  @override
  String get badCredentials => 'Špatné přihlašovací údaje';

  @override
  String get loginMessage => 'Vítejte zpět v';

  @override
  String get signupMessage => 'Vítejte v';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Zapomenté heslo?';

  @override
  String get areYouNew => 'Jste tu poprvé?';

  @override
  String get createAccount => 'Vytvořit účet';

  @override
  String get email => 'Email';

  @override
  String get usernameSize => 'Uživatelské jméno musí mít mezi 3 a 20 znaky';

  @override
  String get passwordSize => 'Heslo musí mít mezi 6 a 20 znaky';

  @override
  String get enterValidEmail => 'Prosím zadejte platný email';

  @override
  String get alreadyRegistered => 'Jste již registrováni?';

  @override
  String get signup => 'Registrace';

  @override
  String get generalError => 'Chyba při vykonávání operace';

  @override
  String get error => 'Chyba';

  @override
  String get details => 'Detaily';

  @override
  String get insertBackendURL =>
      'Ahoj kamaráde! Jdeme na to, zadej URL adresu svého serveru.';

  @override
  String get loginTagline => 'Objevuj, uč se a pěstuj!';

  @override
  String get singupTagline => 'Pojďme něco vypěstovat!';

  @override
  String get sentOTPCode => 'Prosím zadejte kód zaslaný na email: ';

  @override
  String get verify => 'Ověřit';

  @override
  String get resendCode => 'Poslad kód znovu';

  @override
  String get otpCode => 'Kód OTP';

  @override
  String get splashLoading => 'Píp píp píp... Načítání dat ze serveru!';

  @override
  String get welcomeBack => 'Vítejte zpět';

  @override
  String hello(String userName) {
    return 'Ahoj, $userName';
  }

  @override
  String get search => 'Hledat';

  @override
  String get today => 'dnes';

  @override
  String get yesterday => 'včera';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dny',
      one: 'den',
    );
    return '$countString $_temp0 zpět';
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
      other: 'dny',
      one: 'den',
    );
    return '$countString $_temp0 v budoucnosti (coooo?)';
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
      other: 'měsíců',
      one: 'měsíc',
    );
    return '$countString $_temp0 zpět';
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
      other: 'let',
      one: 'rok',
    );
    return '$countString $_temp0 zpět';
  }

  @override
  String get events => 'Události';

  @override
  String get plants => 'Květiny';

  @override
  String get or => 'nebo';

  @override
  String get filter => 'Filtr';

  @override
  String get seeding => 'zasazení';

  @override
  String get watering => 'zalévání';

  @override
  String get fertilizing => 'hnojení';

  @override
  String get biostimulating => 'biostimulace';

  @override
  String get misting => 'rosení';

  @override
  String get transplanting => 'přesazení na jiné místo';

  @override
  String get water_changing => 'měnění vody';

  @override
  String get observation => 'pozorování';

  @override
  String get treatment => 'péče';

  @override
  String get propagating => 'množení';

  @override
  String get pruning => 'prořez';

  @override
  String get repotting => 'přesazení do květináče';

  @override
  String get recents => 'Nedávné';

  @override
  String get addNewEvent => 'Přidat událost';

  @override
  String get selectDate => 'Zvolit datum';

  @override
  String get selectEvents => 'Zvolit události';

  @override
  String get selectPlants => 'Zvolit květiny';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'nových událostí',
      one: 'nová událost',
    );
    return 'Vytvořeno $countString $_temp0';
  }

  @override
  String get addNote => 'Přidat poznámku';

  @override
  String get enterNote => 'Zadejte poznámku';

  @override
  String get selectAtLeastOnePlant => 'Zvolte alespoň jednu květinu';

  @override
  String get selectAtLeastOneEvent => 'Zvolte alespoň jednu událost';

  @override
  String get eventSuccessfullyUpdated => 'Událost aktualizována úspěšně';

  @override
  String get editEvent => 'Upravit událost';

  @override
  String get eventSuccessfullyDeleted => 'Událost smazána úspěšně';

  @override
  String get noInfoAvailable => 'Žádné info';

  @override
  String get species => 'Druh';

  @override
  String get plant => 'Květina';

  @override
  String get scientificClassification => 'Vědecká klasifikace';

  @override
  String get family => 'Rodina';

  @override
  String get genus => 'Rod';

  @override
  String get synonyms => 'Synonyma';

  @override
  String get care => 'Péče';

  @override
  String get light => 'Světlo';

  @override
  String get humidity => 'Vlhkost';

  @override
  String get maxTemp => 'Maximální teplota';

  @override
  String get minTemp => 'Minimální teplota';

  @override
  String get minPh => 'Minimální ph';

  @override
  String get maxPh => 'Maximální ph';

  @override
  String get info => 'Info';

  @override
  String get addPhotos => 'Přidat fotky';

  @override
  String get addEvents => 'Přidat událost';

  @override
  String get modifyPlant => 'Upravit květinu';

  @override
  String get removePlant => 'Odebrat květinu';

  @override
  String get useBirthday => 'Použít narozeniny';

  @override
  String get birthday => 'Narozeniny';

  @override
  String get avatar => 'Avatar';

  @override
  String get note => 'Poznámka';

  @override
  String get stats => 'Statistika';

  @override
  String get eventStats => 'Statistika událostí';

  @override
  String get age => 'Věk';

  @override
  String get newBorn => 'Nová květina';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dny',
      one: 'den',
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
      other: 'měsíců',
      one: 'měsíc',
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
      other: 'let',
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
      other: 'měsíců',
      one: 'měsíc',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dní',
      one: 'den',
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
      other: 'let',
      one: 'rok',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dní',
      one: 'den',
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
      other: 'let',
      one: 'rok',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'měsíců',
      one: 'měsíc',
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
      other: 'let',
      one: 'rok',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'měsíců',
      one: 'měsíc',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'dní',
      one: 'den',
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

    return '$valueString mimo $maxString';
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
  String get numberOfPhotos => 'Počet fotek';

  @override
  String get numberOfEvents => 'Počet událostí';

  @override
  String get searchInYourPlants => 'Hledat mezi květinami';

  @override
  String get searchNewGreenFriends => 'Vyhledat nové zelené kamarády';

  @override
  String get custom => 'Vlastní';

  @override
  String get addPlant => 'Přidat květinu';

  @override
  String get yes => 'Ano';

  @override
  String get no => 'Ne';

  @override
  String get pleaseConfirm => 'Prosím potvrďte';

  @override
  String get areYouSureToRemoveEvent =>
      'Opravdu chcete odstranit tuto událost?';

  @override
  String get areYouSureToRemoveReminder =>
      'Opravdu chcete odstranit tuto připomínku?';

  @override
  String get areYouSureToRemoveSpecies =>
      'Opravdu chcete odstranit tento druh??';

  @override
  String get areYouSureToRemovePlant =>
      'Opravdu chcete odstranit tuto květinu?';

  @override
  String get purchasedPrice => 'Nákupní cena';

  @override
  String get seller => 'Prodejce';

  @override
  String get location => 'Lokace';

  @override
  String get currency => 'Měna';

  @override
  String get plantUpdatedSuccessfully => 'Květina aktualizována úspěšně';

  @override
  String get plantCreatedSuccessfully => 'Květina vytvořena úspěšně';

  @override
  String get insertPrice => 'Vložit cenu';

  @override
  String get noBirthday => 'Bez narozenin';

  @override
  String get appVersion => 'Verze aplikace';

  @override
  String get serverVersion => 'Verze serveru';

  @override
  String get documentation => 'Dokumentace';

  @override
  String get openSource => 'Open source';

  @override
  String get reportIssue => 'Nahlásit problém';

  @override
  String get logout => 'Odhlásit';

  @override
  String get eventCount => 'Počet událostí';

  @override
  String get plantCount => 'Počet květin';

  @override
  String get speciesCount => 'Počet druhů';

  @override
  String get imageCount => 'Počet obrázků';

  @override
  String get unknown => 'Neznámý';

  @override
  String get account => 'Účet';

  @override
  String get changePassword => 'Změnit heslo';

  @override
  String get more => 'Více';

  @override
  String get editProfile => 'Upravit profil';

  @override
  String get currentPassword => 'Současné heslo';

  @override
  String get updatePassword => 'Aktualizovat heslo';

  @override
  String get updateProfile => 'Aktualizovat profil';

  @override
  String get newPassword => 'Nové heslo';

  @override
  String get removeEvent => 'Odebrat událost';

  @override
  String get appLog => 'Protokol aplikace';

  @override
  String get passwordUpdated => 'Heslo aktualizováno úspěšně';

  @override
  String get userUpdated => 'Uživatel aktualizován úspěšně';

  @override
  String get noChangesDetected => 'Žádné změny';

  @override
  String get plantDeletedSuccessfully => 'Květina snazána úspěšně';

  @override
  String get server => 'Server';

  @override
  String get notifications => 'Upozornění';

  @override
  String get changeServer => 'Změnit server';

  @override
  String get serverUpdated => 'Server aktualizován úspěšně';

  @override
  String get changeNotifications => 'Změnit upozornění';

  @override
  String get updateNotifications => 'Aktualizovat upozornění';

  @override
  String get notificationUpdated => 'Upozornění aktualizovány úspěšně';

  @override
  String get supportTheProject => 'Podpořit projekt';

  @override
  String get buyMeACoffee => 'Kup mi kafe';

  @override
  String get gallery => 'Galerie';

  @override
  String photosOf(String name) {
    return 'Fotky $name';
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
      other: 'fotek',
      one: 'fotka',
    );
    return 'Nahráno $countString new $_temp0';
  }

  @override
  String get errorCreatingPlant => 'Chyba při vytváření květiny';

  @override
  String get noImages => 'Žádné obrázky';

  @override
  String get errorCreatingSpecies => 'Chyba při vytváření druhu';

  @override
  String get errorUpdatingSpecies => 'Chyba při aktualizování druhu';

  @override
  String get speciesUpdatedSuccessfully => 'Druh aktualizován úspěšně';

  @override
  String get addCustom => 'Přidat vlastní';

  @override
  String get speciesCreatedSuccessfully => 'Druh vytvořen úspěšně';

  @override
  String get uploadPhoto => 'Nahrát fotku';

  @override
  String get linkURL => 'Link URL';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Potvrdit';

  @override
  String get cancel => 'Zrušit';

  @override
  String get actions => 'Akce';

  @override
  String get areYouSureToRemovePhoto => 'Opravdu chcete fotku odstranit?';

  @override
  String get photoSuccessfullyDeleted => 'Fotka smazána úspěšně';

  @override
  String get errorUpdatingPlant => 'Chyba při aktualizaci květiny';

  @override
  String get reminders => 'Upomínky';

  @override
  String get selectStartDate => 'Zvolte počáteční datum';

  @override
  String get selectEndDate => 'Zvolte konečné datum';

  @override
  String get addNewReminder => 'Přidat novou upomínku';

  @override
  String get noEndDate => 'Žádné konečné datum';

  @override
  String get frequency => 'Frekvence';

  @override
  String get repeatAfter => 'Opakovat po';

  @override
  String get addNew => 'Přidat nový';

  @override
  String get reminderCreatedSuccessfully => 'Upomínka vytvořena úspěšně';

  @override
  String get startAndEndDateOrderError =>
      'Počáteční datum musí být před konečným datem';

  @override
  String get reminderUpdatedSuccessfully => 'Upomínka aktualizována úspěšně';

  @override
  String get reminderDeletedSuccessfully => 'Upomínka smazána úspěšně';

  @override
  String get errorResettingPassword => 'Chyba při obnovení hesla';

  @override
  String get resetPassword => 'Obnovit heslo';

  @override
  String get resetPasswordHeader =>
      'Vložte uživatelské jméno pro zaslání obnovení hesla';

  @override
  String get editReminder => 'Přidat upomínku';

  @override
  String get ntfyServerUrl => 'URL adresa serveru Ntfy';

  @override
  String get ntfyServerTopic => 'Téma serveru Ntfy';

  @override
  String get ntfyServerUsername => 'Uživatelské jméno serveru Ntfy';

  @override
  String get ntfyServerPassword => 'Heslo serveru Ntfy';

  @override
  String get ntfyServerToken => 'Token serveru Ntfy';

  @override
  String get enterValidTopic => 'Zadejte platné téma';

  @override
  String get ntfySettings => 'Nastavení Ntfy';

  @override
  String get ntfySettingsUpdated => 'Nastavení Ntfy aktualizováno úspěšně';

  @override
  String get modifySpecies => 'Upravit druh';

  @override
  String get removeSpecies => 'Smazat druh';

  @override
  String get speciesDeletedSuccessfully => 'Druh smazán úspěšně';

  @override
  String get success => 'Úspěch';

  @override
  String get warning => 'Varování';

  @override
  String get ops => 'Ops!';

  @override
  String get changeLanguage => 'Změnit jazyk';

  @override
  String get gotifyServerUrl => 'URL adresa serveru Gotify';

  @override
  String get gotifyServerToken => 'Token serveru Gotify';

  @override
  String get gotifySettings => 'Nastavení Gotify';

  @override
  String get gotifySettingsUpdated => 'Nastavení Gotify aktualizováno úspěšně';

  @override
  String get activity => 'Aktivita';

  @override
  String get fromDate => 'od';

  @override
  String frequencyEvery(num amount, String unit) {
    return 'každý $amount $unit';
  }

  @override
  String day(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'dny',
      one: 'den',
    );
    return '$_temp0';
  }

  @override
  String week(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'týdnů',
      one: 'týden',
    );
    return '$_temp0';
  }

  @override
  String month(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'měsíců',
      one: 'měsíc',
    );
    return '$_temp0';
  }

  @override
  String year(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'let',
      one: 'rok',
    );
    return '$_temp0';
  }
}
