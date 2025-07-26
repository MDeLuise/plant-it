// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get enterValue => 'Please enter a value';

  @override
  String get enterValidURL => 'Please enter a valid URL';

  @override
  String get go => 'Continue';

  @override
  String get noBackend => 'Cannot connect to the server';

  @override
  String get ok => 'Ok';

  @override
  String get serverURL => 'Server URL';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get badCredentials => 'Bad credentials';

  @override
  String get loginMessage => 'Welcome back on';

  @override
  String get signupMessage => 'Welcome on';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get areYouNew => 'Are you new?';

  @override
  String get createAccount => 'Create an account';

  @override
  String get email => 'Email';

  @override
  String get usernameSize =>
      'Username length must be between 3 and 20 characters';

  @override
  String get passwordSize =>
      'Password length must be between 6 and 20 characters';

  @override
  String get enterValidEmail => 'Please enter a valid email';

  @override
  String get alreadyRegistered => 'Already registered?';

  @override
  String get signup => 'Signup';

  @override
  String get generalError => 'Error while performing the operation';

  @override
  String get error => 'Error';

  @override
  String get details => 'Details';

  @override
  String get insertBackendURL =>
      'Hi friend! Let\'s make magic happen, start by setting up your server URL.';

  @override
  String get loginTagline => 'Explore, learn, and cultivate!';

  @override
  String get singupTagline => 'Let\'s grow together!';

  @override
  String get sentOTPCode => 'Please insert the code sent by email at: ';

  @override
  String get verify => 'Verify';

  @override
  String get resendCode => 'Resend code';

  @override
  String get otpCode => 'OTP code';

  @override
  String get splashLoading => 'Beep boop beep... Loading data from the server!';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String hello(String userName) {
    return 'Hello, $userName';
  }

  @override
  String get search => 'Search';

  @override
  String get today => 'today';

  @override
  String get yesterday => 'yesterday';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$countString $_temp0 ago';
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
      other: 'days',
      one: 'day',
    );
    return '$countString $_temp0 in future (whaaat?)';
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
      other: 'months',
      one: 'month',
    );
    return '$countString $_temp0 ago';
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
      other: 'years',
      one: 'year',
    );
    return '$countString $_temp0 ago';
  }

  @override
  String get events => 'Events';

  @override
  String get plants => 'Plants';

  @override
  String get or => 'or';

  @override
  String get filter => 'Filter';

  @override
  String get seeding => 'seeding';

  @override
  String get watering => 'watering';

  @override
  String get fertilizing => 'fertilizing';

  @override
  String get biostimulating => 'biostimulating';

  @override
  String get misting => 'misting';

  @override
  String get transplanting => 'transplanting';

  @override
  String get water_changing => 'water changing';

  @override
  String get observation => 'observation';

  @override
  String get treatment => 'treatment';

  @override
  String get propagating => 'propagating';

  @override
  String get pruning => 'pruning';

  @override
  String get repotting => 'repotting';

  @override
  String get recents => 'Recents';

  @override
  String get addNewEvent => 'Add new event';

  @override
  String get selectDate => 'Select date';

  @override
  String get selectEvents => 'Select events';

  @override
  String get selectPlants => 'Select plants';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'events',
      one: 'event',
    );
    return 'Created $countString new $_temp0';
  }

  @override
  String get addNote => 'Add note';

  @override
  String get enterNote => 'Enter note';

  @override
  String get selectAtLeastOnePlant => 'Select at least one plant';

  @override
  String get selectAtLeastOneEvent => 'Select at least one event';

  @override
  String get eventSuccessfullyUpdated => 'Event updated successfully';

  @override
  String get editEvent => 'Edit event';

  @override
  String get eventSuccessfullyDeleted => 'Event deleted successfully';

  @override
  String get noInfoAvailable => 'No info available';

  @override
  String get species => 'Species';

  @override
  String get plant => 'Plant';

  @override
  String get scientificClassification => 'Scientific classification';

  @override
  String get family => 'Family';

  @override
  String get genus => 'Genus';

  @override
  String get synonyms => 'Synonyms';

  @override
  String get care => 'Care';

  @override
  String get light => 'Light';

  @override
  String get humidity => 'Humidity';

  @override
  String get maxTemp => 'Maximum temperature';

  @override
  String get minTemp => 'Minimum temperature';

  @override
  String get minPh => 'Minimum ph';

  @override
  String get maxPh => 'Maximum ph';

  @override
  String get info => 'Info';

  @override
  String get addPhotos => 'Add photos';

  @override
  String get addEvents => 'Add events';

  @override
  String get modifyPlant => 'Modify plant';

  @override
  String get removePlant => 'Remove plant';

  @override
  String get useBirthday => 'Use birthday';

  @override
  String get birthday => 'Birthday';

  @override
  String get avatar => 'Avatar';

  @override
  String get note => 'Note';

  @override
  String get stats => 'Stats';

  @override
  String get eventStats => 'Events stats';

  @override
  String get age => 'Age';

  @override
  String get newBorn => 'New born';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'days',
      one: 'day',
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
      other: 'months',
      one: 'month',
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
      other: 'years',
      one: 'year',
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
      other: 'months',
      one: 'month',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
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
      other: 'years',
      one: 'year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
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
      other: 'years',
      one: 'year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'months',
      one: 'month',
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
      other: 'years',
      one: 'year',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'months',
      one: 'month',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
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

    return '$valueString out of $maxString';
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
  String get numberOfPhotos => 'Number of photos';

  @override
  String get numberOfEvents => 'Number of events';

  @override
  String get searchInYourPlants => 'Search in your plants';

  @override
  String get searchNewGreenFriends => 'Search new green friends';

  @override
  String get custom => 'Custom';

  @override
  String get addPlant => 'Add Plant';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get pleaseConfirm => 'Please confirm';

  @override
  String get areYouSureToRemoveEvent => 'Are you sure to remove the event?';

  @override
  String get areYouSureToRemoveReminder =>
      'Are you sure to remove the reminder?';

  @override
  String get areYouSureToRemoveSpecies => 'Are you sure to remove the species?';

  @override
  String get areYouSureToRemovePlant => 'Are you sure to remove the plant?';

  @override
  String get purchasedPrice => 'Purchased price';

  @override
  String get seller => 'Seller';

  @override
  String get location => 'Location';

  @override
  String get currency => 'Currency';

  @override
  String get plantUpdatedSuccessfully => 'Plant updated successfully';

  @override
  String get plantCreatedSuccessfully => 'Plant created successfully';

  @override
  String get insertPrice => 'Insert price';

  @override
  String get noBirthday => 'No birthday';

  @override
  String get appVersion => 'App version';

  @override
  String get serverVersion => 'Server version';

  @override
  String get documentation => 'Documentation';

  @override
  String get openSource => 'Open source';

  @override
  String get reportIssue => 'Report issue';

  @override
  String get logout => 'Logout';

  @override
  String get eventCount => 'Event count';

  @override
  String get plantCount => 'Plant count';

  @override
  String get speciesCount => 'Species count';

  @override
  String get imageCount => 'Image count';

  @override
  String get unknown => 'Unknown';

  @override
  String get account => 'Account';

  @override
  String get changePassword => 'Change password';

  @override
  String get more => 'More';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get currentPassword => 'Current password';

  @override
  String get updatePassword => 'Update password';

  @override
  String get updateProfile => 'Update profile';

  @override
  String get newPassword => 'New password';

  @override
  String get removeEvent => 'Remove event';

  @override
  String get appLog => 'App log';

  @override
  String get passwordUpdated => 'Password successfully updated';

  @override
  String get userUpdated => 'User successfully updated';

  @override
  String get noChangesDetected => 'No changes detected';

  @override
  String get plantDeletedSuccessfully => 'Plant successfully deleted';

  @override
  String get server => 'Server';

  @override
  String get notifications => 'Notifications';

  @override
  String get changeServer => 'Change server';

  @override
  String get serverUpdated => 'Server successfully updated';

  @override
  String get changeNotifications => 'Change notifications';

  @override
  String get updateNotifications => 'Update notifications';

  @override
  String get notificationUpdated => 'Notification successfully updated';

  @override
  String get supportTheProject => 'Support the project';

  @override
  String get buyMeACoffee => 'Buy me a coffee';

  @override
  String get gallery => 'Gallery';

  @override
  String photosOf(String name) {
    return 'Photos of $name';
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
      other: 'photos',
      one: 'photo',
    );
    return 'Uploaded $countString new $_temp0';
  }

  @override
  String get errorCreatingPlant => 'Error while creating plant';

  @override
  String get noImages => 'No images';

  @override
  String get errorCreatingSpecies => 'Error while creating species';

  @override
  String get errorUpdatingSpecies => 'Error while updating species';

  @override
  String get speciesUpdatedSuccessfully => 'Species successfully updated';

  @override
  String get addCustom => 'Add custom';

  @override
  String get speciesCreatedSuccessfully => 'Species successfully created';

  @override
  String get uploadPhoto => 'Upload Photo';

  @override
  String get linkURL => 'Link URL';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get actions => 'Actions';

  @override
  String get areYouSureToRemovePhoto => 'Are you sure to remove the photo?';

  @override
  String get photoSuccessfullyDeleted => 'Photo deleted successfully';

  @override
  String get errorUpdatingPlant => 'Error updating plant';

  @override
  String get reminders => 'Reminders';

  @override
  String get selectStartDate => 'Select start date';

  @override
  String get selectEndDate => 'Select end date';

  @override
  String get addNewReminder => 'Add new reminder';

  @override
  String get noEndDate => 'No end date';

  @override
  String get frequency => 'Frequency';

  @override
  String get repeatAfter => 'Repeat after';

  @override
  String get addNew => 'Add new';

  @override
  String get reminderCreatedSuccessfully => 'Reminder successfully created';

  @override
  String get startAndEndDateOrderError => 'Start date must be before end date';

  @override
  String get reminderUpdatedSuccessfully => 'Reminder successfully updated';

  @override
  String get reminderDeletedSuccessfully => 'Reminder successfully deleted';

  @override
  String get errorResettingPassword => 'Error while resetting password';

  @override
  String get resetPassword => 'Reset password';

  @override
  String get resetPasswordHeader =>
      'Insert the username below in order to send a reset password request';

  @override
  String get editReminder => 'Edit reminder';

  @override
  String get ntfyServerUrl => 'Ntfy server URL';

  @override
  String get ntfyServerTopic => 'Ntfy server topic';

  @override
  String get ntfyServerUsername => 'Ntfy server username';

  @override
  String get ntfyServerPassword => 'Ntfy server password';

  @override
  String get ntfyServerToken => 'Ntfy server token';

  @override
  String get enterValidTopic => 'Please enter a valid topic';

  @override
  String get ntfySettings => 'Ntfy settings';

  @override
  String get ntfySettingsUpdated => 'Ntfy settings correctly updated';

  @override
  String get modifySpecies => 'Modify species';

  @override
  String get removeSpecies => 'Delete species';

  @override
  String get speciesDeletedSuccessfully => 'Species successfully deleted';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get ops => 'Ops!';

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
