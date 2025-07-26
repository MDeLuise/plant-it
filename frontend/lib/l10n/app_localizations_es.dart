// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get enterValue => 'Por favor, introduce un valor';

  @override
  String get enterValidURL => 'Por favor, introduce una URL válida';

  @override
  String get go => 'Continuar';

  @override
  String get noBackend => 'No se puede conectar al servidor';

  @override
  String get ok => 'Vale';

  @override
  String get serverURL => 'URL del servidor';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get badCredentials => 'Credenciales incorrectas';

  @override
  String get loginMessage => 'Bienvenido de nuevo a';

  @override
  String get signupMessage => 'Bienvenido a';

  @override
  String get appName => 'Plant-it';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get areYouNew => '¿Eres nuevo?';

  @override
  String get createAccount => 'Crear una cuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get usernameSize =>
      'La longitud del nombre de usuario debe estar entre 3 y 20 caracteres';

  @override
  String get passwordSize =>
      'La longitud de la contraseña debe estar entre 6 y 20 caracteres';

  @override
  String get enterValidEmail =>
      'Por favor, introduce un correo electrónico válido';

  @override
  String get alreadyRegistered => '¿Ya estás registrado?';

  @override
  String get signup => 'Registrarse';

  @override
  String get generalError => 'Error al realizar la operación';

  @override
  String get error => 'Error';

  @override
  String get details => 'Detalles';

  @override
  String get insertBackendURL =>
      '¡Hola amigo! Hagamos que la magia suceda, comienza configurando la URL de tu servidor.';

  @override
  String get loginTagline => '¡Explora, aprende y cultiva!';

  @override
  String get singupTagline => '¡Crezcamos juntos!';

  @override
  String get sentOTPCode =>
      'Por favor, introduce el código enviado por correo electrónico a: ';

  @override
  String get verify => 'Verificar';

  @override
  String get resendCode => 'Reenviar código';

  @override
  String get otpCode => 'Código OTP';

  @override
  String get splashLoading => 'Beep boop beep... Cargando datos del servidor!';

  @override
  String get welcomeBack => 'Bienvenido de nuevo';

  @override
  String hello(String userName) {
    return 'Hola, $userName';
  }

  @override
  String get search => 'Buscar';

  @override
  String get today => 'hoy';

  @override
  String get yesterday => 'ayer';

  @override
  String nDaysAgo(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    return 'hace $countString $_temp0';
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
      other: 'días',
      one: 'día',
    );
    return '$countString $_temp0 en el futuro (¿qué?)';
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
      other: 'meses',
      one: 'mes',
    );
    return 'hace $countString $_temp0';
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
      other: 'años',
      one: 'año',
    );
    return 'hace $countString $_temp0';
  }

  @override
  String get events => 'Eventos';

  @override
  String get plants => 'Plantas';

  @override
  String get or => 'o';

  @override
  String get filter => 'Filtrar';

  @override
  String get seeding => 'sembrando';

  @override
  String get watering => 'regar';

  @override
  String get fertilizing => 'fertilizar';

  @override
  String get biostimulating => 'bioestimular';

  @override
  String get misting => 'nebulizar';

  @override
  String get transplanting => 'trasplantar';

  @override
  String get water_changing => 'cambio de agua';

  @override
  String get observation => 'observación';

  @override
  String get treatment => 'tratamiento';

  @override
  String get propagating => 'propagar';

  @override
  String get pruning => 'poda';

  @override
  String get repotting => 'trasplante';

  @override
  String get recents => 'Recientes';

  @override
  String get addNewEvent => 'Añadir nuevo evento';

  @override
  String get selectDate => 'Seleccionar fecha';

  @override
  String get selectEvents => 'Seleccionar eventos';

  @override
  String get selectPlants => 'Seleccionar plantas';

  @override
  String nEventsCreated(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'eventos',
      one: 'evento',
    );
    return 'Creado $countString nuevo $_temp0';
  }

  @override
  String get addNote => 'Añadir nota';

  @override
  String get enterNote => 'Introducir nota';

  @override
  String get selectAtLeastOnePlant => 'Selecciona al menos una planta';

  @override
  String get selectAtLeastOneEvent => 'Selecciona al menos un evento';

  @override
  String get eventSuccessfullyUpdated => 'Evento actualizado con éxito';

  @override
  String get editEvent => 'Editar evento';

  @override
  String get eventSuccessfullyDeleted => 'Evento eliminado con éxito';

  @override
  String get noInfoAvailable => 'No hay información disponible';

  @override
  String get species => 'Especies';

  @override
  String get plant => 'Planta';

  @override
  String get scientificClassification => 'Clasificación científica';

  @override
  String get family => 'Familia';

  @override
  String get genus => 'Género';

  @override
  String get synonyms => 'Sinónimos';

  @override
  String get care => 'Cuidado';

  @override
  String get light => 'Luz';

  @override
  String get humidity => 'Humedad';

  @override
  String get maxTemp => 'Temperatura máxima';

  @override
  String get minTemp => 'Temperatura mínima';

  @override
  String get minPh => 'pH mínimo';

  @override
  String get maxPh => 'pH máximo';

  @override
  String get info => 'Información';

  @override
  String get addPhotos => 'Añadir fotos';

  @override
  String get addEvents => 'Añadir eventos';

  @override
  String get modifyPlant => 'Modificar planta';

  @override
  String get removePlant => 'Eliminar planta';

  @override
  String get useBirthday => 'Usar fecha de nacimiento';

  @override
  String get birthday => 'Fecha de nacimiento';

  @override
  String get avatar => 'Avatar';

  @override
  String get note => 'Nota';

  @override
  String get stats => 'Estadísticas';

  @override
  String get eventStats => 'Estadísticas de eventos';

  @override
  String get age => 'Edad';

  @override
  String get newBorn => 'Recién nacido';

  @override
  String nDays(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'días',
      one: 'día',
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
      other: 'meses',
      one: 'mes',
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
      other: 'años',
      one: 'año',
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
      other: 'meses',
      one: 'mes',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
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
      other: 'años',
      one: 'año',
    );
    String _temp1 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
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
      other: 'años',
      one: 'año',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'meses',
      one: 'mes',
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
      other: 'años',
      one: 'año',
    );
    String _temp1 = intl.Intl.pluralLogic(
      months,
      locale: localeName,
      other: 'meses',
      one: 'mes',
    );
    String _temp2 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    return '$yearsString $_temp0, $monthsString $_temp1, $daysString $_temp2';
  }

  @override
  String get name => 'Nombre';

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

    return '$valueString de $maxString';
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
  String get numberOfPhotos => 'Número de fotos';

  @override
  String get numberOfEvents => 'Número de eventos';

  @override
  String get searchInYourPlants => 'Buscar en tus plantas';

  @override
  String get searchNewGreenFriends => 'Buscar nuevos amigos verdes';

  @override
  String get custom => 'Personalizado';

  @override
  String get addPlant => 'Añadir planta';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get pleaseConfirm => 'Por favor confirma';

  @override
  String get areYouSureToRemoveEvent =>
      '¿Estás seguro de que quieres eliminar el evento?';

  @override
  String get areYouSureToRemoveReminder =>
      '¿Estás seguro de que quieres eliminar el recordatorio?';

  @override
  String get areYouSureToRemoveSpecies =>
      '¿Estás seguro de que quieres eliminar la especie?';

  @override
  String get areYouSureToRemovePlant =>
      '¿Estás seguro de que quieres eliminar la planta?';

  @override
  String get purchasedPrice => 'Precio de compra';

  @override
  String get seller => 'Vendedor';

  @override
  String get location => 'Ubicación';

  @override
  String get currency => 'Moneda';

  @override
  String get plantUpdatedSuccessfully => 'Planta actualizada con éxito';

  @override
  String get plantCreatedSuccessfully => 'Planta creada con éxito';

  @override
  String get insertPrice => 'Introduce el precio';

  @override
  String get noBirthday => 'Sin fecha de nacimiento';

  @override
  String get appVersion => 'Versión de la aplicación';

  @override
  String get serverVersion => 'Versión del servidor';

  @override
  String get documentation => 'Documentación';

  @override
  String get openSource => 'Código abierto';

  @override
  String get reportIssue => 'Reportar problema';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get eventCount => 'Conteo de eventos';

  @override
  String get plantCount => 'Conteo de plantas';

  @override
  String get speciesCount => 'Conteo de especies';

  @override
  String get imageCount => 'Conteo de imágenes';

  @override
  String get unknown => 'Desconocido';

  @override
  String get account => 'Cuenta';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get more => 'Más';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get updatePassword => 'Actualizar contraseña';

  @override
  String get updateProfile => 'Actualizar perfil';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get removeEvent => 'Eliminar evento';

  @override
  String get appLog => 'Registro de la aplicación';

  @override
  String get passwordUpdated => 'Contraseña actualizada con éxito';

  @override
  String get userUpdated => 'Usuario actualizado con éxito';

  @override
  String get noChangesDetected => 'No se detectaron cambios';

  @override
  String get plantDeletedSuccessfully => 'Planta eliminada con éxito';

  @override
  String get server => 'Servidor';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get changeServer => 'Cambiar servidor';

  @override
  String get serverUpdated => 'Servidor actualizado con éxito';

  @override
  String get changeNotifications => 'Cambiar notificaciones';

  @override
  String get updateNotifications => 'Actualizar notificaciones';

  @override
  String get notificationUpdated => 'Notificación actualizada con éxito';

  @override
  String get supportTheProject => 'Apoya el proyecto';

  @override
  String get buyMeACoffee => 'Invítame a un café';

  @override
  String get gallery => 'Galería';

  @override
  String photosOf(String name) {
    return 'Fotos de $name';
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
      other: 'fotos',
      one: 'foto',
    );
    return 'Subidas $countString nuevas $_temp0';
  }

  @override
  String get errorCreatingPlant => 'Error al crear la planta';

  @override
  String get noImages => 'No hay imágenes';

  @override
  String get errorCreatingSpecies => 'Error al crear especies';

  @override
  String get errorUpdatingSpecies => 'Error al actualizar especies';

  @override
  String get speciesUpdatedSuccessfully => 'Especies actualizadas con éxito';

  @override
  String get addCustom => 'Añadir personalizado';

  @override
  String get speciesCreatedSuccessfully => 'Especies creadas con éxito';

  @override
  String get uploadPhoto => 'Subir foto';

  @override
  String get linkURL => 'Enlace URL';

  @override
  String get url => 'URL';

  @override
  String get submit => 'Confirmar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get actions => 'Acciones';

  @override
  String get areYouSureToRemovePhoto =>
      '¿Estás seguro de que quieres eliminar la foto?';

  @override
  String get photoSuccessfullyDeleted => 'Foto eliminada con éxito';

  @override
  String get errorUpdatingPlant => 'Error al actualizar la planta';

  @override
  String get reminders => 'Recordatorios';

  @override
  String get selectStartDate => 'Seleccionar fecha de inicio';

  @override
  String get selectEndDate => 'Seleccionar fecha de fin';

  @override
  String get addNewReminder => 'Añadir nuevo recordatorio';

  @override
  String get noEndDate => 'Sin fecha de fin';

  @override
  String get frequency => 'Frecuencia';

  @override
  String get repeatAfter => 'Repetir después';

  @override
  String get addNew => 'Añadir nuevo';

  @override
  String get reminderCreatedSuccessfully => 'Recordatorio creado con éxito';

  @override
  String get startAndEndDateOrderError =>
      'La fecha de inicio debe ser antes de la fecha de fin';

  @override
  String get reminderUpdatedSuccessfully =>
      'Recordatorio actualizado con éxito';

  @override
  String get reminderDeletedSuccessfully => 'Recordatorio eliminado con éxito';

  @override
  String get errorResettingPassword => 'Error al restablecer la contraseña';

  @override
  String get resetPassword => 'Restablecer contraseña';

  @override
  String get resetPasswordHeader =>
      'Introduce el nombre de usuario a continuación para enviar una solicitud de restablecimiento de contraseña';

  @override
  String get editReminder => 'Editar recordatorio';

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
