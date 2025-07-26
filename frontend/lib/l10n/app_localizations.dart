import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('uk'),
    Locale('zh'),
  ];

  /// No description provided for @enterValue.
  ///
  /// In en, this message translates to:
  /// **'Please enter a value'**
  String get enterValue;

  /// No description provided for @enterValidURL.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get enterValidURL;

  /// No description provided for @go.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get go;

  /// No description provided for @noBackend.
  ///
  /// In en, this message translates to:
  /// **'Cannot connect to the server'**
  String get noBackend;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get ok;

  /// No description provided for @serverURL.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverURL;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @badCredentials.
  ///
  /// In en, this message translates to:
  /// **'Bad credentials'**
  String get badCredentials;

  /// No description provided for @loginMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome back on'**
  String get loginMessage;

  /// No description provided for @signupMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome on'**
  String get signupMessage;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Plant-it'**
  String get appName;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @areYouNew.
  ///
  /// In en, this message translates to:
  /// **'Are you new?'**
  String get areYouNew;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @usernameSize.
  ///
  /// In en, this message translates to:
  /// **'Username length must be between 3 and 20 characters'**
  String get usernameSize;

  /// No description provided for @passwordSize.
  ///
  /// In en, this message translates to:
  /// **'Password length must be between 6 and 20 characters'**
  String get passwordSize;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @alreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Already registered?'**
  String get alreadyRegistered;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @generalError.
  ///
  /// In en, this message translates to:
  /// **'Error while performing the operation'**
  String get generalError;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @insertBackendURL.
  ///
  /// In en, this message translates to:
  /// **'Hi friend! Let\'s make magic happen, start by setting up your server URL.'**
  String get insertBackendURL;

  /// No description provided for @loginTagline.
  ///
  /// In en, this message translates to:
  /// **'Explore, learn, and cultivate!'**
  String get loginTagline;

  /// No description provided for @singupTagline.
  ///
  /// In en, this message translates to:
  /// **'Let\'s grow together!'**
  String get singupTagline;

  /// No description provided for @sentOTPCode.
  ///
  /// In en, this message translates to:
  /// **'Please insert the code sent by email at: '**
  String get sentOTPCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCode;

  /// No description provided for @otpCode.
  ///
  /// In en, this message translates to:
  /// **'OTP code'**
  String get otpCode;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Beep boop beep... Loading data from the server!'**
  String get splashLoading;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello, {userName}'**
  String hello(String userName);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get yesterday;

  /// No description provided for @nDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{day} other{days}} ago'**
  String nDaysAgo(num count);

  /// No description provided for @nDaysInFuture.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{day} other{days}} in future (whaaat?)'**
  String nDaysInFuture(num count);

  /// No description provided for @nMonthsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{month} other{months}} ago'**
  String nMonthsAgo(num count);

  /// No description provided for @nYearsAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{year} other{years}} ago'**
  String nYearsAgo(num count);

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @plants.
  ///
  /// In en, this message translates to:
  /// **'Plants'**
  String get plants;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @seeding.
  ///
  /// In en, this message translates to:
  /// **'seeding'**
  String get seeding;

  /// No description provided for @watering.
  ///
  /// In en, this message translates to:
  /// **'watering'**
  String get watering;

  /// No description provided for @fertilizing.
  ///
  /// In en, this message translates to:
  /// **'fertilizing'**
  String get fertilizing;

  /// No description provided for @biostimulating.
  ///
  /// In en, this message translates to:
  /// **'biostimulating'**
  String get biostimulating;

  /// No description provided for @misting.
  ///
  /// In en, this message translates to:
  /// **'misting'**
  String get misting;

  /// No description provided for @transplanting.
  ///
  /// In en, this message translates to:
  /// **'transplanting'**
  String get transplanting;

  /// No description provided for @water_changing.
  ///
  /// In en, this message translates to:
  /// **'water changing'**
  String get water_changing;

  /// No description provided for @observation.
  ///
  /// In en, this message translates to:
  /// **'observation'**
  String get observation;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'treatment'**
  String get treatment;

  /// No description provided for @propagating.
  ///
  /// In en, this message translates to:
  /// **'propagating'**
  String get propagating;

  /// No description provided for @pruning.
  ///
  /// In en, this message translates to:
  /// **'pruning'**
  String get pruning;

  /// No description provided for @repotting.
  ///
  /// In en, this message translates to:
  /// **'repotting'**
  String get repotting;

  /// No description provided for @recents.
  ///
  /// In en, this message translates to:
  /// **'Recents'**
  String get recents;

  /// No description provided for @addNewEvent.
  ///
  /// In en, this message translates to:
  /// **'Add new event'**
  String get addNewEvent;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDate;

  /// No description provided for @selectEvents.
  ///
  /// In en, this message translates to:
  /// **'Select events'**
  String get selectEvents;

  /// No description provided for @selectPlants.
  ///
  /// In en, this message translates to:
  /// **'Select plants'**
  String get selectPlants;

  /// No description provided for @nEventsCreated.
  ///
  /// In en, this message translates to:
  /// **'Created {count} new {count, plural, =1{event} other{events}}'**
  String nEventsCreated(num count);

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @enterNote.
  ///
  /// In en, this message translates to:
  /// **'Enter note'**
  String get enterNote;

  /// No description provided for @selectAtLeastOnePlant.
  ///
  /// In en, this message translates to:
  /// **'Select at least one plant'**
  String get selectAtLeastOnePlant;

  /// No description provided for @selectAtLeastOneEvent.
  ///
  /// In en, this message translates to:
  /// **'Select at least one event'**
  String get selectAtLeastOneEvent;

  /// No description provided for @eventSuccessfullyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Event updated successfully'**
  String get eventSuccessfullyUpdated;

  /// No description provided for @editEvent.
  ///
  /// In en, this message translates to:
  /// **'Edit event'**
  String get editEvent;

  /// No description provided for @eventSuccessfullyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Event deleted successfully'**
  String get eventSuccessfullyDeleted;

  /// No description provided for @noInfoAvailable.
  ///
  /// In en, this message translates to:
  /// **'No info available'**
  String get noInfoAvailable;

  /// No description provided for @species.
  ///
  /// In en, this message translates to:
  /// **'Species'**
  String get species;

  /// No description provided for @plant.
  ///
  /// In en, this message translates to:
  /// **'Plant'**
  String get plant;

  /// No description provided for @scientificClassification.
  ///
  /// In en, this message translates to:
  /// **'Scientific classification'**
  String get scientificClassification;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @genus.
  ///
  /// In en, this message translates to:
  /// **'Genus'**
  String get genus;

  /// No description provided for @synonyms.
  ///
  /// In en, this message translates to:
  /// **'Synonyms'**
  String get synonyms;

  /// No description provided for @care.
  ///
  /// In en, this message translates to:
  /// **'Care'**
  String get care;

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

  /// No description provided for @maxTemp.
  ///
  /// In en, this message translates to:
  /// **'Maximum temperature'**
  String get maxTemp;

  /// No description provided for @minTemp.
  ///
  /// In en, this message translates to:
  /// **'Minimum temperature'**
  String get minTemp;

  /// No description provided for @minPh.
  ///
  /// In en, this message translates to:
  /// **'Minimum ph'**
  String get minPh;

  /// No description provided for @maxPh.
  ///
  /// In en, this message translates to:
  /// **'Maximum ph'**
  String get maxPh;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @addPhotos.
  ///
  /// In en, this message translates to:
  /// **'Add photos'**
  String get addPhotos;

  /// No description provided for @addEvents.
  ///
  /// In en, this message translates to:
  /// **'Add events'**
  String get addEvents;

  /// No description provided for @modifyPlant.
  ///
  /// In en, this message translates to:
  /// **'Modify plant'**
  String get modifyPlant;

  /// No description provided for @removePlant.
  ///
  /// In en, this message translates to:
  /// **'Remove plant'**
  String get removePlant;

  /// No description provided for @useBirthday.
  ///
  /// In en, this message translates to:
  /// **'Use birthday'**
  String get useBirthday;

  /// No description provided for @birthday.
  ///
  /// In en, this message translates to:
  /// **'Birthday'**
  String get birthday;

  /// No description provided for @avatar.
  ///
  /// In en, this message translates to:
  /// **'Avatar'**
  String get avatar;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @stats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// No description provided for @eventStats.
  ///
  /// In en, this message translates to:
  /// **'Events stats'**
  String get eventStats;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @newBorn.
  ///
  /// In en, this message translates to:
  /// **'New born'**
  String get newBorn;

  /// No description provided for @nDays.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{day} other{days}}'**
  String nDays(num count);

  /// No description provided for @nMonths.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{month} other{months}}'**
  String nMonths(num count);

  /// No description provided for @nYears.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{year} other{years}}'**
  String nYears(num count);

  /// No description provided for @nMonthsAndDays.
  ///
  /// In en, this message translates to:
  /// **'{months} {months, plural, =1{month} other{months}}, {days} {days, plural, =1{day} other{days}}'**
  String nMonthsAndDays(num months, num days);

  /// No description provided for @nYearsAndDays.
  ///
  /// In en, this message translates to:
  /// **'{years} {years, plural, =1{year} other{years}}, {days} {days, plural, =1{day} other{days}}'**
  String nYearsAndDays(num years, num days);

  /// No description provided for @nYearsAndMonths.
  ///
  /// In en, this message translates to:
  /// **'{years} {years, plural, =1{year} other{years}}, {months} {months, plural, =1{month} other{months}}'**
  String nYearsAndMonths(num years, num months);

  /// No description provided for @nYearsAndMonthsAndDays.
  ///
  /// In en, this message translates to:
  /// **'{years} {years, plural, =1{year} other{years}}, {months} {months, plural, =1{month} other{months}}, {days} {days, plural, =1{day} other{days}}'**
  String nYearsAndMonthsAndDays(num years, num months, num days);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nOutOf.
  ///
  /// In en, this message translates to:
  /// **'{value} out of {max}'**
  String nOutOf(num value, num max);

  /// No description provided for @temp.
  ///
  /// In en, this message translates to:
  /// **'{value} °C'**
  String temp(num value);

  /// No description provided for @numberOfPhotos.
  ///
  /// In en, this message translates to:
  /// **'Number of photos'**
  String get numberOfPhotos;

  /// No description provided for @numberOfEvents.
  ///
  /// In en, this message translates to:
  /// **'Number of events'**
  String get numberOfEvents;

  /// No description provided for @searchInYourPlants.
  ///
  /// In en, this message translates to:
  /// **'Search in your plants'**
  String get searchInYourPlants;

  /// No description provided for @searchNewGreenFriends.
  ///
  /// In en, this message translates to:
  /// **'Search new green friends'**
  String get searchNewGreenFriends;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @addPlant.
  ///
  /// In en, this message translates to:
  /// **'Add Plant'**
  String get addPlant;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @pleaseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Please confirm'**
  String get pleaseConfirm;

  /// No description provided for @areYouSureToRemoveEvent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to remove the event?'**
  String get areYouSureToRemoveEvent;

  /// No description provided for @areYouSureToRemoveReminder.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to remove the reminder?'**
  String get areYouSureToRemoveReminder;

  /// No description provided for @areYouSureToRemoveSpecies.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to remove the species?'**
  String get areYouSureToRemoveSpecies;

  /// No description provided for @areYouSureToRemovePlant.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to remove the plant?'**
  String get areYouSureToRemovePlant;

  /// No description provided for @purchasedPrice.
  ///
  /// In en, this message translates to:
  /// **'Purchased price'**
  String get purchasedPrice;

  /// No description provided for @seller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @plantUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Plant updated successfully'**
  String get plantUpdatedSuccessfully;

  /// No description provided for @plantCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Plant created successfully'**
  String get plantCreatedSuccessfully;

  /// No description provided for @insertPrice.
  ///
  /// In en, this message translates to:
  /// **'Insert price'**
  String get insertPrice;

  /// No description provided for @noBirthday.
  ///
  /// In en, this message translates to:
  /// **'No birthday'**
  String get noBirthday;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @serverVersion.
  ///
  /// In en, this message translates to:
  /// **'Server version'**
  String get serverVersion;

  /// No description provided for @documentation.
  ///
  /// In en, this message translates to:
  /// **'Documentation'**
  String get documentation;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open source'**
  String get openSource;

  /// No description provided for @reportIssue.
  ///
  /// In en, this message translates to:
  /// **'Report issue'**
  String get reportIssue;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @eventCount.
  ///
  /// In en, this message translates to:
  /// **'Event count'**
  String get eventCount;

  /// No description provided for @plantCount.
  ///
  /// In en, this message translates to:
  /// **'Plant count'**
  String get plantCount;

  /// No description provided for @speciesCount.
  ///
  /// In en, this message translates to:
  /// **'Species count'**
  String get speciesCount;

  /// No description provided for @imageCount.
  ///
  /// In en, this message translates to:
  /// **'Image count'**
  String get imageCount;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPassword;

  /// No description provided for @updatePassword.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get updatePassword;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update profile'**
  String get updateProfile;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPassword;

  /// No description provided for @removeEvent.
  ///
  /// In en, this message translates to:
  /// **'Remove event'**
  String get removeEvent;

  /// No description provided for @appLog.
  ///
  /// In en, this message translates to:
  /// **'App log'**
  String get appLog;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password successfully updated'**
  String get passwordUpdated;

  /// No description provided for @userUpdated.
  ///
  /// In en, this message translates to:
  /// **'User successfully updated'**
  String get userUpdated;

  /// No description provided for @noChangesDetected.
  ///
  /// In en, this message translates to:
  /// **'No changes detected'**
  String get noChangesDetected;

  /// No description provided for @plantDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Plant successfully deleted'**
  String get plantDeletedSuccessfully;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @changeServer.
  ///
  /// In en, this message translates to:
  /// **'Change server'**
  String get changeServer;

  /// No description provided for @serverUpdated.
  ///
  /// In en, this message translates to:
  /// **'Server successfully updated'**
  String get serverUpdated;

  /// No description provided for @changeNotifications.
  ///
  /// In en, this message translates to:
  /// **'Change notifications'**
  String get changeNotifications;

  /// No description provided for @updateNotifications.
  ///
  /// In en, this message translates to:
  /// **'Update notifications'**
  String get updateNotifications;

  /// No description provided for @notificationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Notification successfully updated'**
  String get notificationUpdated;

  /// No description provided for @supportTheProject.
  ///
  /// In en, this message translates to:
  /// **'Support the project'**
  String get supportTheProject;

  /// No description provided for @buyMeACoffee.
  ///
  /// In en, this message translates to:
  /// **'Buy me a coffee'**
  String get buyMeACoffee;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @photosOf.
  ///
  /// In en, this message translates to:
  /// **'Photos of {name}'**
  String photosOf(String name);

  /// No description provided for @nPhoto.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {count} new {count, plural, =1{photo} other{photos}}'**
  String nPhoto(num count);

  /// No description provided for @errorCreatingPlant.
  ///
  /// In en, this message translates to:
  /// **'Error while creating plant'**
  String get errorCreatingPlant;

  /// No description provided for @noImages.
  ///
  /// In en, this message translates to:
  /// **'No images'**
  String get noImages;

  /// No description provided for @errorCreatingSpecies.
  ///
  /// In en, this message translates to:
  /// **'Error while creating species'**
  String get errorCreatingSpecies;

  /// No description provided for @errorUpdatingSpecies.
  ///
  /// In en, this message translates to:
  /// **'Error while updating species'**
  String get errorUpdatingSpecies;

  /// No description provided for @speciesUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Species successfully updated'**
  String get speciesUpdatedSuccessfully;

  /// No description provided for @addCustom.
  ///
  /// In en, this message translates to:
  /// **'Add custom'**
  String get addCustom;

  /// No description provided for @speciesCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Species successfully created'**
  String get speciesCreatedSuccessfully;

  /// No description provided for @uploadPhoto.
  ///
  /// In en, this message translates to:
  /// **'Upload Photo'**
  String get uploadPhoto;

  /// No description provided for @linkURL.
  ///
  /// In en, this message translates to:
  /// **'Link URL'**
  String get linkURL;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @areYouSureToRemovePhoto.
  ///
  /// In en, this message translates to:
  /// **'Are you sure to remove the photo?'**
  String get areYouSureToRemovePhoto;

  /// No description provided for @photoSuccessfullyDeleted.
  ///
  /// In en, this message translates to:
  /// **'Photo deleted successfully'**
  String get photoSuccessfullyDeleted;

  /// No description provided for @errorUpdatingPlant.
  ///
  /// In en, this message translates to:
  /// **'Error updating plant'**
  String get errorUpdatingPlant;

  /// No description provided for @reminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get reminders;

  /// No description provided for @selectStartDate.
  ///
  /// In en, this message translates to:
  /// **'Select start date'**
  String get selectStartDate;

  /// No description provided for @selectEndDate.
  ///
  /// In en, this message translates to:
  /// **'Select end date'**
  String get selectEndDate;

  /// No description provided for @addNewReminder.
  ///
  /// In en, this message translates to:
  /// **'Add new reminder'**
  String get addNewReminder;

  /// No description provided for @noEndDate.
  ///
  /// In en, this message translates to:
  /// **'No end date'**
  String get noEndDate;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @repeatAfter.
  ///
  /// In en, this message translates to:
  /// **'Repeat after'**
  String get repeatAfter;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get addNew;

  /// No description provided for @reminderCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Reminder successfully created'**
  String get reminderCreatedSuccessfully;

  /// No description provided for @startAndEndDateOrderError.
  ///
  /// In en, this message translates to:
  /// **'Start date must be before end date'**
  String get startAndEndDateOrderError;

  /// No description provided for @reminderUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Reminder successfully updated'**
  String get reminderUpdatedSuccessfully;

  /// No description provided for @reminderDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Reminder successfully deleted'**
  String get reminderDeletedSuccessfully;

  /// No description provided for @errorResettingPassword.
  ///
  /// In en, this message translates to:
  /// **'Error while resetting password'**
  String get errorResettingPassword;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPassword;

  /// No description provided for @resetPasswordHeader.
  ///
  /// In en, this message translates to:
  /// **'Insert the username below in order to send a reset password request'**
  String get resetPasswordHeader;

  /// No description provided for @editReminder.
  ///
  /// In en, this message translates to:
  /// **'Edit reminder'**
  String get editReminder;

  /// No description provided for @ntfyServerUrl.
  ///
  /// In en, this message translates to:
  /// **'Ntfy server URL'**
  String get ntfyServerUrl;

  /// No description provided for @ntfyServerTopic.
  ///
  /// In en, this message translates to:
  /// **'Ntfy server topic'**
  String get ntfyServerTopic;

  /// No description provided for @ntfyServerUsername.
  ///
  /// In en, this message translates to:
  /// **'Ntfy server username'**
  String get ntfyServerUsername;

  /// No description provided for @ntfyServerPassword.
  ///
  /// In en, this message translates to:
  /// **'Ntfy server password'**
  String get ntfyServerPassword;

  /// No description provided for @ntfyServerToken.
  ///
  /// In en, this message translates to:
  /// **'Ntfy server token'**
  String get ntfyServerToken;

  /// No description provided for @enterValidTopic.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid topic'**
  String get enterValidTopic;

  /// No description provided for @ntfySettings.
  ///
  /// In en, this message translates to:
  /// **'Ntfy settings'**
  String get ntfySettings;

  /// No description provided for @ntfySettingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Ntfy settings correctly updated'**
  String get ntfySettingsUpdated;

  /// No description provided for @modifySpecies.
  ///
  /// In en, this message translates to:
  /// **'Modify species'**
  String get modifySpecies;

  /// No description provided for @removeSpecies.
  ///
  /// In en, this message translates to:
  /// **'Delete species'**
  String get removeSpecies;

  /// No description provided for @speciesDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Species successfully deleted'**
  String get speciesDeletedSuccessfully;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @ops.
  ///
  /// In en, this message translates to:
  /// **'Ops!'**
  String get ops;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get changeLanguage;

  /// No description provided for @gotifyServerUrl.
  ///
  /// In en, this message translates to:
  /// **'Gotify server URL'**
  String get gotifyServerUrl;

  /// No description provided for @gotifyServerToken.
  ///
  /// In en, this message translates to:
  /// **'Gotify server token'**
  String get gotifyServerToken;

  /// No description provided for @gotifySettings.
  ///
  /// In en, this message translates to:
  /// **'Gotify settings'**
  String get gotifySettings;

  /// No description provided for @gotifySettingsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Gotify settings correctly updated'**
  String get gotifySettingsUpdated;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get fromDate;

  /// No description provided for @frequencyEvery.
  ///
  /// In en, this message translates to:
  /// **'every {amount} {unit}'**
  String frequencyEvery(num amount, String unit);

  /// No description provided for @day.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{day} other{days}}'**
  String day(num count);

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{week} other{weeks}}'**
  String week(num count);

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{month} other{months}}'**
  String month(num count);

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{year} other{years}}'**
  String year(num count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'cs',
    'da',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'nl',
    'pl',
    'pt',
    'ru',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
