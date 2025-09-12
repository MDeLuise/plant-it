import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L
/// returned by `L.of(context)`.
///
/// Applications need to include `L.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L.localizationsDelegates,
///   supportedLocales: L.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L.supportedLocales
/// property.
abstract class L {
  L(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L of(BuildContext context) {
    return Localizations.of<L>(context, L)!;
  }

  static const LocalizationsDelegate<L> delegate = _LDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @searchYourPlants.
  ///
  /// In en, this message translates to:
  /// **'Search your plants'**
  String get searchYourPlants;

  /// No description provided for @filterActivities.
  ///
  /// In en, this message translates to:
  /// **'Filter Activities'**
  String get filterActivities;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @eventTypes.
  ///
  /// In en, this message translates to:
  /// **'Event Types'**
  String get eventTypes;

  /// A plural event type message
  ///
  /// In en, this message translates to:
  /// **'{count} event type{count, plural, =1 {} other {s}}'**
  String nEventTypes(num count);

  /// No description provided for @whichEventsYouWantToAdd.
  ///
  /// In en, this message translates to:
  /// **'Which events you want to add?'**
  String get whichEventsYouWantToAdd;

  /// No description provided for @plants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get plants;

  /// A plural plant message
  ///
  /// In en, this message translates to:
  /// **'{count} plant{count, plural, =1 {} other {s}}'**
  String nPlants(num count);

  /// No description provided for @whichPlantsYouWantToAdd.
  ///
  /// In en, this message translates to:
  /// **'Which plants you want to add?'**
  String get whichPlantsYouWantToAdd;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @areYouSureYouWantToDeleteThisEvent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this event?'**
  String get areYouSureYouWantToDeleteThisEvent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @eventDeleted.
  ///
  /// In en, this message translates to:
  /// **'Event deleted'**
  String get eventDeleted;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @eventCreated.
  ///
  /// In en, this message translates to:
  /// **'Event created'**
  String get eventCreated;

  /// No description provided for @markDone.
  ///
  /// In en, this message translates to:
  /// **'Mark done'**
  String get markDone;

  /// No description provided for @reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminder;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @createEvent.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get createEvent;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @eventsCreated.
  ///
  /// In en, this message translates to:
  /// **'Events created'**
  String get eventsCreated;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @editTheEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit the event'**
  String get editTheEvent;

  /// No description provided for @eventUpdated.
  ///
  /// In en, this message translates to:
  /// **'Event updated'**
  String get eventUpdated;

  /// No description provided for @selectTheEventType.
  ///
  /// In en, this message translates to:
  /// **'Select the event type'**
  String get selectTheEventType;

  /// No description provided for @selectThePlant.
  ///
  /// In en, this message translates to:
  /// **'Select the plant'**
  String get selectThePlant;

  /// No description provided for @nextActions.
  ///
  /// In en, this message translates to:
  /// **'Next actions'**
  String get nextActions;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @addPlant.
  ///
  /// In en, this message translates to:
  /// **'Add Plant'**
  String get addPlant;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @plantAdded.
  ///
  /// In en, this message translates to:
  /// **'Plant added'**
  String get plantAdded;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @editPlant.
  ///
  /// In en, this message translates to:
  /// **'Edit Plant'**
  String get editPlant;

  /// No description provided for @plantUpdated.
  ///
  /// In en, this message translates to:
  /// **'Plant updated'**
  String get plantUpdated;

  /// No description provided for @deleteImage.
  ///
  /// In en, this message translates to:
  /// **'Delete image'**
  String get deleteImage;

  /// No description provided for @areYouSureYouWantToDeleteThisImage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this image?'**
  String get areYouSureYouWantToDeleteThisImage;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @imageInfo.
  ///
  /// In en, this message translates to:
  /// **'Image info'**
  String get imageInfo;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @unsetAsAvatar.
  ///
  /// In en, this message translates to:
  /// **'Unset as Avatar'**
  String get unsetAsAvatar;

  /// No description provided for @setAsAvatar.
  ///
  /// In en, this message translates to:
  /// **'Set as Avatar'**
  String get setAsAvatar;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @care.
  ///
  /// In en, this message translates to:
  /// **'Care'**
  String get care;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @plantDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Plant duplicated'**
  String get plantDuplicated;

  /// No description provided for @plantDeleted.
  ///
  /// In en, this message translates to:
  /// **'Plant deleted'**
  String get plantDeleted;

  /// No description provided for @searchGreenFriends.
  ///
  /// In en, this message translates to:
  /// **'Search green friends'**
  String get searchGreenFriends;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'custom'**
  String get custom;

  /// No description provided for @floraCodex.
  ///
  /// In en, this message translates to:
  /// **'Flora Codex'**
  String get floraCodex;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @createEventType.
  ///
  /// In en, this message translates to:
  /// **'Create Event Type'**
  String get createEventType;

  /// No description provided for @selectAColor.
  ///
  /// In en, this message translates to:
  /// **'Select a color'**
  String get selectAColor;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @whichColorYouWantToUse.
  ///
  /// In en, this message translates to:
  /// **'Which color you want to use?'**
  String get whichColorYouWantToUse;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @whichIconYouWantToUse.
  ///
  /// In en, this message translates to:
  /// **'Which icon you want to use?'**
  String get whichIconYouWantToUse;

  /// No description provided for @filterIcons.
  ///
  /// In en, this message translates to:
  /// **'Filter icons'**
  String get filterIcons;

  /// No description provided for @insertAName.
  ///
  /// In en, this message translates to:
  /// **'Insert a name'**
  String get insertAName;

  /// No description provided for @editEventType.
  ///
  /// In en, this message translates to:
  /// **'Edit Event Type'**
  String get editEventType;

  /// No description provided for @eventTypeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Event Type updated'**
  String get eventTypeUpdated;

  /// No description provided for @areYouSureYouWantToDeleteTheEventTypeAndAllLinkedEvents.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the event type and all linked events?'**
  String get areYouSureYouWantToDeleteTheEventTypeAndAllLinkedEvents;

  /// No description provided for @eventTypeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Event Type deleted'**
  String get eventTypeDeleted;

  /// No description provided for @createReminder.
  ///
  /// In en, this message translates to:
  /// **'Create Reminder'**
  String get createReminder;

  /// No description provided for @reminderCreated.
  ///
  /// In en, this message translates to:
  /// **'Reminder created'**
  String get reminderCreated;

  /// No description provided for @whichEventTypeYouWantToSet.
  ///
  /// In en, this message translates to:
  /// **'Which event type you want to set?'**
  String get whichEventTypeYouWantToSet;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @whichPlantsYouWantToSet.
  ///
  /// In en, this message translates to:
  /// **'Which plant you want to set?'**
  String get whichPlantsYouWantToSet;

  /// No description provided for @editReminder.
  ///
  /// In en, this message translates to:
  /// **'Edit Reminder'**
  String get editReminder;

  /// No description provided for @reminderUpdated.
  ///
  /// In en, this message translates to:
  /// **'Reminder updated'**
  String get reminderUpdated;

  /// No description provided for @whichEventsYouWantToSet.
  ///
  /// In en, this message translates to:
  /// **'Which events you want to set?'**
  String get whichEventsYouWantToSet;

  /// No description provided for @reminderDeleted.
  ///
  /// In en, this message translates to:
  /// **'Reminder deleted'**
  String get reminderDeleted;

  /// No description provided for @areYouSureYouWantToDeleteTheReminder.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the reminder?'**
  String get areYouSureYouWantToDeleteTheReminder;

  /// No description provided for @dataSources.
  ///
  /// In en, this message translates to:
  /// **'Data sources'**
  String get dataSources;

  /// No description provided for @configureTheFloraCodexSettings.
  ///
  /// In en, this message translates to:
  /// **'Configure the Flora Codex settings'**
  String get configureTheFloraCodexSettings;

  /// No description provided for @insertTheFloraCodexApiKey.
  ///
  /// In en, this message translates to:
  /// **'Insert the Flora Codex API Key'**
  String get insertTheFloraCodexApiKey;

  /// No description provided for @enterApiKey.
  ///
  /// In en, this message translates to:
  /// **'Enter API Key'**
  String get enterApiKey;

  /// No description provided for @enableDataSource.
  ///
  /// In en, this message translates to:
  /// **'Enable data source'**
  String get enableDataSource;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// No description provided for @notProvided.
  ///
  /// In en, this message translates to:
  /// **'not porvided'**
  String get notProvided;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfo;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @sourceCode.
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get sourceCode;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support ♥️'**
  String get support;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enableNotifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enableNotifications;

  /// No description provided for @selectWeekdaysAndTimes.
  ///
  /// In en, this message translates to:
  /// **'Select Weekdays and Times'**
  String get selectWeekdaysAndTimes;

  /// No description provided for @pickTime.
  ///
  /// In en, this message translates to:
  /// **'Pick Time'**
  String get pickTime;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @aboutPlantIt.
  ///
  /// In en, this message translates to:
  /// **'About Plant-it'**
  String get aboutPlantIt;

  /// No description provided for @manageTheEventTypes.
  ///
  /// In en, this message translates to:
  /// **'Manage the event types'**
  String get manageTheEventTypes;

  /// No description provided for @manageTheReminders.
  ///
  /// In en, this message translates to:
  /// **'Manage the reminders'**
  String get manageTheReminders;

  /// No description provided for @manageTheDataSources.
  ///
  /// In en, this message translates to:
  /// **'Manage the data sources'**
  String get manageTheDataSources;

  /// No description provided for @configureWhenAndIfNotificationsAreReceived.
  ///
  /// In en, this message translates to:
  /// **'Configure when and if notifications are received'**
  String get configureWhenAndIfNotificationsAreReceived;

  /// No description provided for @detailsAboutTheApp.
  ///
  /// In en, this message translates to:
  /// **'Details about the app'**
  String get detailsAboutTheApp;

  /// No description provided for @yourSupportHelpsUsGrow.
  ///
  /// In en, this message translates to:
  /// **'Your support helps us grow!'**
  String get yourSupportHelpsUsGrow;

  /// No description provided for @supportTheProject.
  ///
  /// In en, this message translates to:
  /// **'Support the project'**
  String get supportTheProject;

  /// No description provided for @whySupportPlantIt.
  ///
  /// In en, this message translates to:
  /// **'Why Support Plant-it?'**
  String get whySupportPlantIt;

  /// No description provided for @openSourceProjectThatBenefitsEveryone.
  ///
  /// In en, this message translates to:
  /// **'Open-source project that benefits everyone.'**
  String get openSourceProjectThatBenefitsEveryone;

  /// No description provided for @yourDonationsHelpUsImproveTheApp.
  ///
  /// In en, this message translates to:
  /// **'Your donations help us improve the app.'**
  String get yourDonationsHelpUsImproveTheApp;

  /// No description provided for @supportNewFeaturesAndUpdates.
  ///
  /// In en, this message translates to:
  /// **'Support new features and updates.'**
  String get supportNewFeaturesAndUpdates;

  /// No description provided for @donateNow.
  ///
  /// In en, this message translates to:
  /// **'Donate Now'**
  String get donateNow;

  /// No description provided for @createSpecies.
  ///
  /// In en, this message translates to:
  /// **'Create Species'**
  String get createSpecies;

  /// No description provided for @speciesCreated.
  ///
  /// In en, this message translates to:
  /// **'Species created'**
  String get speciesCreated;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @noAvatar.
  ///
  /// In en, this message translates to:
  /// **'No avatar'**
  String get noAvatar;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload photo'**
  String get uploadPhoto;

  /// No description provided for @choosePhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get choosePhoto;

  /// No description provided for @noPhoto.
  ///
  /// In en, this message translates to:
  /// **'No photo'**
  String get noPhoto;

  /// No description provided for @useWebImage.
  ///
  /// In en, this message translates to:
  /// **'Use web image'**
  String get useWebImage;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'Url'**
  String get url;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @ph.
  ///
  /// In en, this message translates to:
  /// **'Ph'**
  String get ph;

  /// No description provided for @genus.
  ///
  /// In en, this message translates to:
  /// **'Genus'**
  String get genus;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @synonym.
  ///
  /// In en, this message translates to:
  /// **'Synonym'**
  String get synonym;

  /// No description provided for @addSynonym.
  ///
  /// In en, this message translates to:
  /// **'Add synonym'**
  String get addSynonym;

  /// No description provided for @classification.
  ///
  /// In en, this message translates to:
  /// **'Classification'**
  String get classification;

  /// No description provided for @species.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get species;

  /// No description provided for @synonyms.
  ///
  /// In en, this message translates to:
  /// **'Synonyms'**
  String get synonyms;

  /// No description provided for @editSpecies.
  ///
  /// In en, this message translates to:
  /// **'Edit Species'**
  String get editSpecies;

  /// No description provided for @speciesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Species updated'**
  String get speciesUpdated;

  /// No description provided for @addToCollection.
  ///
  /// In en, this message translates to:
  /// **'Add to collection'**
  String get addToCollection;

  /// No description provided for @showNextNotificationsDateTime.
  ///
  /// In en, this message translates to:
  /// **'Show next notifications date and time'**
  String get showNextNotificationsDateTime;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @plant.
  ///
  /// In en, this message translates to:
  /// **'Plant'**
  String get plant;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// No description provided for @sunlight.
  ///
  /// In en, this message translates to:
  /// **'Sunlight'**
  String get sunlight;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'max'**
  String get max;

  /// An erro with a message
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @red.
  ///
  /// In en, this message translates to:
  /// **'red'**
  String get red;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'green'**
  String get green;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'blue'**
  String get blue;

  /// No description provided for @white.
  ///
  /// In en, this message translates to:
  /// **'white'**
  String get white;

  /// No description provided for @teal.
  ///
  /// In en, this message translates to:
  /// **'teal'**
  String get teal;

  /// No description provided for @yellow.
  ///
  /// In en, this message translates to:
  /// **'yellow'**
  String get yellow;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @every.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get every;

  /// No description provided for @repeatAfter.
  ///
  /// In en, this message translates to:
  /// **'Repeat after'**
  String get repeatAfter;

  /// A representation of repeat after
  ///
  /// In en, this message translates to:
  /// **'{quantity} {unit}{quantity, plural, =1{} other {s}}'**
  String repeatAfterMessage(num quantity, String unit);

  /// A representation of frequency
  ///
  /// In en, this message translates to:
  /// **'Every {quantity} {unit}{quantity, plural, =1 {} other {s}}'**
  String frequencyMessage(num quantity, String unit);

  /// A representation of after
  ///
  /// In en, this message translates to:
  /// **'After {quantity} {unit}{quantity, plural, =1 {} other {s}}'**
  String afterMessage(num quantity, String unit);

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get day;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get month;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get year;

  /// A description of reminder
  ///
  /// In en, this message translates to:
  /// **'Every {quantity} {unit}{quantity, plural, =1{} other {s}} from {startDate}{endDate, select, null {} other { to {endDate}}}'**
  String reminderDescription(
      num quantity, String unit, DateTime startDate, String endDate);

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// A description of a plant classification
  ///
  /// In en, this message translates to:
  /// **'{name} is a plant of species |{species}|{genus, select, null {} other {, genus |{genus}|}}{family, select, null {} other {, family |{family}|}}.'**
  String plantClassificationInfo(
      String name, String species, String genus, String family);

  /// A list of species synonyms
  ///
  /// In en, this message translates to:
  /// **'{synonyms, select, null {{species} has no synonyms} other {{species} is also known as: {synonyms}}}.'**
  String speciesSynonyms(String synonyms, String species);

  /// A description of a plant classification
  ///
  /// In en, this message translates to:
  /// **'{species} is a species of genus {genus, select, null {uknown} other {|{genus}|}} and family {family, select, null {uknown} other {|{family}|}}.'**
  String speciesClassificationInfo(String species, String genus, String family);

  /// No description provided for @eventType.
  ///
  /// In en, this message translates to:
  /// **'Event Type'**
  String get eventType;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @databaseAndCache.
  ///
  /// In en, this message translates to:
  /// **'Database and Cache'**
  String get databaseAndCache;

  /// No description provided for @manageDatabaseAndCache.
  ///
  /// In en, this message translates to:
  /// **'Manage Database and Cache settings'**
  String get manageDatabaseAndCache;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear the Cache'**
  String get clearCache;

  /// No description provided for @cacheCleaned.
  ///
  /// In en, this message translates to:
  /// **'Cache cleaned'**
  String get cacheCleaned;

  /// No description provided for @noSynonyms.
  ///
  /// In en, this message translates to:
  /// **'No known synonyms'**
  String get noSynonyms;

  /// No description provided for @areYouSureYouWantToDeleteThisPlant.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this plant?'**
  String get areYouSureYouWantToDeleteThisPlant;

  /// No description provided for @areYouSureYouWantToDeleteThisSpecies.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this species and all of your related plants?'**
  String get areYouSureYouWantToDeleteThisSpecies;

  /// No description provided for @speciesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Species deleted'**
  String get speciesDeleted;

  /// No description provided for @noPlantsFound.
  ///
  /// In en, this message translates to:
  /// **'No plants found'**
  String get noPlantsFound;

  /// No description provided for @yourPlantWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Your plants will appear here when once you add them into your collection'**
  String get yourPlantWillAppearHere;

  /// No description provided for @howToAddPlants.
  ///
  /// In en, this message translates to:
  /// **'How to add plants'**
  String get howToAddPlants;

  /// No description provided for @addPlantInstruction.
  ///
  /// In en, this message translates to:
  /// **'This app works with plants from various species.\n\nYou can add a new plant by first searching for the species (or adding a new one) and then linking a plant to it.\n\nTo get started, search for a species.'**
  String get addPlantInstruction;

  /// No description provided for @searchASpecies.
  ///
  /// In en, this message translates to:
  /// **'Search a species'**
  String get searchASpecies;
}

class _LDelegate extends LocalizationsDelegate<L> {
  const _LDelegate();

  @override
  Future<L> load(Locale locale) {
    return SynchronousFuture<L>(lookupL(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_LDelegate old) => false;
}

L lookupL(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return LEn();
    case 'it':
      return LIt();
  }

  throw FlutterError(
      'L.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
