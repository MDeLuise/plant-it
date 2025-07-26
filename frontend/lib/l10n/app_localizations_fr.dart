// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get enterValue => 'Veuillez saisir une valeur';

  @override
  String get enterValidURL => 'Veuillez saisir une URL valide';

  @override
  String get go => 'Continuer';

  @override
  String get noBackend => 'Impossible de se connecter au serveur';

  @override
  String get ok => 'Ok';

  @override
  String get serverURL => 'URL du serveur';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get login => 'Se connecter';

  @override
  String get badCredentials => 'Identifiants incorrects';

  @override
  String get loginMessage => 'Bienvenue sur';

  @override
  String get signupMessage => 'Bienvenue sur';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => 'Mot de passe oublié?';

  @override
  String get areYouNew => 'Êtes-vous nouveau?';

  @override
  String get createAccount => 'Créer un compte';

  @override
  String get email => 'Email';

  @override
  String get usernameSize =>
      'La longueur du nom d\'utilisateur doit être entre 3 et 20 caractères';

  @override
  String get passwordSize =>
      'La longueur du mot de passe doit être entre 6 et 20 caractères';

  @override
  String get enterValidEmail => 'Veuillez saisir une adresse email valide';

  @override
  String get alreadyRegistered => 'Déjà enregistré?';

  @override
  String get signup => 'S\'inscrire';

  @override
  String get generalError => 'Erreur lors de l\'opération';

  @override
  String get error => 'Erreur';

  @override
  String get details => 'Détails';

  @override
  String get insertBackendURL =>
      'Salut l\'ami! Laissons la magie operer, commencez par configurer l\'URL de votre serveur.';

  @override
  String get loginTagline => 'Explorer, apprendre et cultiver!';

  @override
  String get singupTagline => 'Cultivons ensemble!';

  @override
  String get sentOTPCode => 'Veuillez insérer le code envoyé par email à: ';

  @override
  String get verify => 'Vérifier';

  @override
  String get resendCode => 'Renvoyer le code';

  @override
  String get otpCode => 'Code OTP';

  @override
  String get splashLoading =>
      'Beep boop beep... Chargement des données depuis le serveur!';

  @override
  String get welcomeBack => 'Bienvenue de retour';

  @override
  String hello(String userName) {
    return 'Bonjour, $userName';
  }

  @override
  String get search => 'Recherche';

  @override
  String get today => 'aujourd\'hui';

  @override
  String get yesterday => 'hier';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'jours',
      one: 'jour',
    );
    return 'Il y a $countString $_temp0';
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
      other: 'jours',
      one: 'jour',
    );
    return 'Dans $countString $_temp0 à l\'avenir (quoi?)';
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
      other: 'mois',
      one: 'mois',
    );
    return 'Il y a $countString $_temp0';
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
      other: 'ans',
      one: 'an',
    );
    return 'Il y a $countString $_temp0';
  }

  @override
  String get events => 'Événements';

  @override
  String get plants => 'Plantes';

  @override
  String get or => 'ou';

  @override
  String get filter => 'Filtre';

  @override
  String get seeding => 'semis';

  @override
  String get watering => 'arrosage';

  @override
  String get fertilizing => 'fertilisation';

  @override
  String get biostimulating => 'biostimulation';

  @override
  String get misting => 'brumisation';

  @override
  String get transplanting => 'transplantation';

  @override
  String get water_changing => 'changement d\'eau';

  @override
  String get observation => 'observation';

  @override
  String get treatment => 'traitement';

  @override
  String get propagating => 'multiplication';

  @override
  String get pruning => 'taille';

  @override
  String get repotting => 'rempotage';

  @override
  String get recents => 'Récents';

  @override
  String get addNewEvent => 'Ajouter un nouvel événement';

  @override
  String get selectDate => 'Sélectionner une date';

  @override
  String get selectEvents => 'Sélectionner des événements';

  @override
  String get selectPlants => 'Sélectionner des plantes';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'événements',
      one: 'événement',
    );
    return '$countString $_temp0 créés';
  }

  @override
  String get addNote => 'Ajouter une note';

  @override
  String get enterNote => 'Entrer une note';

  @override
  String get selectAtLeastOnePlant => 'Sélectionnez au moins une plante';

  @override
  String get selectAtLeastOneEvent => 'Sélectionnez au moins un événement';

  @override
  String get eventSuccessfullyUpdated => 'Événement mis à jour avec succès';

  @override
  String get editEvent => 'Modifier l\'événement';

  @override
  String get eventSuccessfullyDeleted => 'Événement supprimé avec succès';

  @override
  String get noInfoAvailable => 'Aucune information disponible';

  @override
  String get species => 'Espèce';

  @override
  String get plant => 'Plante';

  @override
  String get scientificClassification => 'Classification scientifique';

  @override
  String get family => 'Famille';

  @override
  String get genus => 'Genre';

  @override
  String get synonyms => 'Synonymes';

  @override
  String get care => 'Soins';

  @override
  String get light => 'Lumière';

  @override
  String get humidity => 'Humidité';

  @override
  String get maxTemp => 'Température maximale';

  @override
  String get minTemp => 'Température minimale';

  @override
  String get minPh => 'pH minimal';

  @override
  String get maxPh => 'pH maximal';

  @override
  String get info => 'Info';

  @override
  String get addPhotos => 'Ajouter des photos';

  @override
  String get addEvents => 'Ajouter des événements';

  @override
  String get modifyPlant => 'Modifier la plante';

  @override
  String get removePlant => 'Supprimer la plante';

  @override
  String get useBirthday => 'Utiliser la date de naissance';

  @override
  String get birthday => 'Date de naissance';

  @override
  String get avatar => 'Avatar';

  @override
  String get note => 'Note';

  @override
  String get stats => 'Statistiques';

  @override
  String get eventStats => 'Statistiques des événements';

  @override
  String get age => 'Âge';

  @override
  String get newBorn => 'Nouveau-né';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'jours',
      one: 'jour',
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
      other: 'mois',
      one: 'mois',
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
      other: 'ans',
      one: 'an',
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
      other: 'mois',
      one: 'mois',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'jours',
      one: 'jour',
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
      other: 'ans',
      one: 'an',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'jours',
      one: 'jour',
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
      other: 'ans',
      one: 'an',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'mois',
      one: 'mois',
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
      other: 'ans',
      one: 'an',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'mois',
      one: 'mois',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'jours',
      one: 'jour',
    );
    return '$yearsString $_temp0, $monthsString $_temp1, $daysString $_temp2';
  }

  @override
  String get name => 'Nom';

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

    return '$valueString sur $maxString';
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
  String get numberOfPhotos => 'Nombre de photos';

  @override
  String get numberOfEvents => 'Nombre d\'événements';

  @override
  String get searchInYourPlants => 'Recherche dans vos plantes';

  @override
  String get searchNewGreenFriends => 'Rechercher de nouveaux amis verts';

  @override
  String get custom => 'Personnalisé';

  @override
  String get addPlant => 'Ajouter une plante';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get pleaseConfirm => 'Veuillez confirmer';

  @override
  String get areYouSureToRemoveEvent =>
      'Êtes-vous sûr de vouloir supprimer l\'événement?';

  @override
  String get areYouSureToRemoveReminder =>
      'Êtes-vous sûr de vouloir supprimer le rappel?';

  @override
  String get areYouSureToRemoveSpecies =>
      'Êtes-vous sûr de vouloir supprimer l\'espèce?';

  @override
  String get areYouSureToRemovePlant =>
      'Êtes-vous sûr de vouloir supprimer la plante?';

  @override
  String get purchasedPrice => 'Prix d\'achat';

  @override
  String get seller => 'Vendeur';

  @override
  String get location => 'Emplacement';

  @override
  String get currency => 'Devise';

  @override
  String get plantUpdatedSuccessfully => 'Plante mise à jour avec succès';

  @override
  String get plantCreatedSuccessfully => 'Plante créée avec succès';

  @override
  String get insertPrice => 'Insérer le prix';

  @override
  String get noBirthday => 'Pas de date d\'anniversaire';

  @override
  String get appVersion => 'Version de l\'application';

  @override
  String get serverVersion => 'Version du serveur';

  @override
  String get documentation => 'Documentation';

  @override
  String get openSource => 'Open source';

  @override
  String get reportIssue => 'Signaler un problème';

  @override
  String get logout => 'Déconnexion';

  @override
  String get eventCount => 'Nombre d\'événements';

  @override
  String get plantCount => 'Nombre de plantes';

  @override
  String get speciesCount => 'Nombre d\'espèces';

  @override
  String get imageCount => 'Nombre d\'images';

  @override
  String get unknown => 'Inconnu';

  @override
  String get account => 'Compte';

  @override
  String get changePassword => 'Changer de mot de passe';

  @override
  String get more => 'Plus';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get updatePassword => 'Mettre à jour le mot de passe';

  @override
  String get updateProfile => 'Mettre à jour le profil';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get removeEvent => 'Supprimer l\'événement';

  @override
  String get appLog => 'Journal de l\'application';

  @override
  String get passwordUpdated => 'Mot de passe mis à jour avec succès';

  @override
  String get userUpdated => 'Utilisateur mis à jour avec succès';

  @override
  String get noChangesDetected => 'Aucun changement détecté';

  @override
  String get plantDeletedSuccessfully => 'Plante supprimée avec succès';

  @override
  String get server => 'Serveur';

  @override
  String get notifications => 'Notifications';

  @override
  String get changeServer => 'Changer de serveur';

  @override
  String get serverUpdated => 'Serveur mis à jour avec succès';

  @override
  String get changeNotifications => 'Modifier les notifications';

  @override
  String get updateNotifications => 'Mettre à jour les notifications';

  @override
  String get notificationUpdated => 'Notification mise à jour avec succès';

  @override
  String get supportTheProject => 'Soutenir le projet';

  @override
  String get buyMeACoffee => 'Offrez-moi un café';

  @override
  String get gallery => 'Galerie';

  @override
  String photosOf(String name) {
    return 'Photos de $name';
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
    return '$countString $_temp0 téléchargées';
  }

  @override
  String get errorCreatingPlant => 'Erreur lors de la création de la plante';

  @override
  String get noImages => 'Aucune image';

  @override
  String get errorCreatingSpecies => 'Erreur lors de la création de l\'espèce';

  @override
  String get errorUpdatingSpecies =>
      'Erreur lors de la mise à jour de l\'espèce';

  @override
  String get speciesUpdatedSuccessfully => 'Espèce mise à jour avec succès';

  @override
  String get addCustom => 'Ajouter personnalisé';

  @override
  String get speciesCreatedSuccessfully => 'Espèce créée avec succès';

  @override
  String get uploadPhoto => 'Télécharger une photo';

  @override
  String get linkURL => 'URL du lien';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Confirmer';

  @override
  String get cancel => 'Annuler';

  @override
  String get actions => 'Actions';

  @override
  String get areYouSureToRemovePhoto =>
      'Êtes-vous sûr de vouloir supprimer la photo?';

  @override
  String get photoSuccessfullyDeleted => 'Photo supprimée avec succès';

  @override
  String get errorUpdatingPlant => 'Erreur lors de la mise à jour de la plante';

  @override
  String get reminders => 'Rappels';

  @override
  String get selectStartDate => 'Sélectionner la date de début';

  @override
  String get selectEndDate => 'Sélectionner la date de fin';

  @override
  String get addNewReminder => 'Ajouter un nouveau rappel';

  @override
  String get noEndDate => 'Pas de date de fin';

  @override
  String get frequency => 'Fréquence';

  @override
  String get repeatAfter => 'Répéter après';

  @override
  String get addNew => 'Ajouter un nouveau';

  @override
  String get reminderCreatedSuccessfully => 'Rappel créé avec succès';

  @override
  String get startAndEndDateOrderError =>
      'La date de début doit être antérieure à la date de fin';

  @override
  String get reminderUpdatedSuccessfully => 'Rappel mis à jour avec succès';

  @override
  String get reminderDeletedSuccessfully => 'Rappel supprimé avec succès';

  @override
  String get errorResettingPassword =>
      'Erreur lors de la réinitialisation du mot de passe';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get resetPasswordHeader =>
      'Insérez le nom d\'utilisateur ci-dessous pour envoyer une demande de réinitialisation de mot de passe';

  @override
  String get editReminder => 'Modifier le rappel';

  @override
  String get ntfyServerUrl => 'URL du serveur Ntfy';

  @override
  String get ntfyServerTopic => 'Sujet du serveur Ntfy';

  @override
  String get ntfyServerUsername => 'Nom d\'utilisateur du serveur Ntfy';

  @override
  String get ntfyServerPassword => 'Mot de passe du serveur Ntfy';

  @override
  String get ntfyServerToken => 'Jeton du serveur Ntfy';

  @override
  String get enterValidTopic => 'Veuillez entrer un sujet valide';

  @override
  String get ntfySettings => 'Paramètres de Ntfy';

  @override
  String get ntfySettingsUpdated =>
      'Paramètres de Ntfy mis à jour correctement';

  @override
  String get modifySpecies => 'Modifier l\'espèce';

  @override
  String get removeSpecies => 'Supprimer l\'espèce';

  @override
  String get speciesDeletedSuccessfully => 'Espèce supprimée avec succès';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Avertissement';

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
