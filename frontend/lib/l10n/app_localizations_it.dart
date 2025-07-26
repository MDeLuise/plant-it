// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get enterValue => 'Insertisci un valore';

  @override
  String get enterValidURL => 'Inserisci un indirizzo valido';

  @override
  String get go => 'Avanti';

  @override
  String get noBackend => 'Impossibile collegarsi al server';

  @override
  String get ok => 'Ok';

  @override
  String get serverURL => 'Indirizzo del server';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get login => 'Accedi';

  @override
  String get badCredentials => 'Password o utente errati';

  @override
  String get loginMessage => 'Bentornato su';

  @override
  String get signupMessage => 'Benvenuto su';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Password dimenticata?';

  @override
  String get areYouNew => 'Non hai un account?';

  @override
  String get createAccount => 'Crea un account';

  @override
  String get email => 'Email';

  @override
  String get usernameSize => 'Lo username deve avere tra 3 e 20 caratteri';

  @override
  String get passwordSize => 'La password deve avere tra 6 e 20 caratteri';

  @override
  String get enterValidEmail => 'Inserisci un\'email valida';

  @override
  String get alreadyRegistered => 'Hai già un account?';

  @override
  String get signup => 'Crea account';

  @override
  String get generalError => 'Errore durante l\'operazione';

  @override
  String get error => 'Errore';

  @override
  String get details => 'Dettagli';

  @override
  String get insertBackendURL =>
      'Ciao! Pronto per iniziare? Cominciamo impostando l\'URL del server a cui connettersi.';

  @override
  String get loginTagline => 'Esplora la natura e coltiva la tua passione!';

  @override
  String get singupTagline => 'Unisciti alla nostra community!';

  @override
  String get sentOTPCode => 'Inserisci il codice inviato all\'indirizzo: ';

  @override
  String get verify => 'Verify';

  @override
  String get resendCode => 'Resend code';

  @override
  String get otpCode => 'Codice OTP';

  @override
  String get splashLoading =>
      'Beep boop beep... Sto scaricando i dati dal server!';

  @override
  String get welcomeBack => 'Bentornato';

  @override
  String hello(String userName) {
    return 'Ciao, $userName';
  }

  @override
  String get search => 'Cerca';

  @override
  String get today => 'oggi';

  @override
  String get yesterday => 'ieri';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'giorni',
      one: 'giorno',
    );
    return '$countString $_temp0 fa';
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
      other: 'giorni',
      one: 'giorno',
    );
    return '$countString $_temp0 nel futuro (cosaaa?)';
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
      other: 'mesi',
      one: 'mese',
    );
    return '$countString $_temp0 fa';
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
      other: 'anni',
      one: 'anno',
    );
    return '$countString $_temp0 fa';
  }

  @override
  String get events => 'Eventi';

  @override
  String get plants => 'Piante';

  @override
  String get or => 'oppure';

  @override
  String get filter => 'Filtra';

  @override
  String get seeding => 'seminazione';

  @override
  String get watering => 'innaffiatura';

  @override
  String get fertilizing => 'fertilizzazione';

  @override
  String get biostimulating => 'biostimulazione';

  @override
  String get misting => 'nebulizzazione';

  @override
  String get transplanting => 'trapianto';

  @override
  String get water_changing => 'cambio acqua';

  @override
  String get observation => 'osservazione';

  @override
  String get treatment => 'trattamento';

  @override
  String get propagating => 'propagazione';

  @override
  String get pruning => 'potatura';

  @override
  String get repotting => 'rinvaso';

  @override
  String get recents => 'Recenti';

  @override
  String get addNewEvent => 'Crea un evento';

  @override
  String get selectDate => 'Seleziona la data';

  @override
  String get selectEvents => 'Seleziona gli eventi';

  @override
  String get selectPlants => 'Seleziona le piante';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'nuovi',
      one: 'nuovo',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'eventi',
      one: 'evento',
    );
    String _temp2 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'creati',
      one: 'creato',
    );
    return '$countString $_temp0 $_temp1 $_temp2';
  }

  @override
  String get addNote => 'Aggiungi una nota';

  @override
  String get enterNote => 'Inserisci la nota';

  @override
  String get selectAtLeastOnePlant => 'Seleziona almeno una pianta';

  @override
  String get selectAtLeastOneEvent => 'Seleziona almeno un evento';

  @override
  String get eventSuccessfullyUpdated => 'Evento modificato correttamente';

  @override
  String get editEvent => 'Modifica evento';

  @override
  String get eventSuccessfullyDeleted => 'Evento eliminato correttamente';

  @override
  String get noInfoAvailable => 'Nessuna informazione';

  @override
  String get species => 'Specie';

  @override
  String get plant => 'Pianta';

  @override
  String get scientificClassification => 'Classificazione botanica';

  @override
  String get family => 'Famiglia';

  @override
  String get genus => 'Genere';

  @override
  String get synonyms => 'Sinonimi';

  @override
  String get care => 'Cura';

  @override
  String get light => 'Luce';

  @override
  String get humidity => 'Umidità';

  @override
  String get maxTemp => 'Temperatura massima';

  @override
  String get minTemp => 'Temperatura minima';

  @override
  String get minPh => 'minimo ph';

  @override
  String get maxPh => 'Massimo ph';

  @override
  String get info => 'Informazioni';

  @override
  String get addPhotos => 'Aggiungi foto';

  @override
  String get addEvents => 'Aggiungi eventi';

  @override
  String get modifyPlant => 'Modifica pianta';

  @override
  String get removePlant => 'Elimina pianta';

  @override
  String get useBirthday => 'Use birthday';

  @override
  String get birthday => 'Compleanno';

  @override
  String get avatar => 'Avatar';

  @override
  String get note => 'Note';

  @override
  String get stats => 'Statistiche';

  @override
  String get eventStats => 'Statistiche degli eventi';

  @override
  String get age => 'Età';

  @override
  String get newBorn => 'Appena nata';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'giorni',
      one: 'giorno',
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
      other: 'mesi',
      one: 'mese',
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
      other: 'anni',
      one: 'anno',
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
      other: 'mesi',
      one: 'mese',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'giorni',
      one: 'giorno',
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
      other: 'anni',
      one: 'anno',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'giorni',
      one: 'giorno',
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
      other: 'anni',
      one: 'anno',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'mesi',
      one: 'mese',
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
      other: 'anni',
      one: 'anno',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'mesi',
      one: 'mese',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'giorni',
      one: 'giorno',
    );
    return '$yearsString $_temp0, $monthsString $_temp1, $daysString $_temp2';
  }

  @override
  String get name => 'Nome';

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

    return '$valueString su $maxString';
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
  String get numberOfPhotos => 'Numero di foto';

  @override
  String get numberOfEvents => 'Numbero di eventi';

  @override
  String get searchInYourPlants => 'Cerca le tue piante';

  @override
  String get searchNewGreenFriends => 'Cerca nuovi amici verdi';

  @override
  String get custom => 'Creato';

  @override
  String get addPlant => 'Aggiungi pianta';

  @override
  String get yes => 'Sì';

  @override
  String get no => 'No';

  @override
  String get pleaseConfirm => 'Richiesta conferma';

  @override
  String get areYouSureToRemoveEvent => 'Sicuro di voler eliminare l\'evento?';

  @override
  String get areYouSureToRemoveReminder =>
      'Sicuro di voler eliminare il reminder?';

  @override
  String get areYouSureToRemoveSpecies =>
      'Sicuro di voler eliminare la specie?';

  @override
  String get areYouSureToRemovePlant => 'Sicuro di voler eliminare la pianta?';

  @override
  String get purchasedPrice => 'Prezzo';

  @override
  String get seller => 'Venditore';

  @override
  String get location => 'Posizione';

  @override
  String get currency => 'Valua';

  @override
  String get plantUpdatedSuccessfully => 'Pianta modificata correttamente';

  @override
  String get plantCreatedSuccessfully => 'Pianta creata correttamente';

  @override
  String get insertPrice => 'Inserisci il prezzo';

  @override
  String get noBirthday => 'Nessun compleanno';

  @override
  String get appVersion => 'Versione dell\'app';

  @override
  String get serverVersion => 'Versione del server';

  @override
  String get documentation => 'Documentazione';

  @override
  String get openSource => 'Codice sorgente';

  @override
  String get reportIssue => 'Segnala problema';

  @override
  String get logout => 'Esci';

  @override
  String get eventCount => 'Numero eventi';

  @override
  String get plantCount => 'Numero piante';

  @override
  String get speciesCount => 'Numero specie';

  @override
  String get imageCount => 'Numero immagini';

  @override
  String get unknown => 'Sconosciuto';

  @override
  String get account => 'Profilo';

  @override
  String get changePassword => 'Cambia password';

  @override
  String get more => 'Altro';

  @override
  String get editProfile => 'Modifica il profilo';

  @override
  String get currentPassword => 'Password attuale';

  @override
  String get updatePassword => 'Modifica password';

  @override
  String get updateProfile => 'Modifica profilo';

  @override
  String get newPassword => 'Nuova password';

  @override
  String get removeEvent => 'Elimina evento';

  @override
  String get appLog => 'Log dell\'applicazione';

  @override
  String get passwordUpdated => 'Password modificata';

  @override
  String get userUpdated => 'Account modificato';

  @override
  String get noChangesDetected => 'Nessuna modifica rilevata';

  @override
  String get plantDeletedSuccessfully => 'Pianta rimossa';

  @override
  String get server => 'Server';

  @override
  String get notifications => 'Notifiche';

  @override
  String get changeServer => 'Modifica server';

  @override
  String get serverUpdated => 'Server modificato';

  @override
  String get changeNotifications => 'Modifica notifiche';

  @override
  String get updateNotifications => 'Modifica notifiche';

  @override
  String get notificationUpdated => 'Notifiche modificate';

  @override
  String get supportTheProject => 'Supporta il progetto';

  @override
  String get buyMeACoffee => 'Offrimi un caffè';

  @override
  String get gallery => 'Galleria';

  @override
  String photosOf(String name) {
    return 'Foto di $name';
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
      other: 'Caricate',
      one: 'Caricata',
    );
    String _temp1 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'nuove',
      one: 'nuova',
    );
    return '$_temp0 $countString $_temp1 foto';
  }

  @override
  String get errorCreatingPlant => 'Errore durante la creazione della pianta';

  @override
  String get noImages => 'Nessuna immagine';

  @override
  String get errorCreatingSpecies => 'Errore durante la creazione della specie';

  @override
  String get errorUpdatingSpecies => 'Errore durante la modifica della specie';

  @override
  String get speciesUpdatedSuccessfully => 'Specie modificata correttamente';

  @override
  String get addCustom => 'Crea nuova';

  @override
  String get speciesCreatedSuccessfully => 'Specie creata correttamente';

  @override
  String get uploadPhoto => 'Carica una foto';

  @override
  String get linkURL => 'Usa un link';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Conferma';

  @override
  String get cancel => 'Annulla';

  @override
  String get actions => 'Azioni';

  @override
  String get areYouSureToRemovePhoto => 'Sicuro di voler eliminare la foto?';

  @override
  String get photoSuccessfullyDeleted => 'Foto eliminata correttamente';

  @override
  String get errorUpdatingPlant => 'Errore durante la modifica della pianta';

  @override
  String get reminders => 'Avvisi';

  @override
  String get selectStartDate => 'Seleziona data di inizio';

  @override
  String get selectEndDate => 'Seleziona data di fine';

  @override
  String get addNewReminder => 'Aggiungi nuovo avviso';

  @override
  String get noEndDate => 'Nessuna data di fine';

  @override
  String get frequency => 'Frequenza';

  @override
  String get repeatAfter => 'Ripeti dopo';

  @override
  String get addNew => 'Aggiungi nuovo';

  @override
  String get reminderCreatedSuccessfully => 'Avviso creato correttamente';

  @override
  String get startAndEndDateOrderError =>
      'La data di inizio deve essere prima di quella di fine';

  @override
  String get reminderUpdatedSuccessfully => 'Avviso modificato correttamente';

  @override
  String get reminderDeletedSuccessfully => 'Avviso rimosso correttamente';

  @override
  String get errorResettingPassword =>
      'Errore durante il ripristino della password';

  @override
  String get resetPassword => 'Ripristina password';

  @override
  String get resetPasswordHeader =>
      'Inserisci lo username qui sotto per inviare una richiesta di ripristino password';

  @override
  String get editReminder => 'Modifica avviso';

  @override
  String get ntfyServerUrl => 'URL del server ntfy';

  @override
  String get ntfyServerTopic => 'Topic del server ntfy';

  @override
  String get ntfyServerUsername => 'Username per il server ntfy';

  @override
  String get ntfyServerPassword => 'Password per il server ntfy';

  @override
  String get ntfyServerToken => 'Token per il server ntfy';

  @override
  String get enterValidTopic => 'Inserisci un topic valido';

  @override
  String get ntfySettings => 'Impostazioni ntfy';

  @override
  String get ntfySettingsUpdated =>
      'Configurazioni ntfy aggiornate correttamente';

  @override
  String get modifySpecies => 'Modifica specie';

  @override
  String get removeSpecies => 'Elimina specie';

  @override
  String get speciesDeletedSuccessfully => 'Specie eliminata correttamente';

  @override
  String get success => 'Successo';

  @override
  String get warning => 'Attenzione';

  @override
  String get ops => 'Ops!';

  @override
  String get changeLanguage => 'Cambia lingua';

  @override
  String get gotifyServerUrl => 'URL del server gotify';

  @override
  String get gotifyServerToken => 'Token per il server gotify';

  @override
  String get gotifySettings => 'Impostazioni gotify';

  @override
  String get gotifySettingsUpdated =>
      'Configurazioni gotify aggiornate correttamente';

  @override
  String get activity => 'Attività';

  @override
  String get fromDate => 'dal';

  @override
  String frequencyEvery(num amount, String unit) {
    return 'ogni $amount $unit';
  }

  @override
  String day(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'giorni',
      one: 'giorno',
    );
    return '$_temp0';
  }

  @override
  String week(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'settimane',
      one: 'settimana',
    );
    return '$_temp0';
  }

  @override
  String month(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'mesi',
      one: 'mese',
    );
    return '$_temp0';
  }

  @override
  String year(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'anni',
      one: 'anno',
    );
    return '$_temp0';
  }
}
