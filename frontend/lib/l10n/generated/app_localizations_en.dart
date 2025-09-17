// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class LEn extends L {
  LEn([String locale = 'en']) : super(locale);

  @override
  String get searchYourPlants => 'Search your plants';

  @override
  String get filterActivities => 'Filter Activities';

  @override
  String get filter => 'Filter';

  @override
  String get eventTypes => 'Event Types';

  @override
  String nEventTypes(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$countString event type$_temp0';
  }

  @override
  String get whichEventsYouWantToAdd => 'Which events you want to add?';

  @override
  String get plants => 'Plants';

  @override
  String nPlants(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$countString plant$_temp0';
  }

  @override
  String get whichPlantsYouWantToAdd => 'Which plants you want to add?';

  @override
  String get error => 'Error';

  @override
  String get tryAgain => 'Try again';

  @override
  String get confirmDelete => 'Confirm Delete';

  @override
  String get areYouSureYouWantToDeleteThisEvent =>
      'Are you sure you want to delete this event?';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get eventDeleted => 'Event deleted';

  @override
  String get edit => 'Edit';

  @override
  String get eventCreated => 'Event created';

  @override
  String get markDone => 'Mark done';

  @override
  String get reminder => 'Reminder';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get confirm => 'Confirm';

  @override
  String get createEvent => 'Create Event';

  @override
  String get create => 'Create';

  @override
  String get eventsCreated => 'Events created';

  @override
  String get save => 'Save';

  @override
  String get editTheEvent => 'Edit the event';

  @override
  String get eventUpdated => 'Event updated';

  @override
  String get selectTheEventType => 'Select the event type';

  @override
  String get selectThePlant => 'Select the plant';

  @override
  String get nextActions => 'Next actions';

  @override
  String get home => 'Home';

  @override
  String get calendar => 'Calendar';

  @override
  String get search => 'Search';

  @override
  String get more => 'More';

  @override
  String get addPlant => 'Add Plant';

  @override
  String get add => 'Add';

  @override
  String get plantAdded => 'Plant added';

  @override
  String get location => 'Location';

  @override
  String get name => 'Name';

  @override
  String get price => 'Price';

  @override
  String get editPlant => 'Edit Plant';

  @override
  String get plantUpdated => 'Plant updated';

  @override
  String get deleteImage => 'Delete image';

  @override
  String get areYouSureYouWantToDeleteThisImage =>
      'Are you sure you want to delete this image?';

  @override
  String get info => 'Info';

  @override
  String get imageInfo => 'Image info';

  @override
  String get ok => 'Ok';

  @override
  String get download => 'Download';

  @override
  String get unsetAsAvatar => 'Unset as Avatar';

  @override
  String get setAsAvatar => 'Set as Avatar';

  @override
  String get information => 'Information';

  @override
  String get care => 'Care';

  @override
  String get reminders => 'Reminders';

  @override
  String get events => 'Events';

  @override
  String get gallery => 'Gallery';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get plantDuplicated => 'Plant duplicated';

  @override
  String get plantDeleted => 'Plant deleted';

  @override
  String get searchGreenFriends => 'Search green friends';

  @override
  String get note => 'Note';

  @override
  String get update => 'Update';

  @override
  String get custom => 'custom';

  @override
  String get floraCodex => 'Flora Codex';

  @override
  String get seller => 'Seller';

  @override
  String get remove => 'Remove';

  @override
  String get createEventType => 'Create Event Type';

  @override
  String get selectAColor => 'Select a color';

  @override
  String get select => 'Select';

  @override
  String get whichColorYouWantToUse => 'Which color you want to use?';

  @override
  String get description => 'Description';

  @override
  String get whichIconYouWantToUse => 'Which icon you want to use?';

  @override
  String get filterIcons => 'Filter icons';

  @override
  String get insertAName => 'Insert a name';

  @override
  String get editEventType => 'Edit Event Type';

  @override
  String get eventTypeUpdated => 'Event Type updated';

  @override
  String get areYouSureYouWantToDeleteTheEventTypeAndAllLinkedEvents =>
      'Are you sure you want to delete the event type and all linked events?';

  @override
  String get eventTypeDeleted => 'Event Type deleted';

  @override
  String get createReminder => 'Create Reminder';

  @override
  String get reminderCreated => 'Reminder created';

  @override
  String get whichEventTypeYouWantToSet => 'Which event type you want to set?';

  @override
  String get quantity => 'Quantity';

  @override
  String get whichPlantsYouWantToSet => 'Which plant you want to set?';

  @override
  String get editReminder => 'Edit Reminder';

  @override
  String get reminderUpdated => 'Reminder updated';

  @override
  String get whichEventsYouWantToSet => 'Which events you want to set?';

  @override
  String get reminderDeleted => 'Reminder deleted';

  @override
  String get areYouSureYouWantToDeleteTheReminder =>
      'Are you sure you want to delete the reminder?';

  @override
  String get dataSources => 'Data sources';

  @override
  String get configureTheFloraCodexSettings =>
      'Configure the Flora Codex settings';

  @override
  String get insertTheFloraCodexApiKey => 'Insert the Flora Codex API Key';

  @override
  String get enterApiKey => 'Enter API Key';

  @override
  String get enableDataSource => 'Enable data source';

  @override
  String get apiKey => 'API Key';

  @override
  String get notProvided => 'not porvided';

  @override
  String get appInfo => 'App Info';

  @override
  String get appVersion => 'App version';

  @override
  String get sourceCode => 'Source code';

  @override
  String get support => 'Support ♥️';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable Notifications';

  @override
  String get selectWeekdaysAndTimes => 'Select Weekdays and Times';

  @override
  String get pickTime => 'Pick Time';

  @override
  String get done => 'Done';

  @override
  String get aboutPlantIt => 'About Plant-it';

  @override
  String get manageTheEventTypes => 'Manage the event types';

  @override
  String get manageTheReminders => 'Manage the reminders';

  @override
  String get manageTheDataSources => 'Manage the data sources';

  @override
  String get configureWhenAndIfNotificationsAreReceived =>
      'Configure when and if notifications are received';

  @override
  String get detailsAboutTheApp => 'Details about the app';

  @override
  String get yourSupportHelpsUsGrow => 'Your support helps us grow!';

  @override
  String get supportTheProject => 'Support the project';

  @override
  String get whySupportPlantIt => 'Why Support Plant-it?';

  @override
  String get openSourceProjectThatBenefitsEveryone =>
      'Open-source project that benefits everyone.';

  @override
  String get yourDonationsHelpUsImproveTheApp =>
      'Your donations help us improve the app.';

  @override
  String get supportNewFeaturesAndUpdates =>
      'Support new features and updates.';

  @override
  String get donateNow => 'Donate Now';

  @override
  String get createSpecies => 'Create Species';

  @override
  String get speciesCreated => 'Species created';

  @override
  String get avatar => 'Avatar';

  @override
  String get noAvatar => 'No avatar';

  @override
  String get uploadPhoto => 'Upload photo';

  @override
  String get choosePhoto => 'Choose photo';

  @override
  String get noPhoto => 'No photo';

  @override
  String get useWebImage => 'Use web image';

  @override
  String get url => 'Url';

  @override
  String get light => 'Light';

  @override
  String get humidity => 'Humidity';

  @override
  String get temperature => 'Temperature';

  @override
  String get ph => 'Ph';

  @override
  String get genus => 'Genus';

  @override
  String get family => 'Family';

  @override
  String get synonym => 'Synonym';

  @override
  String get addSynonym => 'Add synonym';

  @override
  String get classification => 'Classification';

  @override
  String get species => 'Species';

  @override
  String get synonyms => 'Synonyms';

  @override
  String get editSpecies => 'Edit Species';

  @override
  String get speciesUpdated => 'Species updated';

  @override
  String get addToCollection => 'Add to collection';

  @override
  String get showNextNotificationsDateTime =>
      'Show next notifications date and time';

  @override
  String get date => 'Date';

  @override
  String get plant => 'Plant';

  @override
  String get low => 'Low';

  @override
  String get medium => 'Medium';

  @override
  String get high => 'High';

  @override
  String get sunlight => 'Sunlight';

  @override
  String get min => 'min';

  @override
  String get max => 'max';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String get color => 'Color';

  @override
  String get red => 'red';

  @override
  String get green => 'green';

  @override
  String get blue => 'blue';

  @override
  String get white => 'white';

  @override
  String get teal => 'teal';

  @override
  String get yellow => 'yellow';

  @override
  String get icon => 'Icon';

  @override
  String get every => 'Every';

  @override
  String get repeatAfter => 'Repeat after';

  @override
  String frequencyEvery(num quantity, String unit) {
    final intl.NumberFormat quantityNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String quantityString = quantityNumberFormat.format(quantity);

    String _temp0 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: ' $quantityString',
      one: '',
    );
    String _temp1 = intl.Intl.selectLogic(
      unit,
      {
        'days': 'day',
        'months': 'month',
        'weeks': 'week',
        'other': 'year',
      },
    );
    String _temp2 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Every$_temp0 $_temp1$_temp2';
  }

  @override
  String afterMessage(num quantity, String unit) {
    final intl.NumberFormat quantityNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String quantityString = quantityNumberFormat.format(quantity);

    String _temp0 = intl.Intl.selectLogic(
      unit,
      {
        'days': 'day',
        'months': 'month',
        'weeks': 'week',
        'other': 'year',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'After $quantityString $_temp0$_temp1';
  }

  @override
  String frequency(num quantity, String unit) {
    final intl.NumberFormat quantityNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String quantityString = quantityNumberFormat.format(quantity);

    String _temp0 = intl.Intl.selectLogic(
      unit,
      {
        'days': 'day',
        'months': 'month',
        'weeks': 'week',
        'other': 'year',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$quantityString $_temp0$_temp1';
  }

  @override
  String get day => 'day';

  @override
  String get week => 'week';

  @override
  String get month => 'month';

  @override
  String get year => 'year';

  @override
  String reminderDescription(
      num quantity, String unit, DateTime startDate, String endDate) {
    final intl.DateFormat startDateDateFormat = intl.DateFormat.yMd(localeName);
    final String startDateString = startDateDateFormat.format(startDate);

    final intl.NumberFormat quantityNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String quantityString = quantityNumberFormat.format(quantity);

    String _temp0 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: ' $quantityString',
      one: '',
    );
    String _temp1 = intl.Intl.selectLogic(
      unit,
      {
        'days': 'day',
        'months': 'month',
        'weeks': 'week',
        'other': 'years',
      },
    );
    String _temp2 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 's',
      one: '',
    );
    String _temp3 = intl.Intl.selectLogic(
      endDate,
      {
        'null': '',
        'other': ' to $endDate',
      },
    );
    return 'Every$_temp0 $_temp1$_temp2 from $startDateString$_temp3';
  }

  @override
  String get start => 'Start';

  @override
  String plantClassificationInfo(
      String name, String species, String genus, String family) {
    String _temp0 = intl.Intl.selectLogic(
      genus,
      {
        'null': '',
        'other': ', genus |$genus|',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      family,
      {
        'null': '',
        'other': ', family |$family|',
      },
    );
    return '$name is a plant of species |$species|$_temp0$_temp1.';
  }

  @override
  String speciesSynonyms(String synonyms, String species) {
    String _temp0 = intl.Intl.selectLogic(
      synonyms,
      {
        'null': '$species has no synonyms',
        'other': '$species is also known as: $synonyms',
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
        'null': 'uknown',
        'other': '|$genus|',
      },
    );
    String _temp1 = intl.Intl.selectLogic(
      family,
      {
        'null': 'uknown',
        'other': '|$family|',
      },
    );
    return '$species is a species of genus $_temp0 and family $_temp1.';
  }

  @override
  String get eventType => 'Event Type';

  @override
  String get end => 'End';

  @override
  String get databaseAndCache => 'Database and Cache';

  @override
  String get manageDatabaseAndCache => 'Manage Database and Cache settings';

  @override
  String get clearCache => 'Clear the Cache';

  @override
  String get cacheCleaned => 'Cache cleaned';

  @override
  String get noSynonyms => 'No known synonyms';

  @override
  String get areYouSureYouWantToDeleteThisPlant =>
      'Are you sure you want to delete this plant?';

  @override
  String get areYouSureYouWantToDeleteThisSpecies =>
      'Are you sure you want to delete this species and all of your related plants?';

  @override
  String get speciesDeleted => 'Species deleted';

  @override
  String get noPlantsFound => 'No plants found';

  @override
  String get yourPlantWillAppearHere =>
      'Your plants will appear here when once you add them into your collection';

  @override
  String get howToAddPlants => 'How to add plants';

  @override
  String get addPlantInstruction =>
      'This app works with plants from various species.\n\nYou can add a new plant by first searching for the species (or adding a new one) and then linking a plant to it.\n\nTo get started, search for a species.';

  @override
  String get searchASpecies => 'Search a species';

  @override
  String get noSpeciesFound => 'No species found';

  @override
  String get searchAndAddSpeciesInstructions =>
      'You can add a new species, or you can connect the app to a service to access additional species.';

  @override
  String get connectToAService => 'Connect to a service';

  @override
  String get noInfoAvailable => 'No info available';

  @override
  String get noReminder =>
      'No reminders found.\n\nCreate a new reminder for your plants to receive notifications and see the next actions you need to take.';

  @override
  String get today => 'Today';

  @override
  String get tomorrow => 'Tomorrow';

  @override
  String get yesterday => 'Yesterday';

  @override
  String inTime(num quantity, String unit) {
    final intl.NumberFormat quantityNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String quantityString = quantityNumberFormat.format(quantity);

    String _temp0 = intl.Intl.selectLogic(
      unit,
      {
        'days': 'day',
        'weeks': 'week',
        'months': 'month',
        'other': 'year',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'in $quantityString $_temp0$_temp1';
  }

  @override
  String agoTime(num quantity, String unit) {
    final intl.NumberFormat quantityNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String quantityString = quantityNumberFormat.format(quantity);

    String _temp0 = intl.Intl.selectLogic(
      unit,
      {
        'days': 'day',
        'weeks': 'week',
        'months': 'month',
        'other': 'year',
      },
    );
    String _temp1 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$quantityString $_temp0$_temp1 ago';
  }
}
