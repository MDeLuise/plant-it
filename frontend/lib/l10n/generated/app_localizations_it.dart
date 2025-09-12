// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class LIt extends L {
  LIt([String locale = 'it']) : super(locale);

  @override
  String get searchYourPlants => 'Cerca nelle tue piante';

  @override
  String get filterActivities => 'Filtra Attività';

  @override
  String get filter => 'Filtra';

  @override
  String get eventTypes => 'Tipi Evento';

  @override
  String nEventTypes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString tipi evento';
  }

  @override
  String get whichEventsYouWantToAdd => 'Quali eventi vuoi aggiungere?';

  @override
  String get plants => 'Piante';

  @override
  String nPlants(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'e',
      one: 'a',
    );
    return '$countString piant$_temp0';
  }

  @override
  String get whichPlantsYouWantToAdd => 'Quali piante vuoi aggiungere?';

  @override
  String get error => 'Errore';

  @override
  String get tryAgain => 'Riprova';

  @override
  String get confirmDelete => 'Conferma eliminazione';

  @override
  String get areYouSureYouWantToDeleteThisEvent =>
      'Sei sicuro di rimuovere l\'evento?';

  @override
  String get cancel => 'Annulla';

  @override
  String get delete => 'Rimuovi';

  @override
  String get eventDeleted => 'Evento rimosso';

  @override
  String get edit => 'Modifica';

  @override
  String get eventCreated => 'Evento creato';

  @override
  String get markDone => 'Segna fatto';

  @override
  String get reminder => 'Promemoria';

  @override
  String get back => 'Indietro';

  @override
  String get next => 'Avanti';

  @override
  String get confirm => 'Conferma';

  @override
  String get createEvent => 'Crea Evento';

  @override
  String get create => 'Crea';

  @override
  String get eventsCreated => 'Evento creato';

  @override
  String get save => 'Salva';

  @override
  String get editTheEvent => 'Modifica l\'evento';

  @override
  String get eventUpdated => 'Evento aggiornato';

  @override
  String get selectTheEventType => 'Seleziona il tipo di evento';

  @override
  String get selectThePlant => 'Seleziona la pianta';

  @override
  String get nextActions => 'Prossime azioni';

  @override
  String get home => 'Home';

  @override
  String get calendar => 'Calendario';

  @override
  String get search => 'Cerca';

  @override
  String get more => 'Altro';

  @override
  String get addPlant => 'Aggiungi Pianta';

  @override
  String get add => 'Aggiungi';

  @override
  String get plantAdded => 'Pianta aggiunta';

  @override
  String get location => 'Posizione';

  @override
  String get name => 'Nome';

  @override
  String get price => 'Prezzo';

  @override
  String get editPlant => 'Modifica Pianta';

  @override
  String get plantUpdated => 'Pianta aggiornata';

  @override
  String get deleteImage => 'Elimina immagine';

  @override
  String get areYouSureYouWantToDeleteThisImage =>
      'Sicuro di voler rimuovere l\'immagine?';

  @override
  String get info => 'Info';

  @override
  String get imageInfo => 'Info sull\'immagine';

  @override
  String get ok => 'Ok';

  @override
  String get download => 'Download';

  @override
  String get unsetAsAvatar => 'Rimuovi come Avatar';

  @override
  String get setAsAvatar => 'Seleziona come Avatar';

  @override
  String get information => 'Informazioni';

  @override
  String get care => 'Cura';

  @override
  String get reminders => 'Promemoria';

  @override
  String get events => 'Eventi';

  @override
  String get gallery => 'Galleria';

  @override
  String get duplicate => 'Duplica';

  @override
  String get plantDuplicated => 'Pianta duplicata';

  @override
  String get plantDeleted => 'Pianta eliminata';

  @override
  String get searchGreenFriends => 'Cerca nuovi amici';

  @override
  String get note => 'Note';

  @override
  String get update => 'Aggiorna';

  @override
  String get custom => 'creato';

  @override
  String get floraCodex => 'Flora Codex';

  @override
  String get seller => 'Venditore';

  @override
  String get remove => 'Rimuovi';

  @override
  String get createEventType => 'Crea Tipo Evento';

  @override
  String get selectAColor => 'Seleziona un colore';

  @override
  String get select => 'Seleziona';

  @override
  String get whichColorYouWantToUse => 'Quale colore vuoi usare?';

  @override
  String get description => 'Descrizione';

  @override
  String get whichIconYouWantToUse => 'Quale icona vuoi usare?';

  @override
  String get filterIcons => 'Filtra icone';

  @override
  String get insertAName => 'Inserisci un nome';

  @override
  String get editEventType => 'Modifica Tipo Evento';

  @override
  String get eventTypeUpdated => 'Tipo Evento aggiornato';

  @override
  String get areYouSureYouWantToDeleteTheEventTypeAndAllLinkedEvents =>
      'Sicuro di voler eliminare il tipo evento e tutti gli eventi collegati?';

  @override
  String get eventTypeDeleted => 'Tipo Evento eliminato';

  @override
  String get createReminder => 'Crea Promemoria';

  @override
  String get reminderCreated => 'Promemoria creato';

  @override
  String get whichEventTypeYouWantToSet =>
      'Quale tipo evento vuoi selezionare?';

  @override
  String get quantity => 'Quantità';

  @override
  String get whichPlantsYouWantToSet => 'Quale pianta vuoi selezionare?';

  @override
  String get editReminder => 'Modifica Promemoria';

  @override
  String get reminderUpdated => 'Promemoria aggiornato';

  @override
  String get whichEventsYouWantToSet => 'Quali eventi vuoi selezionare?';

  @override
  String get reminderDeleted => 'Promemoria eliminato';

  @override
  String get areYouSureYouWantToDeleteTheReminder =>
      'Sicuro di voler eliminare il promemoria?';

  @override
  String get dataSources => 'Sorgenti dei dati';

  @override
  String get configureTheFloraCodexSettings =>
      'Configura le impostazioni di Flora Codex';

  @override
  String get insertTheFloraCodexApiKey => 'Inserisci l\'API Key di Flora Codex';

  @override
  String get enterApiKey => 'Inserisci l\'API Key';

  @override
  String get enableDataSource => 'Attiva la sorgente dei dati';

  @override
  String get apiKey => 'API Key';

  @override
  String get notProvided => 'non specificata';

  @override
  String get appInfo => 'Informazioni sull\'app';

  @override
  String get appVersion => 'Versione dell\'app';

  @override
  String get sourceCode => 'Codice sorgente';

  @override
  String get support => 'Supporta ♥️';

  @override
  String get notifications => 'Notifiche';

  @override
  String get enableNotifications => 'Attiva Notifiche';

  @override
  String get selectWeekdaysAndTimes => 'Seleziona giorni e orari';

  @override
  String get pickTime => 'Scegli orario';

  @override
  String get done => 'Fatto';

  @override
  String get aboutPlantIt => 'Plant-it info';

  @override
  String get manageTheEventTypes => 'Gestisci i tipi di evento';

  @override
  String get manageTheReminders => 'Gestisci i promemoria';

  @override
  String get manageTheDataSources => 'Gestisci le sorgenti di dati';

  @override
  String get configureWhenAndIfNotificationsAreReceived =>
      'Configura se e quando ricevere notifiche';

  @override
  String get detailsAboutTheApp => 'Dettagli sull\'app';

  @override
  String get yourSupportHelpsUsGrow => 'Il tuo supporto ci aiuta a crescere!';

  @override
  String get supportTheProject => 'Supporta il progetto';

  @override
  String get whySupportPlantIt => 'Perchè supportare Plant-it?';

  @override
  String get openSourceProjectThatBenefitsEveryone =>
      'Progetto open-source utilizzabile da chiunque';

  @override
  String get yourDonationsHelpUsImproveTheApp =>
      'Le donazioni ci aiutano a migliorare l\'app';

  @override
  String get supportNewFeaturesAndUpdates => 'Supporta nuovi aggiornamenti';

  @override
  String get donateNow => 'Dona Ora';

  @override
  String get createSpecies => 'Crea Specie';

  @override
  String get speciesCreated => 'Specie creata';

  @override
  String get avatar => 'Avatar';

  @override
  String get noAvatar => 'Nessun avatar';

  @override
  String get uploadPhoto => 'Carica foto';

  @override
  String get choosePhoto => 'Scegli foto';

  @override
  String get noPhoto => 'Nessuna foto';

  @override
  String get useWebImage => 'Usa immagine web';

  @override
  String get url => 'Url';

  @override
  String get light => 'Luce';

  @override
  String get humidity => 'Umidità';

  @override
  String get temperature => 'Temperatura';

  @override
  String get ph => 'Ph';

  @override
  String get genus => 'Genere';

  @override
  String get family => 'Famiglia';

  @override
  String get synonym => 'Sinonimo';

  @override
  String get addSynonym => 'Aggiungi sinonimo';

  @override
  String get classification => 'Classificazione';

  @override
  String get species => 'Specie';

  @override
  String get synonyms => 'Sinonimi';

  @override
  String get editSpecies => 'Modifica Specie';

  @override
  String get speciesUpdated => 'Specie aggiornata';

  @override
  String get addToCollection => 'Aggiungi alla collezione';

  @override
  String get showNextNotificationsDateTime =>
      'Mostra prossimi giorni e orari delle notifiche';

  @override
  String get date => 'Data';

  @override
  String get plant => 'Pianta';

  @override
  String get low => 'Basso';

  @override
  String get medium => 'Medio';

  @override
  String get high => 'Alto';

  @override
  String get sunlight => 'Luce';

  @override
  String get min => 'min';

  @override
  String get max => 'max';

  @override
  String errorWithMessage(String message) {
    return 'Errore: $message';
  }

  @override
  String get color => 'Colore';

  @override
  String get red => 'rosso';

  @override
  String get green => 'verde';

  @override
  String get blue => 'blu';

  @override
  String get white => 'bianco';

  @override
  String get teal => 'verde acqua';

  @override
  String get yellow => 'giallo';

  @override
  String get icon => 'Icona';

  @override
  String get every => 'Ogni';

  @override
  String get repeatAfter => 'Ripeti dopo';

  @override
  String repeatAfterMessage(num quantity, String unit) {
    final intl.NumberFormat quantityNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String quantityString = quantityNumberFormat.format(quantity);

    return '$quantityString $unit';
  }

  @override
  String frequencyMessage(num quantity, String unit) {
    final intl.NumberFormat quantityNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String quantityString = quantityNumberFormat.format(quantity);

    return 'Ogni $quantityString $unit';
  }

  @override
  String afterMessage(num quantity, String unit) {
    final intl.NumberFormat quantityNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String quantityString = quantityNumberFormat.format(quantity);

    return 'Dopo $quantityString $unit';
  }

  @override
  String get day => 'giorno';

  @override
  String get week => 'settimane';

  @override
  String get month => 'mesi';

  @override
  String get year => 'anni';

  @override
  String reminderDescription(
      num quantity, String unit, DateTime startDate, String endDate) {
    final intl.NumberFormat quantityNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String quantityString = quantityNumberFormat.format(quantity);

    return 'Ogni $quantityString $unit';
  }

  @override
  String get start => 'Inizio';

  @override
  String plantClassificationInfo(
      String name, String species, String genus, String family) {
    String _temp0 = intl.Intl.selectLogic(
      genus,
      {
        'null': '',
        'other': ', genere |$genus|',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      family,
      {
        'null': '',
        'other': ', famiglia |$family|',
      },
    );
    return '$name è una pianta della specie |$species|$_temp0$_temp1.';
  }

  @override
  String speciesSynonyms(String synonyms, String species) {
    String _temp0 = intl.Intl.selectLogic(
      synonyms,
      {
        'null': '$species non ha sinonimi',
        'other': '$species è conosciuta anche come: $synonyms',
      },
    );
    return '$_temp0.';
  }

  @override
  String speciesClassificationInfo(
      String species, String genus, String family) {
    String _temp0 = intl.Intl.selectLogic(
      genus,
      {
        'null': 'sconosciuto',
        'other': '|$genus|',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      family,
      {
        'null': 'sconosciuta',
        'other': '|$family|',
      },
    );
    return '$species è una specie del genere $_temp0 e famiglia $_temp1.';
  }

  @override
  String get eventType => 'Tipo Evento';

  @override
  String get end => 'Fine';

  @override
  String get databaseAndCache => 'Database e Cache';

  @override
  String get manageDatabaseAndCache =>
      'Gestisci le impostazioni del Database e della Cache';

  @override
  String get clearCache => 'Svuota la Cache';

  @override
  String get cacheCleaned => 'Cache svuotata';

  @override
  String get noSynonyms => 'Nessun sinonimo conosciuto';

  @override
  String get areYouSureYouWantToDeleteThisPlant =>
      'Sicuro di voler eliminare questa pianta?';

  @override
  String get areYouSureYouWantToDeleteThisSpecies =>
      'Sicuro di voler eliminare questa specie e tutte le tue piante collegate?';

  @override
  String get speciesDeleted => 'Specie eliminata';
}
