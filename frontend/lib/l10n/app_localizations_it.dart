// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get searchYourPlants => 'Cerca nelle tue piante';

  @override
  String get filterActivities => 'Filtra Attività';

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
      other: '$countString event types',
      one: '1 event type',
    );
    return '$_temp0';
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
      other: '$countString plants',
      one: '1 plant',
    );
    return '$_temp0';
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
}
